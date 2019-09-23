function Reset-LocalAdminPassword{
	
	[cmdletbinding()]
	Param (
		[Parameter(Mandatory = $true)][String]$servername,
		[Parameter(Mandatory = $true)][String]$password
	)
	
	$user = [adsi]"WinNT://$servername/Administrator"
	$user.SetPassword($Password)
}


$secrets_manager_secret_id = "cod/windows/service/localadmin"

# Make a request to the secret manager
$secret_manager = Get-SECSecretValue -SecretId $secrets_manager_secret_id

# Parse the response and convert the Secret String JSON into an object
$secret = $secret_manager.SecretString | ConvertFrom-Json

Reset-LocalAdminPassword -ServerName localhost -Password $secret.Password