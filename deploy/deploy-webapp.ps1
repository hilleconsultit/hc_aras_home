param (
    [Parameter(Mandatory=$true)][string]$env
 )

 $DefaultArasWebAppPath="C:\Program Files (x86)\Aras\Innovator\Innovator\"
 
 $propPath = "properties\env\" + $env
 #$propPath
 $envExists = Test-Path $propPath
 if (-Not $envExists) {
	$propPath + " does not exist"
	return 1
 }
 
#Read properties
$AppProps = convertfrom-stringdata (Get-Content $propPath\import.properties	 | Out-String)

$configureWebAppPath = $AppProps.'WEBAPP_PATH'
if ([string]::IsNullOrEmpty($configureWebAppPath)) {
	"No configured WEBAPP_PATH using default"
	$ArasWebAppPath = $DefaultArasWebAppPath
}
else {
	"Using configured WEBAPP_PATH"
	$ArasWebAppPath = $configureWebAppPath
}


#$ArasWebAppPath="C:\Program Files (x86)\Aras\Innovator\Innovator\"
$ArasWebAppPath
Copy-Item -Path .\webapp\Client -Destination $ArasWebAppPath -Recurse -Force
Copy-Item -Path .\webapp\Server -Destination $ArasWebAppPath -Recurse -Force
