function Get-WatchDogError {
    <#
    .SYNOPSIS
        Retrieves errors from the WatchDog module's error list.

    .DESCRIPTION
        The Get-WatchDogError function retrieves errors from the error list in the WatchDog module,
        which is cached using the PSFTaskEngineCache module. By default, it returns the last error in
        the list, but you can specify the number of errors to retrieve using the Last parameter.

    .PARAMETER Last
        Specifies the number of errors to retrieve from the error list. The default is 1.

    .EXAMPLE
        Get-WatchDogError
        Retrieves the last error from the WatchDog error list.

    .EXAMPLE
        Get-WatchDogError -Last 5
        Retrieves the last 5 errors from the WatchDog error list, index 0 is the latest

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [int]$Last=1
    )

        $errorList=Get-PSFTaskEngineCache -Module WatchDog -Name LastErrors
        if ($null -eq $errorList){
            return
        }
        if($Last -gt 1){
            $partList=$errorList|Select-Object -Last $Last
            [array]::Reverse($partList)
            return $partList
        }
        return $errorList|Select-Object -Last $Last
}