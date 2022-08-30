

$usernames = get-content \\example.share\all.users.txt


function TestUserBackupPath {

$AD = Get-ADDomainController

foreach($username in $usernames){ 

$varuser = "\\example.share\Profile.Paths.Backup\Profile.Paths.Backup\$username.txt"
$testBackup = test-path $varuser

if ($testbackup -eq $false){

get-aduser -server $ad.hostname -Identity $username -property * | select ProfilePath | Out-File -Append \\example.share\Profile.Paths.Backup\$username.txt -verbose
get-content \\example.share\Profile.Paths.Backup\$username.txt | Where-Object {$_ -notmatch 'ProfilePath'} | Where-Object {$_ -notmatch '-----------'} |Where-Object {$_ -notmatch ' '} | ? {$_.trim() -ne "" }| Set-Content \\example.share\Profile.Paths.Backup\$username.1.txt -verbose
del \\example.share\Profile.Paths.Backup\$username.txt -verbose
cp \\example.share\Profile.Paths.Backup\$username.1.txt \\example.share\Profile.Paths.Backup\$username.txt -ErrorAction Ignore -verbose
del \\example.share\Profile.Paths.Backup\$username.1.txt -ErrorAction Ignore -Verbose

}else{

Write-host $username "Backup Text already exists" -ForegroundColor Green
write-host ""
}

set-aduser -Identity $username -clear ProfilePath

Write-host ""
write-host $username "Removed Profile Path Sucessfully" -ForegroundColor green


}
}

TestUserBackupPath
