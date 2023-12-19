function Register-WatchDogEventListener {
    <#
    .SYNOPSIS
        Registers an event listener for WatchDog logging to the Windows Event Log.

    .DESCRIPTION
        The Register-WatchDogEventListener function registers an event listener for WatchDog
        logging to the Windows Event Log. It configures the PSFramework logging provider to
        send WatchDog-related events to the Application log with a specific source name.

    .PARAMETER Name
        Specifies the name for the event listener. This name is used to uniquely identify
        the event listener instance and also to set the source name for the event log entries.

    .EXAMPLE
        Register-WatchDogEventListener -Name "WatchDogInstance1"

        Registers an event listener with the specified name for WatchDog logging.

    .NOTES
        File: WatchDogFunctions.ps1
        Author: Your Name
        Version: 1.0
        Date: December 17, 2023
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $paramSetPSFLoggingProvider = @{
        Name             = 'eventlog'
        InstanceName     = "$Name"
        LogName          = 'Application'
        Source           = "PowerShell WatchDog $Name"
        Enabled          = $true
        IncludeModules   = @('WatchDog')
        IncludeFunctions = @('Start-WatchDog')
        IncludeTags      = @("$Name")
    }
    Set-PSFLoggingProvider @paramSetPSFLoggingProvider
}