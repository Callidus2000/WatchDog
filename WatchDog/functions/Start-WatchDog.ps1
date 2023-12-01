function Start-WatchDog {
    <#
    .SYNOPSIS
        Starts a WatchDog instance that continuously monitors and corrects errors based on configured conditions.

    .DESCRIPTION
        The Start-WatchDog function initiates a WatchDog instance with the specified name.
        This instance continuously monitors a condition using a check script block and triggers a correction script block if the condition is not met.
        The function runs indefinitely, periodically checking the condition and performing corrections.

    .PARAMETER Name
        Specifies the name of the WatchDog instance to start. This name should match a configured WatchDog instance.

    .EXAMPLE
        Start-WatchDog -Name "LocalPSU"

        Initiates a WatchDog instance named "LocalPSU" and begins continuous monitoring and error correction.

    .NOTES
        Prerequisite   : PowerShell 5.1 or later
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("WatchDog.instances")]
        [string]$Name
    )
    Register-WatchDogEventListener -Name $Name
    $config = Get-WatchDogConfig -Name $Name
    $config.checkScript = [scriptblock]::Create($config.checkScript)
    $config.correctionScript = [scriptblock]::Create($config.correctionScript)
    $checkErrorCounter = 0
    do {

        $everyThingIsFine = Invoke-PSFProtectedCommand -Action "Perform Check for WatchDog Instance" -Target $Name -ScriptBlock {
            Write-PSFMessage -Level Verbose -Message "Executing {$($config.checkScript)}" -Tag $Name
            Invoke-Command $config.checkScript
        } -Level host -EnableException $false -RetryCount $config.checkRetryCount -Tag $Name
        if (Test-PSFFunctionInterrupt) {
            Stop-PSFFunction -Level Error -Message "Check ScriptBlock fails, aborting execution" -EnableException $true -Tag $Name
        }
        if (-not $everyThingIsFine) {
            $checkErrorCounter++
            Invoke-PSFProtectedCommand -Action "Check failed, performing correction for WatchDog" -Target $Name -ScriptBlock {
                Write-PSFMessage -Level Verbose -Message "Executing {$($config.correctionScript)}" -Tag $Name
                Invoke-Command $config.correctionScript
                # $config.correctionScript
            } -Level Warning -EnableException $false -RetryCount $config.correctionRetryCount -Tag $Name
            if (Test-PSFFunctionInterrupt) {
                Stop-PSFFunction -Level Error -Message "Correction ScriptBlock fails, aborting execution" -EnableException $true -Tag $Name
            }
        }
        else {
            $checkErrorCounter = 0
        }
        if ($checkErrorCounter -gt 10) {
            Write-PSFMessage -Level Warning "The last $checkErrorCounter checks have failed!" -Tag $Name
        }
        Start-Sleep -Seconds $config.checkInterval.TotalSeconds
    }while ($true)
    return $result
}