$QueryResult = Invoke-Sqlcmd -ServerInstance 'abc -Database 'master' -Query "select name from sys.symmetric_keys"
if($QueryResult.name -eq '##MS_ServiceMasterKey##'){
write-host("SYMMETRIC KEY EXIST")
}else {
write-host("No SYMMETRIC KEY Exist")
}
$location="MSSQL\MSSQL14.MSSQLSERVER\Cert"
echo $location
$command=New-Item -Path $location -Name CertifiCate$(get-date -Format yyyyddmm_hhmmtt) -ItemType File
$query= Invoke-Sqlcmd -ServerInstance 'abc' -Database 'master' -Query "BACKUP SERVICE MASTER KEY TO FILE = '$command.name'ENCRYPTION BY PASSWORD = '***' "
echo "Backup completed"
Get-ChildItem –Path "MSSQL\MSSQL14.MSSQLSERVER\Cert" -Recurse | Where-Object {($_.CreationTime -lt (Get-Date).AddDays(-7))} | Remove-Item
echo "Files Deleted"
