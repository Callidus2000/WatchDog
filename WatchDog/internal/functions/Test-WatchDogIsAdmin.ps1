function Test-WatchDogIsAdmin {
    <#
    .SYNOPSIS
        Tests whether the current user has administrator privileges.

    .DESCRIPTION
        The Test-WatchDogIsAdmin function checks if the current user has administrator privileges.
        If the user is an administrator, the function returns nothing; otherwise, it throws an error.

    .EXAMPLE
        Test-WatchDogIsAdmin

        Checks if the current user has administrator privileges.

    .NOTES
        Prerequisite   : PowerShell 5.1 or later
    #>
    [CmdletBinding()]
    param (
    )
    # Returns $true if current user is admin
    if (([Security.Principal.WindowsPrincipal]   [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { return}
    throw "Command needs to be run with admin priviledges"
}