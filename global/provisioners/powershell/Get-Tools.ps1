<#
    Get all the expected tools from private Azure storage and install them if needed. 
    This removes our dependancy on the WinRM file provisioner to inject stuff into the 
    Images.
#>


$destinationpath= 'c:\saas-utils\'

$baseShareAccess = 'https://downloadcdn.blob.core.windows.net/hosting/Provisioning/Tools/'
$tokenSharedAccess = '?sv=2018-03-28&si=AutomationAccess&sr=c&sig=temVySQ2N59lnVkQdQROQdDTmHI2bbjUA0ry5EWnHbQ%3D'

#https://downloadcdn.blob.core.windows.net/hosting/Provisioning/Tools/npp.7.6.3.Installer.x64.exe?sv=2018-03-28&si=AutomationAccess&sr=b&sig=rtpsVDsUeZA7QEokX6VyYLee093tKnvu%2FfE%2FX2DPff0%3D

$utils = @(
    @{"uri" = $baseShareAccess + 'cmtrace.exe' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\cmtrace.exe"},
    @{"uri" = $baseShareAccess + 'JoinDomain.ps1' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\JoinDomain.ps1"},
    @{"uri" = $baseShareAccess +  'procexp64.exe' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\procexp64.exe"},
    @{"uri" = $baseShareAccess + 'Set-LocalAdminPassword.ps1' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\Set-LocalAdminPassword.ps1"},
    @{"uri" = $baseShareAccess + 'windirstat.chm' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\windirstat.chm"},
    @{"uri" = $baseShareAccess + 'windirstat.exe' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\tools\windirstat.exe"}
)

$installers = @(
    @{"uri" = $baseShareAccess +  'npp.7.6.3.Installer.x64.exe' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\installers\npp.7.6.3.Installer.x64.exe"},
    @{"uri" = $baseShareAccess + '7z1806-x64.exe' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\installers\7z1806-x64.exe"}
    @{"uri" = $baseShareAccess + 'WindowsOS_x64.msi' + $tokenSharedAccess; "destinationpath" = $destinationpath + "\installers\WindowsOS_x64.msi"}
)


$ProgressPreference = 'SilentlyContinue'

# download the files 

$utils + $installers | ForEach-Object {
    Try {
        #Write-host $_.url $_.destinationpath
        Invoke-WebRequest -UseBasicParsing -Uri $_.uri -OutFile $_.destinationpath -verbose
    } 
    Catch {
        Throw $_
    }
}

# Install some of the utils 

Write-Host "Installing 7Zip"

Start-Process -FilePath "C:\saas-utils\installers\7z1806-x64.exe" -ArgumentList '/S' -Verb runas -Wait

Write-Host "Installing Notepad++"

Start-Process -FilePath "C:\saas-utils\installers\npp.7.6.3.Installer.x64.exe" -ArgumentList '/S' -Verb runas -Wait





