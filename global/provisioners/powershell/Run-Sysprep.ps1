# Call Ec2Config and actually setup sysprep

start-service Ec2Config

#Removes old EC2Config Log
remove-item -Path "C:\Program Files\Amazon\Ec2ConfigService\Logs\Ec2ConfigLog.txt" -Force -Confirm:$false -ErrorAction SilentlyContinue


#Pre-Compiles Queued .net Assemblies prior to Sysprep - improves boot times
Write-Host "Starting ngen.exe"
start-process "C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen.exe" -ArgumentList 'executequeueditems' -Wait


write-host "Clearing Event Logs"
Clear-EventLog Application
Clear-EventLog System
Clear-EventLog Security
    
Write-Host "starting sysprep"
Start-Process  "c:\Program Files\Amazon\Ec2ConfigService\Ec2Config.exe" -ArgumentList "-sysprep" -Wait
