# Skip SSL Cert Check for 'Invoke-WebRequest'
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12

Start-Transcript -Path C:\Logs\Powershell-Install-All.log -Append

$installDir = "c:\Tools"
Set-Location "${installDir}"

$csmName = "CherwellDiskImage-English.7z"

Write-Host "Extracting ${csmName}..."
Set-Alias zip "${env:ProgramFiles}\7-Zip\7z.exe"
zip x "${installDir}\${csmName}" -o"${installDir}\" -y
Remove-Item "${installDir}\${csmName}" -Force

Push-Location
Set-Location "${installDir}\CherwellDiskImage-English\Media"

#HACK create a bogus auto deploy key to keep installer from prompting.
Write-Host "Adding registry value ConnectionName to key HKLM\Software\Trebuchet\AutoDeploy to keep installer from prompting..."
Push-Location
Set-Location HKLM:
New-Item -Path .\Software -Name Trebuchet
New-Item -Path .\Software\Trebuchet -Name AutoDeploy
New-ItemProperty -Path .\Software\Trebuchet\AutoDeploy -Name ConnectionName -PropertyType String -Value '[Common]Cherwell Browser'
Pop-Location

#Details can be found here:  https://cherwellsupport.com/WebHelp/en/8.2/content/shared/installing_csm_from_the_command_line_-advanced_users_only-1.html
$serverVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("${installDir}\CherwellDiskImage-English\Media\Cherwell Server.exe").FileVersion
Write-Host "Running Server Install version ${serverVersion}..."
Start-Process "${installDir}\CherwellDiskImage-English\Media\Cherwell Server.exe" -ArgumentList "/s /v/qn /vDATABASETYPE=4 /vUSE_SP_ACCOUNT=1 /vCWSPECAILACCOUNT=NetworkService /vCWAPPSERVERIIS=1 /vSERVERSERVICE=1 /vBUSINESSPROCSERVICE=1 /vSCHEDULINGSERVICE=1 /vEMAILSERVICE=1 /vCONFIGSCHEDULE=1 /vCFGSRVS=0 /v`"/lvoicewrmup! c:\Logs\ServerSetup.log`"" -Wait

$serverVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("${installDir}\CherwellDiskImage-English\Media\Cherwell Browser Apps.exe").FileVersion
Write-Host "Running Browser Apps Install version ${serverVersion}..."
Start-Process "${installDir}\CherwellDiskImage-English\Media\Cherwell Browser Apps.exe" -ArgumentList "/s /v/qn /vCWPORTAL=1 /vCWBROWSERCLIENT=1 /vCWWEBSERVICES=1 /vCWCFGMGR=0 /vCWAUTODEPLOY=0 /v`"/lvoicewrmup! c:\Logs\BrowserSetup.log`"" -Wait

Write-Host "Grabbing logs..."
Copy-Item -Path 'c:\Users\ContainerAdministrator\AppData\Local\Temp\*.log' -Destination 'c:\logs' -Force

Pop-Location

Remove-Item -Path "${installDir}\CherwellDiskImage-English" -Recurse -Force

New-Item -ItemType Directory -Path "C:\Program Files (x86)\Cherwell Browser Applications\BrowserClient\App_Data" | Out-Null
New-Item -ItemType Directory -Path "C:\Program Files (x86)\Cherwell Browser Applications\Portal\App_Data" | Out-Null

# Setup permissions
Write-Host "Setting Browser Application permissions..."
icacls "C:\Program Files (x86)\Cherwell Browser Applications\BrowserClient\App_Data" /grant `"Authenticated Users`":`(OI`)`(CI`)M
icacls "C:\Program Files (x86)\Cherwell Browser Applications\Portal\App_Data" /grant `"Authenticated Users`":`(OI`)`(CI`)M
icacls "C:\Program Files (x86)\Cherwell Browser Applications\Portal\Bundles\Portal\css" /grant `"Authenticated Users`":`(OI`)`(CI`)M
icacls "C:\Program Files (x86)\Cherwell Browser Applications\BrowserClient\dist\Bundles\Portal\css" /grant `"Authenticated Users`":`(OI`)`(CI`)M
icacls "C:\Program Files (x86)\Cherwell Browser Applications\Portal\dist\Bundles\Portal\css" /grant `"Authenticated Users`":`(OI`)`(CI`)M

# Move app offline so that we can better ensure iis will respond.
Write-Host "Remove App_Offline.htm..."
Remove-Item c:\inetpub\wwwroot\App_Offline.htm -Force -ErrorAction SilentlyContinue;

Write-Host "CSM Install Script Complete"
