if (Get-Module -ListAvailable -Name SqlServer) {
    Write-Host "Module exists"
} else {
    Write-Host "Module Does Not exist! Exiting.."
    exit
}
$QueryResult = Invoke-Sqlcmd -ServerInstance 'localhost' -Database 'master' -Query "select name from sys.symmetric_keys"
if($QueryResult.name -eq '##MS_ServiceMasterKey##'){
$password='****'
$location=Get-ChildItem -Path "SQLSERVER:\SQL\$env:COMPUTERNAME" | select-object -ExpandProperty  BackupDirectory
$Query="BACKUP SERVICE MASTER KEY TO FILE = '$location\CertifiCate$(get-date -Format yyyyddMM_hhmmtt).key' ENCRYPTION BY PASSWORD = '$password'"
Invoke-Sqlcmd -ServerInstance 'localhost' -Database 'master' -Query $Query
}else {
write-host("No SYMMETRIC KEY Exist")
}
Get-ChildItem –Path "$location" -Recurse | Where-Object {($_.CreationTime -lt (Get-Date).AddDays(-7))} | Remove-Item
