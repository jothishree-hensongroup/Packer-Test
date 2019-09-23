
$LogsDir = "C:\Logs"

Start-Transcript -Path ${LogsDir}\Powershell-Install-All.log -Append

$InstallDir = "C:\Tools"
If (! (Test-Path -Path ${InstallDir})) {
    New-Item -ItemType Directory -Path ${InstallDir} -Force
}
Set-Location "${InstallDir}"

Write-Host "Adding SqlServer Module"
Install-Module -Name SqlServer -AllowClobber -Force

# Get vc installed.
Write-Host "Installing vcredist..."
Start-Process -FilePath "${installDir}\vcredist_x64_2013.exe" -ArgumentList @('/passive', '/norestart') -Wait
Remove-Item "${installDir}\vcredist_x64_2013.exe" -Force
Write-Host "Installing 7zip..."
Start-Process -FilePath "${installDir}\7z1604-x64.exe" -ArgumentList @('/S') -Wait
Remove-Item "${installDir}\7z1604-x64.exe" -Force

Write-Host "Grabbing logs..."
Copy-Item -Path 'c:\Users\Administrator\AppData\Local\Temp\*.log' -Destination ${LogsDir} -Force

Pop-Location

# write a file so we can have trigger a watcher outside of the container this stuff is done.
Write-Host "Write a file to indicate the install is complete..."
$fileName = "$(hostname)_CSM-Install-Complete.txt"
"Empty on purpose" | Set-Content "c:\Logs\${fileName}";

Write-Host "Base Image Install Script Complete"
