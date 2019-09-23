# Grabs cherwell installers from CDN 
$ProgressPreference = 'SilentlyContinue'


$destinationpath= 'c:\saas-utils\'

$baseShareAccess = 'https://downloadcdn.blob.core.windows.net/hosting/'
$tokenSharedAccess = '?sv=2018-03-28&si=AutomationAccess&sr=c&sig=temVySQ2N59lnVkQdQROQdDTmHI2bbjUA0ry5EWnHbQ%3D'

$Installers = @(
    @{"url" = $baseShareAccess + "CSM/CherwellDiskImage-" + $env:CSMLANG + ".zip" + $tokenSharedAccess; "destinationpath" = $destinationpath + "installers\CherwellDiskImage-" + $env:CSMLANG + ".zip"}
    @{"url" = $baseShareAccess + "CAM/cam.zip" + $tokenSharedAccess; "destinationpath" = $destinationpath + "installers\cam.zip"}
)

$Installers | ForEach-Object {
    Try {
        #Write-host $_.url $_.destinationpath
        Invoke-WebRequest -UseBasicParsing -Uri $_.url -OutFile $_.destinationpath -verbose
    } 
    Catch {
        Throw $_
    }
}