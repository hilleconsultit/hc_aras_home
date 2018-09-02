
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

#Pre run 
#$ret1 = .\import_pre_run.ps1 $env
Write-Warning "No pre run import"
 
#Read properties
$AppProps = convertfrom-stringdata (Get-Content $propPath\import.properties	 | Out-String)
$VersionProps = convertfrom-stringdata (Get-Content $propPath\version.properties	 | Out-String)

#$AppProps
#$AppProps.'app.version'
$server = $AppProps.'ARAS_URL' 
$db = $AppProps.'ARAS_DATABASE'
$login = $AppProps.'ARAS_USER'
$password = $AppProps.'ARAS_PASSWORD'


#Print/echo properties
""
"Server: " + $server
"DB: " + $db
"Login: " + $login

$ret = .\backup_db.ps1 $env

""
if ($ret.ExitCode -gt 0) {
	Write-Warning "Backup failed"
	return 1
}
else {
	#"Backup successful: " + $bak_file_path
	
	$importProg = $AppProps.'CONSOLE_UPGRADE_PATH'
	#$exportProg
	$importDir = $AppProps.'IMPORT_DIR'
	$manifestFile = $AppProps.'MANIFEST_FILE'
	$release = $VersionProps.'RELEASE'

	# Set parameters
	$params = "server=" + $server + " database=" + $db + " login=" + $login + " password=" + $password + " dir=" + """$importDir"""  + " mfFile=" + """$manifestFile""" + " release=" + $release + " import merge vlog"
	#$params

	# Execute Import script
	$ret2 = Start-Process -FilePath $importProg $params -Wait -NoNewWindow -PassThru
	$ret2

	""
	if ($ret2.ExitCode -gt 0) {
		Write-Warning "Import failed"
		"Restoring database"
	}
	else {
		Write-Host -ForegroundColor Green "Import successful: " + $importDir
        return 0
	}

	if ($zip_enabled -eq "TRUE") {
		remove-item -path $bak_file_path
	}
}
