$content = @"
echo "Hello from SetupComplete.cmd post OOBE" >> c:\saas-utils\tools\postoobe.txt
date >> c:\saas-utils\tools\postoobe.txt
call "C:\Program Files\Amazon\Ec2ConfigService\Scripts\PostSysprep.cmd"
"@

Set-Content -Path "C:\Windows\Setup\Scripts" -Value $content 
