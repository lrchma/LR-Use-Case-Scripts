<#
.SYNOPSIS
Windows Process execution showing Sysmon PSExec being called, including command line auditing.

.DESCRIPTION
Takes four arguments: -computer, -loginDomain, -loginName, -psexecCommand

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file WinSec-PSexec.ps1 -computer "lrxm" -loginDomain "lrxm" -loginName "username" -psexecCommand "psexec -accepteula -i -s \\dc01 cmd.exe"

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
  [string]$loginName = 'LRXM$',
  [Parameter(Mandatory=$false)]
  [String]$psexecCommand = 'psexec -accepteula -i -s \\dc01 cmd.exe'
  )

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#https://support.microsoft.com/en-us/help/3004375/microsoft-security-advisory-update-to-improve-windows-command-line-auditing-february-10,-2015
#reg add "hklm\software\microsoft\windows\currentversion\policies\system\audit" /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1

#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z

#prefix for log file, this is used in flat file path wildcard
$prefix = "winsec"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

#powershell.exe -ExecutionPolicy Bypass -w hidden -encodedCommand ZABpAHIAIAAiAGMAOgBcAHAAcgBvAGcAcgBhAG0AIABmAGkAbABlAHMAIgAgAA==
$log ="<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-A5BA-3E3B0328C30D}'/><EventID>4688</EventID><Version>1</Version><Level>Information</Level><Task>Process Creation</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>4828</EventRecordID><Correlation/><Execution ProcessID='4' ThreadID='14908'/><Channel>Security</Channel><Computer>$computer</Computer><Security/></System><EventData><Data Name='SubjectUserSid'>$loginDomain\$loginname</Data><Data Name='SubjectUserName'>$loginname</Data><Data Name='SubjectDomainName'>$servername</Data><Data Name='SubjectLogonId'>0x4d26e</Data><Data Name='NewProcessId'>0x202c</Data><Data Name='NewProcessName'>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data><Data Name='TokenElevationType'>%%1936</Data><Data Name='ProcessId'>0x23ec</Data><Data Name='CommandLine'>$psexecCommand</Data></EventData></Event>"

try{
        $log | Set-Content $outputfile
    }catch{
        $ErrorMessage = $_.Exception.Message
        write-host $ErrorMessage 
    }