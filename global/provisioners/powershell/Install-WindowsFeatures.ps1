Write-Host "Installing Required Windows Features..."
Import-Module ServerManager
$FeatureList = @(
   "Telnet-Client",
   "SNMP-Service"
)

$Features = Get-WindowsFeature $FeatureList

ForEach ($Feature in $Features) {
   If ($Feature.Installed -eq $false) {
      Try {
         Write-Host $Feature.DisplayName "is not installed. It will be installed now."
         Install-WindowsFeature -Name $Feature.name
      }
      Catch {
         Write-Host "Failed to install" $Feature.name
      }
   }
   Else {
      Write-Host $Feature.DisplayName "is already installed."      
   }
}

<# why??
Write-Host "Opening port 80..."
netsh advfirewall firewall add rule name="open_80_api" dir=in localport=80 protocol=TCP action=allow
#>