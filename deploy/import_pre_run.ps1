param (
    [Parameter(Mandatory=$true)][string]$env
 )

 "Pre run import to environement: " + $env
 
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
$propPathImport = $propPath + "\import.properties"
$importManifestPath = "pre_run_import\pre_run_1.mf"
$importManifestPath = Get-Item $importManifestPath | Resolve-Path
$importManifestPath = Convert-Path $importManifestPath

# Execute SQL commands first
$DatabaseProps = convertfrom-stringdata (Get-Content $propPath\database.properties	 | Out-String)
$database_name = $DatabaseProps.'DATABASE_NAME'
$sql_cmd_path = $DatabaseProps.'SQL_CMD_PATH'
$queryPath = "pre_run_import\pre_run_sql\pre_run_sql.sql"
$params = " -S .\SQLEXPRESS -E -d " + $database_name + " -i " + $queryPath

$sql = Start-Process -FilePath $sql_cmd_path $params -Wait -NoNewWindow -PassThru
#$sql

""
if ($sql.ExitCode -gt 0) {
    $message = "SQL commands failed "
	Write-Warning $message
	$params

	return
}
else {
	Write-Host -ForegroundColor Green "SQL commands completed successful: "  $params
}

# Run import
$prog = ".\tools\ArasDeveloperTool.exe"
$params = "RunAML propertyFile=""$propPathImport"" importManifest=""$importManifestPath"" "
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