function Remove-WatchDog {
    <#
    .SYNOPSIS
        Removes a WatchDog instance, unregistering its event listener and deleting its configuration settings.

    .DESCRIPTION
        The Remove-WatchDog function removes a WatchDog instance by unregistering its event listener and deleting its configuration settings.
        This ensures that the WatchDog instance is no longer active and its configuration is cleared.

    .PARAMETER Name
        Specifies the name of the WatchDog instance to remove. This name should match the name of the WatchDog instance to be deleted.

    .EXAMPLE
        Remove-WatchDog -Name "LocalPSU"

        Removes the WatchDog instance named "LocalPSU" by unregistering its event listener and deleting its configuration settings.

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
    Unregister-WatchDog -Name $Name
    $storedConfigs = Get-PSFConfig -Module WatchDog | Where-Object Name -like "instance.$Name*"
    $storedConfigs | ForEach-Object { $_.AllowDelete = $true }
    $storedConfigs | Unregister-PSFConfig
    $storedConfigs | Remove-PSFConfig -Confirm:$false
}