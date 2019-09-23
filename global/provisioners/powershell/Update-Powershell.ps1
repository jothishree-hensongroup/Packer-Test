# Update Powershell 

$PackageName = "Win8.1AndW2K12R2-KB3191564-x64.msu"
$OutDir = "C:\Temp"

if (! (Test-Path -Path ${OutDir})) {
    New-Item -ItemType Directory -Path ${OutDir} -Force
}

$Url= "https://go.microsoft.com/fwlink/?linkid=839516"
$OutFile = "${OutDir}\${PackageName}"

try {
    Write-Host "Downloading WMF 5.1 to ${OutFile}"
    Invoke-WebRequest -Uri ${Url} -OutFile ${OutFile}
    
    if ( Test-Path -Path ${OutFile} ) {
        # Running wusa.exe via WinRM is a pain.
        # We have to extract the MSU file using wusa.exe,
        # and then use dism.exe to actually run the install
        # on the CAB files.

        Write-Host "Installing WMF 5.1 (4)"
        Start-Process -FilePath 'wusa.exe' -ArgumentList "${OutFile} /extract:${OutDir}" -Verb RunAs -Wait -Passthru
        Start-Sleep -Seconds 5
        Start-Process -FilePath 'dism.exe' -ArgumentList "/online /add-package /PackagePath:${OutDir}\WSUSSCAN.cab /PackagePath:${OutDir}\WindowsBlue-KB3191564-x64.cab /IgnoreCheck /quiet /norestart" -Verb RunAs -Wait -PassThru

        # Recursively remove the ${OutDir} for cleanup
        Remove-Item -Path ${OutDir} -Force -Recurse

    }
    else {
        Write-Host "WMF 5.1 Not Installed"
    }
}
catch {
    $_
}
