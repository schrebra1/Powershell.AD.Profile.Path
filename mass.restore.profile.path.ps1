$usernames = get-content C:\temp\some.users.txt

function MassRestore {
foreach($username in $usernames){ 
$AD = Get-ADDomainController

$profilePath = get-content \\example.share\$username.txt

Set-ADUser -Identity $username -ProfilePath $profilePath
Write-host ""
Write-host $username "Profile Has been Restored" -ForegroundColor green
pause

}
}