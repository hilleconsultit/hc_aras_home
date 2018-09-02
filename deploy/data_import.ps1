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

 #Convert to full path strings
$propPath = Get-Item $propPath | Resolve-Path
$propPath = Convert-Path $propPath
$propPath = $propPath + "\import.properties"
$importManifestPath = "data_imports\importData.mf"
$importManifestPath = Get-Item $importManifestPath | Resolve-Path
$importManifestPath = Convert-Path $importManifestPath

# Run import
$prog = ".\tools\ArasDeveloperTool.exe"
$params = "RunAML propertyFile=""$propPath"" importManifest=""$importManifestPath"" "
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