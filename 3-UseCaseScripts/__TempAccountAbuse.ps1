<#
.SYNOPSIS
Use Case demonstrating temporary account abuse.  An administrator creating an account, logging on with it, performing malicious activity, before then logging off and deleting the account in question.

.DESCRIPTION
This script doesn't take any arguments, rather the original source PowerShell files themselves do

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file TempAccountAbuse.ps1

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

write-host "User Account Created (Chuck creates Alice)"
#User Account Created (Chuck creates Alice)
& "$root\TempAccountAbuse\WinSec-AccountCreated.ps1"

Start-Sleep -s 70

write-host "Temp Account Logged on with (Alice)"
#Temp Account Logged on with (Alice)
& "$root\TempAccountAbuse\WinSec-UserLogin.ps1"

Start-Sleep -s 70

write-host "Temp Account clears Even Log (Alice)"
#Temp Account clears Even Log (Alice)
& "$root\TempAccountAbuse\WinSec-LogCleared.ps1"

Start-Sleep -s 70

write-host "Temp Account Deleted (Chuck)"
#Temp Account Deleted (Chuck)
& "$root\TempAccountAbuse\WinSec-AccountDeleted.ps1"

write-host "Complete."
