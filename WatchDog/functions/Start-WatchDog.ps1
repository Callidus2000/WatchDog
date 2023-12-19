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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessforStateChangingFunctions', '')]
    param (
        [parameter(Mandatory = $true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("WatchDog.instances")]
        [string]$Name
    )
    Register-WatchDogEventListener -Name $Name
    $config = Get-WatchDogConfig -Name $Name
    $config.checkScript = [scriptblock]::Create($config.checkScript)
    $config.correctionScript = [scriptblock]::Create($config.correctionScript)
    do {
        $everyThingIsFine = Invoke-WatchDogScript -ScriptBlock $config.checkScript -LoggingAction "Perform Check for WatchDog Instance" -LoggingTag $Name -RetryCount $config.checkRetryCount
        if (-not $everyThingIsFine) {
            Write-PSFMessage -Level Error -Tag $Name -ErrorRecord (Get-WatchDogError) -Message "Watchdog Check failed, trying correction activity"
            $checkErrorCounter++
            $everyThingIsFine = Invoke-WatchDogScript -ScriptBlock $config.correctionScript -LoggingAction "Check failed, performing correction for WatchDog" -LoggingTag $Name -RetryCount $config.correctionRetryCount
            if (-not $everyThingIsFine) {
                # Write-PSFMessage -Level Critical -Tag $Name -ErrorRecord (Get-WatchDogError) -Message "Watchdog Correction failed, stopping instance"
                Stop-PSFFunction -Level Error -Message "Correction ScriptBlock fails, aborting execution" -EnableException $true -Tag $Name -ErrorRecord (Get-WatchDogError)
            }else{
                Write-PSFMessage -Level Host -Tag $Name -Message "Watchdog Correction succeeded"
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
}