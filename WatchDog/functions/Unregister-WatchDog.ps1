function Unregister-WatchDog {
    <#
    .SYNOPSIS
        Unregisters a WatchDog instance by removing the event listener and deleting the associated scheduled task.

    .DESCRIPTION
        The Unregister-WatchDog function removes a WatchDog instance by unregistering its event listener and deleting its associated scheduled task.
        This ensures that the WatchDog instance is no longer active, and its configuration is cleared.

    .PARAMETER Name
        Specifies the name of the WatchDog instance to unregister. This name should match the name of the WatchDog instance to be removed.

    .EXAMPLE
        Unregister-WatchDog -Name "LocalPSU"

        Removes the WatchDog instance named "LocalPSU" by removing its event listener and deleting its scheduled task.

    .NOTES
        Prerequisite   : PowerShell 5.1 or later
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("WatchDog.instances")]
        [string]$Name
    )
    Remove-PSFLoggingProviderRunspace -InstanceName $Name -ProviderName eventlog
    $task = Get-ScheduledTask -TaskName "Powershell Watchdog $Name"
    if ($task) {
        $task | Stop-ScheduledTask
        $task | Unregister-ScheduledTask -Confirm:$false
    }
}