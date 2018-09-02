
param (
    [Parameter(Mandatory=$true)][string]$env
 )

 "Backing up environment: " + $env
 
 $propPath = "properties\env\" + $env
 #$propPath
 $envExists = Test-Path $propPath
 if (-Not $envExists) {
	$propPath + " does not exist"
	return 1
 }
 
#Read properties
$DatabaseProps = convertfrom-stringdata (Get-Content $propPath\database.properties	 | Out-String)

#Read Database backup properties
$db_backup_script = $DatabaseProps.'DB_BACKUP_SCRIPT'
$database_name = $DatabaseProps.'DATABASE_NAME'
$sql_cmd_path = $DatabaseProps.'SQL_CMD_PATH'
$db_backup_dir = $DatabaseProps.'DB_BACKUP_DIR'
$db_base_filename = $DatabaseProps.'DB_BASE_FILENAME'

$zip_enabled = $DatabaseProps.'7ZIP_ENABLED'

#Print/echo properties
""
#"Server: " + $server
#"DB: " + $db
#"Login: " + $login
"Backup script: " + $db_backup_script
"database_name: " + $database_name
"sql_cmd_path: " + $sql_cmd_path
"db_backup_dir: " + $db_backup_dir
"db_base_filename: " + $db_base_filename
"zip_enabled: " + $zip_enabled


#Backup database
""
$sec = Get-Date
$sec = $sec.Second

if ($sec -lt 10) {
	# less then 10, add 0
	$sec = "0" + $sec
}

$time_suffix = Get-Date -format g
$time_suffix = $time_suffix -replace " ","_"
$time_suffix = $time_suffix -replace ":","_"
$time_suffix = $time_suffix + "_" + $sec
$bak_file_name = $db_base_filename + "_" + $time_suffix + ".bak"
$bak_file_path = $db_backup_dir + $bak_file_name
#$bak_file_path

$params = """$sql_cmd_path""" + " " + $database_name + " " + """$bak_file_path"""
#$params

# Execute backup script
$ret = Start-Process -FilePath .\$db_backup_script $params -Wait -NoNewWindow -PassThru
#$ret

""
if ($ret.ExitCode -gt 0) {
	Write-Warning "Backup failed"
	return 1
}
else {
	Write-Host -ForegroundColor Green "File: "  $bak_file_path
	if ($zip_enabled -eq "TRUE") {
		"Zip file"
		$params = " a -tzip " + """$bak_file_path" + ".zip""" + " " + """$bak_file_path"""
		#$params
		$ret = Start-Process  7z.exe $params -Wait -NoNewWindow -PassThru
		#$ret
	}
	
}