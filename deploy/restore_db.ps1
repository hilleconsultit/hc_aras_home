
param (
    [Parameter(Mandatory=$true)][string]$env
 )

 "Restoring environment: " + $env
 
 $propPath = "properties\env\" + $env
 #$propPath
 $envExists = Test-Path $propPath
 if (-Not $envExists) {
	$propPath + " does not exist"
	return 1
 }


#Read Database backup properties
$DatabaseProps = convertfrom-stringdata (Get-Content $propPath\database.properties	 | Out-String)
$database_name = $DatabaseProps.'DATABASE_NAME'
$sql_cmd_path = $DatabaseProps.'SQL_CMD_PATH'
$base_line_backup_file_path = $DatabaseProps.'BASE_LINE_BACKUP_FILE_PATH'
#$sql_cmd_path

"Kill processes"
$query = "USE master;
GO
ALTER DATABASE " + $database_name + " 
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
ALTER DATABASE " + $database_name + "
SET MULTI_USER;
GO"

$params = " -S .\SQLEXPRESS -E -Q " + " ""  " + $query + " "" "
$ret = Start-Process -FilePath $sql_cmd_path $params -Wait -NoNewWindow -PassThru
$ret.ExitCode

$query = "RESTORE DATABASE " + $database_name + " FROM DISK='" + $base_line_backup_file_path + "'  WITH REPLACE"
$query
$params = " -S .\SQLEXPRESS -E -Q " + " ""  " + $query + " "" "

$ret = Start-Process -FilePath $sql_cmd_path $params -Wait -NoNewWindow -PassThru
$ret.ExitCode
return $ret.ExitCode
