<#
.SYNOPSIS
Simulates Windows event log being cleared , uses Windows Security XML Event Logs.

.DESCRIPTION
Takes three arguments: -computer, -loginDomain, -loginName

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file WinSec-LogCleared.ps1 -computer "lrxm" -loginDomain "lrxm" -loginName "user_creating_account" 

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
  [string]$loginName = 'Alice'
)


#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z

#prefix for log file, this is used in flat file path wildcard
$prefix = "winsec"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

$log ="<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Eventlog' Guid='{fc65ddd8-d6ef-4962-83d5-6e5cfe9ce148}'/><EventID>1102</EventID><Version>0</Version><Level>Information</Level><Task>Log clear</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>230786</EventRecordID><Correlation/><Execution ProcessID='980' ThreadID='1088'/><Channel>Security</Channel><Computer>$computer</Computer><Security/></System><UserData><LogFileCleared xmlns=`"http://manifests.microsoft.com/win/2004/08/windows/eventlog`"><SubjectUserSid>S-1-5-21-49845027-3674272275-2964750900-500</SubjectUserSid><SubjectUserName>$LoginName</SubjectUserName><SubjectDomainName>$LoginDomain</SubjectDomainName><SubjectLoginID>0x4d26e</SubjectLoginId></LogFileCleared></UserData></Event>"

try{
        $log | Set-Content $outputfile
   }catch{
        $ErrorMessage = $_.Exception.Message
        write-host $ErrorMessage 
   }