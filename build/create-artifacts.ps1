﻿param (
	[Parameter(Mandatory=$true)]
	[string]
	$Root,
	
	[Parameter(Mandatory=$true)]
	[string]
	$Version,
	
	[Parameter()]
	[string]
	$Password
)

Add-Type -Assembly "system.io.compression.filesystem"
$Temp = "$Root\build\temp\"
$Out = "$Root\build\artifacts\"
if (Test-Path $Temp) 
{
    Remove-Item $Temp -Recurse
}
New-Item $Temp -Type Directory

if (Test-Path $Out) 
{
    Remove-Item $Out -Recurse
}
New-Item $Out -Type Directory

# 64bit release
$MainZip = "win-acme.v$Version.64bit.zip"
$MainZipPath = "$Out\$MainZip"
$MainBin = "$Root\src\main\bin\Release\netcoreapp3.0\win-x64"
./sign-exe.ps1 "$MainBin\wacs.exe" "$Root\build\codesigning.pfx" $Password
Copy-Item "$MainBin\publish\wacs.exe" $Temp
Copy-Item "$MainBin\settings.config" "$Temp\settings_default.config"
Copy-Item "$Root\dist\*" $Temp -Recurse
Set-Content -Path "$Temp\version.txt" -Value "v$Version (64 bit)"
[io.compression.zipfile]::CreateFromDirectory($Temp, $MainZipPath)

# 32bit release
Remove-Item $Temp\* -recurse
$MainZip = "win-acme.v$Version.32bit.zip"
$MainZipPath = "$Out\$MainZip"
$MainBin = "$Root\src\main\bin\Release\netcoreapp3.0\win-x86"
./sign-exe.ps1 "$MainBin\wacs.exe" "$Root\build\codesigning.pfx" $Password
Copy-Item "$MainBin\publish\wacs.exe" $Temp
Copy-Item "$MainBin\settings.config" "$Temp\settings_default.config"
Copy-Item "$Root\dist\*" $Temp -Recurse
Set-Content -Path "$Temp\version.txt" -Value "v$Version (32 bit)"
[io.compression.zipfile]::CreateFromDirectory($Temp, $MainZipPath)

#Remove-Item $Temp\* -recurse
#$PlugZip = "win-acme.dreamhost.v$Version.zip"
#$PlugZipPath = "$Out\$PlugZip"
#$PlugBin = "$Root\src\plugin.validation.dns.dreamhost\bin\Release\net472"
#Copy-Item "$PlugBin\PKISharp.WACS.Plugins.ValidationPlugins.Dreamhost.dll" $Temp
#[io.compression.zipfile]::CreateFromDirectory($Temp, $PlugZipPath)

#Remove-Item $Temp\* -recurse
#$PlugZip = "win-acme.azure.v$Version.zip"
#$PlugZipPath = "$Out\$PlugZip"
#$PlugBin = "$Root\src\plugin.validation.dns.azure\bin\Release\net472"
#Copy-Item "$PlugBin\Microsoft.Azure.Management.Dns.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.IdentityModel.Clients.ActiveDirectory.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.IdentityModel.Logging.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.IdentityModel.Tokens.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.Rest.ClientRuntime.Azure.Authentication.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.Rest.ClientRuntime.Azure.dll" $Temp
#Copy-Item "$PlugBin\Microsoft.Rest.ClientRuntime.dll" $Temp
#Copy-Item "$PlugBin\PKISharp.WACS.Plugins.ValidationPlugins.Azure.dll" $Temp
#[io.compression.zipfile]::CreateFromDirectory($Temp, $PlugZipPath)

#Remove-Item $Temp\* -recurse
#$PlugZip = "win-acme.route53.v$Version.zip"
#$PlugZipPath = "$Out\$PlugZip"
#$PlugBin = "$Root\src\plugin.validation.dns.route53\bin\Release\net472"
#Copy-Item "$PlugBin\AWSSDK.Core.dll" $Temp
#Copy-Item "$PlugBin\AWSSDK.Route53.dll" $Temp
#Copy-Item "$PlugBin\PKISharp.WACS.Plugins.ValidationPlugins.Route53.dll" $Temp
#[io.compression.zipfile]::CreateFromDirectory($Temp, $PlugZipPath)