<#
.SYNOPSIS
Simulate user account deletion from Active Directory, uses Windows Security XML Event Logs.

.DESCRIPTION
Takes five arguments: -computer, -loginDomain, -loginName, -accountDomain, -accountName

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file WinSec-AccountDeleted.ps1 -computer "lrxm" -loginDomain "lrxm" -loginName "user_creating_account" -accountDomain "lrxm" -accountName "user_created"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$computer = 'LRXM',
  [Parameter(Mandatory=$false)]
  [string]$loginDomain = 'LRXM',
  [Parameter(Mandatory=$false)]
  [string]$loginName = 'Chuck',
  [Parameter(Mandatory=$false)]
  [string]$accountDomain = 'LRXM',
  [Parameter(Mandatory=$false)]
  [string]$accountName = 'Alice'
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z

#prefix for log file, this is used in flat file path wildcard
$prefix = "winsec"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

#************************************
# User Account Deleted		
$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4726</EventID><Version>0</Version><Level>Information</Level><Task>User Account Management</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>176716</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='572'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='TargetUserName'>$AccountName</Data><Data Name='TargetDomainName'>$LoginDomain</Data><Data Name='TargetSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x79588</Data><Data Name='PrivilegeList'>-</Data></EventData></Event>"


try{
        $log | Set-Content $outputfile
    }catch{
        $ErrorMessage = $_.Exception.Message
        write-host $ErrorMessage 
    }





