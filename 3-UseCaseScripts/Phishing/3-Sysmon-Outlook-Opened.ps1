#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$utc = (get-date).ToUniversalTime().ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")


#Workstation
$serverName = 'LRXM'

#User Name & Domain
$LoginDomain = "ACME"
$LoginName = "bsmith"



#Outlook Loading
$log ="<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>1</EventID><Version>5</Version><Level>Information</Level><Task>Process Create (rule: ProcessCreate)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>19808956</EventRecordID><Correlation/><Execution ProcessID='4592' ThreadID='7080'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$serverName</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Process Create:
UtcTime: $utc
ProcessGuid: {e90c18da-6255-5903-0000-00106b1c1905}
ProcessId: 4512
Image: C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE
CommandLine: `"C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE`" 
CurrentDirectory: C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Office 2013\
User: $LoginDomain\$LoginName
LogonGuid: {e90c18da-5ed7-5903-0000-002091f7f204}
LogonId: 0x4f2f791
TerminalSessionId: 3
IntegrityLevel: Medium
Hashes: SHA1=05c7384911ae95818668736b86a0df56d8c19e2e
ParentProcessGuid: {e90c18da-5edb-5903-0000-00109b5ef304}
ParentProcessId: 4140
ParentImage: C:\Windows\explorer.exe
ParentCommandLine: C:\Windows\Explorer.EXE</EventData></Event>"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile