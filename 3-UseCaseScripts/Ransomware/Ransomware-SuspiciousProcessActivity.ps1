<#
.SYNOPSIS
Simulate suspicious process activity on an endpoint relating to Ransomware, replays Microsoft Sysmon logs.

.DESCRIPTION
Takes two arguments: -impactedUser & -serverName

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file Ransomware-SuspiciousProcessActivity.ps1 -impactedUser "Charles.Lindbergh" -serverName "LRXM"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$impactedUser = 'charles.lindbergh',
  [Parameter(Mandatory=$false)]
  [string]$serverName = 'lrxm'
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Windows date format, e.g. 2017-04-11T17:06:16
$date = Get-Date -format s

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"

[string]$random = get-random
$outputfile = $path + $prefix + $random + $extension


$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>1</EventID><Version>5</Version><Level>Information</Level><Task>Process Create (rule: ProcessCreate)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$date.123456789Z'/><EventRecordID>22952141</EventRecordID><Correlation/><Execution ProcessID='1664' ThreadID='1704'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Process Create:
UtcTime: 2017-01-20 16:00:31.416
ProcessGuid: {725522fb-341f-5882-0300-00108a194aca}
ProcessId: 13664
Image: C:\Windows\System32\vssadmin.exe
CommandLine: `"C:\Windows\system32\vssadmin.exe`"  List Volumes
CurrentDirectory: C:\Windows\system32\
User: $servername\$impacteduser
LogonGuid: {725522fb-3400-5882-0300-002036cd49ca}
LogonId: 0x3ca49cd36
TerminalSessionId: 0
IntegrityLevel: Medium
Hashes: SHA1=09FAFEB1B8404124B33C44440BE7E3FDB6105F8A
ParentProcessGuid: {725522fb-3400-5882-0300-001065dd49ca}
ParentProcessId: 4760
ParentImage: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ParentCommandLine: `"C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -w hidden -encodedCommand ZABpAHIAIAAiAGMAOgBcAHAAcgBvAGcAcgBhAG0AIABmAGkAbABlAHMAIgAgAA==`"</EventData></Event>"


try{
    $log | Set-Content $outputfile
    }
    catch{
       $ErrorMessage = $_.Exception.Message
       write-host $ErrorMessage 
    }


