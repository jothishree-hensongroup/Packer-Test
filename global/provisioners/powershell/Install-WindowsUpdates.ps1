Install-Module -Name PSWindowsUpdate -Force -Verbose

# Gotta actually configure windows update or nothing freaking works... 

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name AUOptions -PropertyType Dword -Value 1 -Verbose

Write-Host "Restarting wuauserv... "
Get-Service wuauserv -verbose
Restart-Service wuauserv -verbose 

<# 
So interestingly enough you cannot do this via PSRemoting by design. I'm leaving this here in case we figure out a way around it.
A potential work around would be a scheduled task that writes a status message to the filesystem and we loop until we find it then reboot... ugh
You'll get this fun error (which for some reason the powershell provisioner does not return stderr even in debug )
Access is denied. (Exception from HRESULT: 0x80070005 (E_ACCESSDENIED))
    + CategoryInfo          : NotSpecified: (:) [Get-WindowsUpdate], UnauthorizedAccessException
    + FullyQualifiedErrorId : System.UnauthorizedAccessException,PSWindowsUpdate.GetWindowsUpdate
TODO:  Make this work 
#>
Get-WUInstall -MicrosoftUpdate -AcceptAll -IgnoreReboot -Install -Verbose

