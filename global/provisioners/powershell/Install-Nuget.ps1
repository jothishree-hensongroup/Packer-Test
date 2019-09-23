
Write-Host "PowerShell Version:" $PSVersionTable.PSVersion
Write-Host "Host Version" $Host.Version

Install-PackageProvider -Name Nuget -RequiredVersion 2.8.5.201 -Force
Install-Module -Name PowerShellGet -Force

Start-Sleep -Seconds 10
