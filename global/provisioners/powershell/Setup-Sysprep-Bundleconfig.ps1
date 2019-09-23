$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\BundleConfig.xml"
$xml = [xml](Get-Content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()

foreach ($element in $xmlElement.Property)
{
    if ($element.Name -eq "AutoSysprep")
    {
        $element.Value="No"
    }
    elseif ($element.Name -eq "SetPasswordAfterSysprep") {
        $element.Value="No"
        
    }
}
$xml.Save($EC2SettingsFile)