<#
.SYNOPSIS
Simulate new process running in a temporary path, such as Ransomware running in a location that doesn't require administrative privileges prior to priv escalation attempts.  Replays Microsoft Sysmon logs.

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

$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>1</EventID><Version>5</Version><Level>Information</Level><Task>Process Create (rule: ProcessCreate)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='" + $date + ".711598200Z'/><EventRecordID>23572690</EventRecordID><Correlation/><Execution ProcessID='1664' ThreadID='1704'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Process Create:
UtcTime: 2017-01-24 23:17:46.711
ProcessGuid: {725522fb-e09a-5887-0300-00101bff1ad2}
ProcessId: 12300
Image: C:\Users\Charles.Lindbergh\AppData\Roaming\7zbcda.exe
CommandLine: `"C:\Users\$impacteduser\AppData\Roaming\7zbcda.exe`"  a -t7z c:\temp\encrypt.zip C:\Users\$impacteduser\Documents\*
CurrentDirectory: C:\Users\$impacteduser\
User: $servername\$impacteduser
LogonGuid: {725522fb-db9f-5887-0300-0020571111d2}
LogonId: 0x3d2111157
TerminalSessionId: 7
IntegrityLevel: Medium
Hashes: SHA1=F44AC74B7AD88D1A09D182635DA27FCB3D90B9EF
ParentProcessGuid: {725522fb-e04e-5887-0300-00105c6d1ad2}
ParentProcessId: 8376
ParentImage: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ParentCommandLine: `"C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe`" </EventData></Event>"

try{
        $log | Set-Content $outputfile
    }catch{
        $ErrorMessage = $_.Exception.Message
        write-host $ErrorMessage 
    }
