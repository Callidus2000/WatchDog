function Register-WatchDog {
    <#
    .SYNOPSIS
        Registers a WatchDog instance and creates a scheduled task to run the Start-WatchDog command.

    .DESCRIPTION
        The Register-WatchDog function registers a WatchDog instance by creating an event listener and a scheduled task.
        The scheduled task is configured to run the Start-WatchDog command with specified parameters.

    .PARAMETER Name
        Specifies the name of the WatchDog instance to register. This name should match a configured WatchDog instance.

    .EXAMPLE
        Register-WatchDog -Name "LocalPSU"

        Registers a WatchDog instance named "LocalPSU" and creates a scheduled task to run the Start-WatchDog command.

    .NOTES
        Prerequisite   : PowerShell 5.1 or later
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("WatchDog.instances")]
        [string]$Name
    )
    $config = Get-WatchDogConfig -Name $Name
    if (-not $config) {
        Write-PSFMessage -Level Warning -Message "No WatchDog configuration for $Name available"
        return
    }
    Register-WatchDogEventListener -Name $Name
    $scheduledTaskParameter = @{
        taskname    = "Powershell Watchdog $Name"
        description = "Restart My Service after startup"
        action      = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-WindowStyle Hidden -command `"& Start-WatchDog -Name '$Name'`""
        trigger     = New-ScheduledTaskTrigger -Once -RepetitionInterval ([TimeSpan]::FromMinutes(5)) -At "00:00"
        settings    = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 2) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -StartWhenAvailable
        User        = "System"

    }
    Register-ScheduledTask @scheduledTaskParameter
}