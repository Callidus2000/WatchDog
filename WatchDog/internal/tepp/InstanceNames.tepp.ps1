Register-PSFTeppScriptblock -Name "WatchDog.instances" -ScriptBlock {
    try{
        (Get-PSFConfig -Module WatchDog | Where-Object Name -match "instance" | Select-Object -ExpandProperty name) -replace '\w+.([^.]+).*', '$1' | Select-Object -Unique
    }catch{}
}