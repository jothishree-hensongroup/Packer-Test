Write-Host "Installing Required Windows Features..."
Import-Module ServerManager
$FeatureList = @(
   "Web-WebServer",
   "Web-Static-Content",
   "Web-Http-Errors",
   "Web-Http-Redirect",
   "Web-Stat-Compression",
   "Web-Filtering",
   "Web-Asp-Net",
   "Web-Asp-Net45",
   "Web-Net-Ext",
   "Web-Net-Ext45",
   "Web-ISAPI-Ext",
   "Web-ISAPI-Filter",
   "Web-Mgmt-Console",
   "Web-Mgmt-Tools",
   "NET-Framework-Features",
   "NET-Framework-45-Features",
   "NET-Framework-Core",
   "NET-Framework-45-Core",
   "NET-Framework-45-ASPNET",
   "NET-HTTP-Activation",
	"NET-Non-HTTP-Activ",
   "NET-WCF-Services45",
   "NET-WCF-HTTP-Activation45",
   "NET-WCF-TCP-Activation45",
   "NET-WCF-TCP-PortSharing45"
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

<# 
   Get url rewrite , this is ugly
   URL rewrite is not a standard windows feature so we grab it direct and install it. 
#>
Write-Host "Installing IIS URL Rewrite 2.1" -Verbose 
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi" -outfile "c:\saas-utils\installers\rewrite_amd64_en-US.msi" -Verbose
Start-Process 'c:\saas-utils\installers\rewrite_amd64_en-US.msi' '/qn' -PassThru -Verbose -Wait

