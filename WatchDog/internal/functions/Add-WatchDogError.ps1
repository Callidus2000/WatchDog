function Add-WatchDogError {
    <#
    .SYNOPSIS
        Adds a new error to the WatchDog module's error list.

    .DESCRIPTION
        The Add-WatchDogError function adds a new error to the error list in the WatchDog module.
        The error list is cached using the PSFTaskEngineCache module. The function ensures that
        only the last 10 errors are retained in the list.

    .PARAMETER NewError
        Specifies the error object to be added to the error list. This parameter is mandatory
        and can accept input from the pipeline.

    .EXAMPLE
        Add-WatchDogError -NewError $customError
        Adds a custom error object to the WatchDog error list.

    .EXAMPLE
        $customError | Add-WatchDogError
        Adds a custom error object to the WatchDog error list using the pipeline.

    .NOTES

    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)]
        $NewError
    )

    begin {
        $errorList = Get-PSFTaskEngineCache -Module WatchDog -Name LastErrors
        if ($null -eq $errorList){
            $errorList=@()
        }elseif($errorList -isnot [Array]){
            $errorList = ,$errorList
        }
    }

    process {
        $errorList+=$NewError
    }

    end {
        Set-PSFTaskEngineCache -Module WatchDog -Name LastErrors -Value ($errorList|Select-Object -last 10)
    }
}