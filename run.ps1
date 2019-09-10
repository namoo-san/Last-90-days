# Remove "Computer Account" from Active Directory, that has not been logged in for the past 90 days.
# Author : namoo-san

$ExpireDate = (Get-Date).AddDays(-90)
$ExportFile = "RemoveComputerList.txt"
$AuditExport = "Audit-RemoveComputerList.txt"

# Export "Computer Account Name" & "Last logon date"
Search-ADAccount -AccountInactive -DateTime $ExpireDate -ComputersOnly | Format-Table Name,LastLogonDate | Out-File $AuditExport

# Export "Computer Account" lists for remove
Search-ADAccount -AccountInactive -DateTime $ExpireDate -ComputersOnly | Format-Table Name | Out-File $ExportFile

# Remove from Active Directory
Import-Module ActiveDirectory
$f = (Get-Content $ExportFile) -as [string[]]
$i=1
foreach ($l in $f) {
    Write-Host $l
    Remove-ADComputer -Identity $l.TrimEnd()
    $i++
}
