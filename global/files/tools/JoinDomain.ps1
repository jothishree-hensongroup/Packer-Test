<#
GCWCID http://beta.awsdocs.com/administration/windows/ad/windows_2012_sysprep/
#>


$mystring = "From packer => aws => sysprep post!"

$mystring | Out-File -FilePath c:\saas-utils\tools\automation-out.log 

Add-Content -Path c:\saas-utils\tools\automation-out.log -Value (get-date)


$domain_name = "cod".ToUpper()
$domain_tld = "local"
$secrets_manager_secret_id = "cod/windows/service/domainjoin"

# Make a request to the secret manager
$secret_manager = Get-SECSecretValue -SecretId $secrets_manager_secret_id

# Parse the response and convert the Secret String JSON into an object
$secret = $secret_manager.SecretString | ConvertFrom-Json

# Construct the domain credentials
$username = $domain_name.ToUpper() + "\" + $secret.ServiceAccount
$password = $secret.Password | ConvertTo-SecureString -AsPlainText -Force

# Set PS credentials
$credential = New-Object System.Management.Automation.PSCredential($username,$password)


# Get the Instance ID from the metadata store, we will use this as our computer name during domain registration.
$instanceID = invoke-restmethod -uri http://169.254.169.254/latest/meta-data/instance-id

# Perform the domain join
Add-Computer -DomainName "$domain_name.$domain_tld" -NewName "$instanceID" -Credential $credential -Passthru -Verbose -Force -Restart