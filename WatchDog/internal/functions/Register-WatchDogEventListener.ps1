function Register-WatchDogEventListener {
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