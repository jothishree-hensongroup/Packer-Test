$EC2SettingsFile="C:\\Program Files\\Amazon\\Ec2ConfigService\\Settings\\Config.xml"
$xml = [xml](Get-Content $EC2SettingsFile)
$xmlElement = $xml.get_DocumentElement()
$xmlElementToModify = $xmlElement.Plugins

foreach ($element in $xmlElementToModify.Plugin)
{
    if ($element.name -eq "Ec2SetPassword")
    {
        $element.State="Disabled"
    }
    elseif ($element.name -eq "Ec2SetComputerName")
    {
        $element.State="Disabled"
    }
    elseif ($element.name -eq "Ec2HandleUserData")
    {
        $element.State="Enabled"
    }
    elseif ($element.name -eq "Ec2DynamicBootVolumeSize") 
    {
        $element.State="Enabled"
    }
}
$xml.Save($EC2SettingsFile)