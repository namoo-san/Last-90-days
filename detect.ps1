# Detect "Computer Account" from Active Directory, that has not been logged in for the past 90 days.
# Author : namoo-san
# Reference : https://docs.microsoft.com/en-us/powershell/module/addsadministration/remove-adcomputer?view=win10-ps

# Set variables
$ExpireDate = (Get-Date).AddDays(-90)

# Result "Computer Account Name" & "Last logon date"
Search-ADAccount -AccountInactive -DateTime $ExpireDate -ComputersOnly | Format-Table Name,LastLogonDate