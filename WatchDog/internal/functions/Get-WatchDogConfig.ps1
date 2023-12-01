function Get-WatchDogConfig {
    <#
    .SYNOPSIS
        Retrieves configuration settings for a WatchDog instance based on the specified name.

    .DESCRIPTION
        The Get-WatchDogConfig function fetches the configuration settings for a WatchDog instance identified by its name.
        It retrieves and returns a hashtable containing the configuration settings. If no config with this name
        exists it will throw an exception.

    .PARAMETER Name
        Specifies the name of the WatchDog instance for which configuration settings are to be retrieved.

    .EXAMPLE
        Get-WatchDogConfig -Name "LocalPSU"

        Retrieves and returns the configuration settings for the WatchDog instance named "LocalPSU."

    .NOTES
        File Name      : WatchDogFunctions.ps1
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$Name
    )
    $storedConfig = Get-PSFConfig -Module WatchDog | Where-Object Name -like "instance.$Name*"
    if ($null -eq $storedConfig) {
        Write-PSFMessage -Level Warning "No watchdog instance $name configured."
        Stop-PSFFunction -Message "No watchdog instance $name configured." -EnableException $true -Level Warning
    }
    $configHashTable=@{}
    ForEach ($psfConfig in $storedConfig) {
        $shortName = $psfConfig.Name -replace "instance.$Name."
        Write-PSFMessage "Fullname: $($psfConfig.Name), Short: $shortName"
        $configHashTable.$shortName = $psfConfig.Value
    }
    Write-PSFMessage "Config: $($configHashTable|ConvertTo-Json -Compress)"
    return $configHashTable
}