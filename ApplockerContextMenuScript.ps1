 param (
    [string]$path = ""
)

#CONFIGURAION
$GroupPolicyUniqueName = "{D83DD442-B0E4-40C9-AF12-A4E2EF512A01}" #EXAMPLE GUID {D83DD442-B0E4-40C9-AF12-A4E2EF512A01}, Use "" for local policy.
$RulePrefix = "ContextMenuRule" #Adds a prefix in front of rules generated using this script
$ADSIDomain = "DC=yourdomain,DC=com" #EXAMPLE "DC=yourdomain,DC=com" if your domain is yourdomain.com

#DONT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING

#Set and reset variables
$ApplockerFileInformation = $Null
$PublisherRule = $Null
$HashRule = $Null
$Rule = $Null
$CurrentDomainController = ([ADSI]”LDAP://RootDSE”).dnshostname

#Get Applocker information for the specified file
$ApplockerFileInformation = Get-AppLockerFileInformation $path

#Try to get publisher information if it fails try to get information to create a hash rule
Try {
    $PublisherRule = New-AppLockerPolicy $ApplockerFileInformation -RuleNamePrefix $RulePrefix -RuleType Publisher -Optimize
    $Rule = $PublisherRule 
} Catch {
    $HashRule = New-AppLockerPolicy $ApplockerFileInformation -RuleNamePrefix $RulePrefix -RuleType Hash -Optimize
    $Rule = $HashRule
}

if ($GroupPolicyUniqueName){
 # Add (Merge) new rule to group policy
 $Rule | Set-AppLockerPolicy -LDAP "LDAP://$CurrentDomainController/CN=$GroupPolicyUniqueName,CN=Policies,CN=System,$ADSIDomain" -Merge
} else {
 # Add (Merge) new rule to local policy
 $Rule | Set-AppLockerPolicy -Merge
} 
