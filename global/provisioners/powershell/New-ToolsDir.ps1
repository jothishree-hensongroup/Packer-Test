# Create the Tools directory in the AMI

$Dirs = ("C:\saas-utils\tools", "c:\saas-utils\installers")

Foreach ($Dir in $Dirs) {
    If (! (Test-Path -Path ${Dir})) {
        New-Item -ItemType Directory -Path ${Dir} -Force 
    }
}