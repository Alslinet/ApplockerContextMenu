 param (
    [string]$path = ""
)
$ScriptToElevate = "$env:programfiles\Alslinet\ApplockerContextMenu\ApplockerContextMenuScript.ps1"
$argumentlist = "-noprofile -ExecutionPolicy Bypass -noexit -file " + """" + $ScriptToElevate + """" + " " + """" + $path + """"
$argumentlist

Try {
    start-process powershell -ArgumentList $argumentlist -verb RunAs
} Catch [System.InvalidOperationException]{
    "You do not have the necessary permissions to approve software"
} 
