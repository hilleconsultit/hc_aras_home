
param (
    [Parameter(Mandatory=$true)][string]$env
 )

 "Importing to environement: " + $env
 
 $propPath = "properties\env\" + $env
 #$propPath
 $envExists = Test-Path $propPath
 if (-Not $envExists) {
	$propPath + " does not exist"
	return 1
 }


$currentPath =  (Get-Item -Path ".\" -Verbose).FullName

$propertyFile = $currentPath + "\" + $propPath + "\import.properties"

$prog = ".\tools\ArasDeveloperTool.exe"
$params = "PackageChecker propertyFile=""$propertyFile"" prefix=HC"" "
#$params

$ret = Start-Process -FilePath $prog $params -Wait -NoNewWindow -PassThru
#$ret

""
if ($ret.ExitCode -gt 0) {
    $message = "Task failed "
	Write-Warning $message
	$params

	
	return
}
else {
	Write-Host -ForegroundColor Green "Task successful: "  $params
}