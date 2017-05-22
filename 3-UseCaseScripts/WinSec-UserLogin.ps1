<#
.SYNOPSIS
Simulate Windows user login activity, uses Windows Security XML Event Logs.

.DESCRIPTION
Takes six arguments: -computer, -loginDomain, -loginName, -accountDomain, -accountName, -ipAddress

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file WinSec-UserLogin.ps1 -computer "lrxm" -loginDomain "lrxm" -loginName "parent_user" -accountDomain "lrxm" -accountName "account_logged_onto" -ipAddress "172.16.0.19"

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
  [string]$accountName = 'Alice',
  [Parameter(Mandatory=$false)]
  [string]$ipAddress = '172.16.0.19'
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
# User account logged on with
$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4624</EventID><Version>0</Version><Level>Information</Level><Task>Logon</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>176705</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='9280'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x795b8</Data><Data Name='TargetUserSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='TargetUserName'>$AccountName</Data><Data Name='TargetDomainName'>$LoginDomain</Data><Data Name='TargetLogonId'>0x1ed2f6c3</Data><Data Name='LogonType'>2</Data><Data Name='LogonProcessName'>seclogo</Data><Data Name='AuthenticationPackageName'>Negotiate</Data><Data Name='WorkstationName'>$Computer</Data><Data Name='LogonGuid'>{00000000-0000-0000-0000-000000000000}</Data><Data Name='TransmittedServices'>-</Data><Data Name='LmPackageName'>-</Data><Data Name='KeyLength'>0</Data><Data Name='ProcessId'>0x350</Data><Data Name='ProcessName'>C:\Windows\System32\svchost.exe</Data><Data Name='IpAddress'>$IPAddress</Data><Data Name='IpPort'>0</Data></EventData></Event>"

try{
    $log | Set-Content $outputfile
}catch{
    $ErrorMessage = $_.Exception.Message
    write-host $ErrorMessage 
}





