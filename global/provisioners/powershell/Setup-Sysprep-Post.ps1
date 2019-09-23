
$runString = @"

echo "hello from PostSysprep.cmd" >> c:\saas-utils\tools\postoobe.txt

@REM This setting can affect resource utilization upon start and customers can manually enable for their use case. 
@REM reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 2 /f

@REM Restart the update service to stop any inflight downloads
@REM User "net start" and "stop" b/c they are synchronous
net stop wuauserv
net start wuauserv

@REM Sets local Admin user password to not expire
WMIC USERACCOUNT WHERE "Name='Administrator'" SET PasswordExpires=FALSE


@REM ***************
@REM Sets the MSSQLServer machine name (if installed) so that the name will be in sync
@REM If server is renamed at any point after sysprep, this should be run to keep the MSSQLServer name in sync
@REM For some configurations, this needs to be performed as the last step -- SQL needs to be restarted for the change to take effect
net start MSSQLSERVER
SQLCMD -Q "DECLARE @InternalInstanceName sysname; DECLARE @MachineInstanceName sysname; SELECT @InternalInstanceName = @@SERVERNAME, @MachineInstanceName = CAST(SERVERPROPERTY('MACHINENAME') AS VARCHAR(128))  + COALESCE('\' + CAST(SERVERPROPERTY('INSTANCENAME') AS VARCHAR(128)), '');IF @InternalInstanceName <> @MachineInstanceName BEGIN EXEC sp_dropserver @InternalInstanceName; EXEC sp_addserver @MachineInstanceName, 'LOCAL'; END"
net stop MSSQLSERVER /Y && net start MSSQLSERVER && net start SQLSERVERAGENT
@REM ***************
@REM Runs the Domain Join script to join this box to the Active Directory Domain
powershell.exe -ExecutionPolicy Bypass "& 'C:\saas-utils\tools\Set-LocalAdminPassword.ps1'"
powershell.exe -ExecutionPolicy Bypass "& 'C:\saas-utils\tools\JoinDomain.ps1'"

"@

Set-Content -Path "C:\Program Files\Amazon\Ec2ConfigService\Scripts\PostSysprep.cmd" -Value $runString