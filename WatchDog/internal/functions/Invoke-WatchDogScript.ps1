function Invoke-WatchDogScript {
    <#
    .SYNOPSIS
        Invokes a script block with error handling and logging capabilities.

    .DESCRIPTION
        The Invoke-WatchDogScript function allows you to execute a script block with built-in
        error handling and logging features. It uses the Invoke-PSFProtectedCommand cmdlet for
        protection against errors, retries, and logging. If an error occurs, it can be logged and
        added to the WatchDog error list using the Add-WatchDogError function.

    .PARAMETER ScriptBlock
        Specifies the script block to be executed.

    .PARAMETER LoggingAction
        Specifies the logging action to be performed during script execution.

    .PARAMETER LoggingTag
        Specifies the logging tag associated with the script execution.

    .PARAMETER RetryCount
        Specifies the number of times the script block should be retried in case of an error.

    .EXAMPLE
        $script = {
            # Your script logic here
            Write-Host "Executing script..."
        }
        Invoke-WatchDogScript -ScriptBlock $script -LoggingAction "Log" -LoggingTag "ScriptExecution" -RetryCount 3 -EnableException

        Invokes the scriptblock incl. retry and error handling

    .NOTES
    #>
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        $ScriptBlock,
        [string]$LoggingAction,
        [string]$LoggingTag,
        [int]$RetryCount
    )
    $myLocalScriptBlock = [scriptblock]::Create($ScriptBlock)
    Invoke-PSFProtectedCommand -Action $LoggingAction -Target $LoggingTag -ScriptBlock $myLocalScriptBlock  -Level host -EnableException $false -RetryCount $RetryCount -Tag $LoggingTag -ErrorEvent {
        $args[0] | Add-WatchDogError
    }
    if (Test-PSFFunctionInterrupt) {
        Write-PSFMessage "Function interupted"
        return $false
    }
    # Write-PSFMessage "Returning $true"
    return $true
}