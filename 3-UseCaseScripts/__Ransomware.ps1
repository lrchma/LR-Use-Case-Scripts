<#
.SYNOPSIS
Use Case demonstrating a Ransomware attack and how LogRhythm detects and responds to it.

.DESCRIPTION
This script doesn't take any arguments, rather the original source PowerShell files themselves do

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file _Ransomware.ps1

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Initial Compromise
write-host "Initial Compromise from C2"
& "$root\Ransomware\PaloAltoNetworks-TIS.ps1"

Start-Sleep -s 20

#Remove System Backups
write-host "Remove System Backups"
& "$root\Ransomware\Ransomware-SuspiciousProcessActivity.ps1"

Start-Sleep -s 20

#Add Persistence
write-host "Add Persistence"
& "$root\Ransomware\Ransomware-LogRhythmRIM.ps1"

Start-Sleep -s 20

#New Temporary Process
write-host "New Temp Process"
& "$root\Ransomware\Ransomware-NewTempProcess.ps1"

Start-Sleep -s 20

#New Temporary Process Accessing Large Amount of files in short space of time
write-host "Encrypt Files"
& "$root\Ransomware\Ransomware-ExcessiveFileAccess.ps1"

write-host "Complete."