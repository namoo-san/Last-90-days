# Remove "Computer Account" from Active Directory, that has not been logged in for the past 90 days.
# Author : namoo-san
# Reference : https://docs.microsoft.com/en-us/powershell/module/addsadministration/remove-adcomputer?view=win10-ps
# Reference : https://social.technet.microsoft.com/Forums/ja-JP/bad65781-994d-48b5-bd88-2bfe80106aa5/removeadcomputer?forum=powershellja

# Set variables
$LogDirectory = "C:\"
$ExpireDate = (Get-Date).AddDays(-90)
$AuditDate = Get-Date -Format "yyyyMMdd-hhmmss"
$ExportFile = $AuditDate + "-RemoveComputersList.txt"
$AuditExport = $AuditDate + "-Audit-RemovedComputersList.txt"
$ExportFilePath = $LogDirectory + $ExportFile
$AuditFilePath = $LogDirectory + $AuditExport

# Export "Computer Account Name" & "Last logon date"
Search-ADAccount -AccountInactive -DateTime $ExpireDate -ComputersOnly | Format-Table Name,LastLogonDate | Out-File -FilePath $ExportFilePath

# Export "Computer Account" lists for remove
Search-ADAccount -AccountInactive -DateTime $ExpireDate -ComputersOnly | Format-Table Name | Out-File -FilePath $AuditFilePath

# Remove from Active Directory
Import-Module ActiveDirectory
$f = (Get-Content $ExportFilePath) -as [string[]]
$i=1
foreach ($Objects in $f) {
    $HostName = $objects.TrimEnd()

    # Remove messages
    Write-Output "$HostName remove from Active Directory."
    try {
        # Remove-ADComputer -Identity $l.TrimEnd() -Confirm:$False | Out-File $ResultExport -Encoding UTF8 -Append
        Get-ADComputer $HostName.TrimEnd() | Remove-ADObject -Recursive -Confirm:$False
        Write-Output "$HostName removed."
    }
    catch {
        Write-Output "$HostName remove failed..."
    }
    $i++
}
