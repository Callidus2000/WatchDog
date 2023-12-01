﻿function Build-WatchDog {
    <#
    .SYNOPSIS
        Builds and configures a WatchDog instance to monitor and correct errors based on specified conditions.

    .DESCRIPTION
        The Build-WatchDog function creates a WatchDog instance that monitors a specified condition and triggers an error correction script when necessary.

    .PARAMETER Name
        Specifies the name of the WatchDog instance. This name is used to identify and configure the WatchDog instance.

    .PARAMETER Check
        Specifies a script block that defines the condition to be monitored by the WatchDog. The WatchDog triggers the error correction script if this condition is not met.

    .PARAMETER ErrorCorrection
        Specifies a script block that contains the corrective actions to be taken when the WatchDog detects an error based on the specified condition.

    .PARAMETER CheckInterval
        Specifies the time interval at which the WatchDog should check the specified condition. The default interval is 5 minutes.

    .PARAMETER CorrectionRetryCount
        Specifies the number of times the error correction script should be retried if it fails. The default retry count is 4.

    .EXAMPLE
        Build-WatchDog -Name "LocalPSU" -Check {
            try {
                (Invoke-WebRequest http://localhost:5000/api/v1/alive -ErrorAction Stop).StatusCode -eq 200
            } catch {
                $false
            }
        } -ErrorCorrection {
            Restart-Service powershelluniversal
        }

        Creates a WatchDog instance named "LocalPSU" that monitors the specified web request condition. If the condition is not met, it restarts the "powershelluniversal" service.

    .NOTES
        File Name      : WatchDogFunctions.ps1
        Author         : Sascha Spiekermann
        Prerequisite   : PowerShell 5.1 or later

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [PSFramework.TabExpansion.PsfArgumentCompleterAttribute("WatchDog.instances")]
        [string]$Name,
        [parameter(Mandatory=$true)]
        [scriptblock]$Check,
        [parameter(Mandatory=$true)]
        [scriptblock]$ErrorCorrection,
        [timespan]$CheckInterval = [timespan]::FromMinutes(5),
        [int]$CorrectionRetryCount=4,
        [int]$CheckRetryCount=4
    )
    Test-WatchDogIsAdmin
    # Build-WatchDog -Name "LocalPSU" -Check { try { (Invoke-WebRequest http://localhost:5000/api/v1/alive -ErrorAction stop).Statuscode -eq 200 }catch { $false } } -ErrorCorrection { restart-service powershelluniversal}
    # Build-WatchDog -Name "checkFail" -Check { $false } -ErrorCorrection { Write-PSFMessage "Correcting"} -CheckRetryCount 2 -CheckInterval  ([timespan]::FromTicks(5))
    # Build-WatchDog -Name "checkThrows" -Check { throw "error while checking" } -ErrorCorrection { Write-PSFMessage "Correcting"} -CheckRetryCount 2 -CheckInterval  ([timespan]::FromTicks(5))
    # Build-WatchDog -Name "actionThrows" -Check { $false } -ErrorCorrection { throw "Exception while Correcting"} -CheckRetryCount 2 -CheckInterval  ([timespan]::FromTicks(5))
    $commonParam=@{
        module='WatchDog'
        AllowDelete=$true
        PassThru=$true
    }
    Set-PSFConfig @commonParam -Name "instance.$Name.checkScript" -Value $Check |Register-PSFConfig -Scope SystemDefault
    Set-PSFConfig @commonParam -Name "instance.$Name.correctionScript" -Value $ErrorCorrection | Register-PSFConfig -Scope SystemDefault
    Set-PSFConfig @commonParam -Name "instance.$Name.checkInterval" -Value $CheckInterval | Register-PSFConfig -Scope SystemDefault
    Set-PSFConfig @commonParam -Name "instance.$Name.correctionRetryCount" -Value $CorrectionRetryCount | Register-PSFConfig -Scope SystemDefault
    Set-PSFConfig @commonParam -Name "instance.$Name.checkRetryCount" -Value $CheckRetryCount | Register-PSFConfig -Scope SystemDefault
}