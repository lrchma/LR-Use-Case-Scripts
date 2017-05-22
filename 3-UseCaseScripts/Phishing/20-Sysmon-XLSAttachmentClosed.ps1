#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$utc = (get-date).ToUniversalTime().ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")


#Workstation
$serverName = 'LRXM'

#Username & Domain
$loginDomain = "ACME"
$loginName = "bsmith"

#PDF Viewer Closing 
$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>5</EventID><Version>3</Version><Level>Information</Level><Task>Process terminated (rule: ProcessTerminate)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>19809363</EventRecordID><Correlation/><Execution ProcessID='4592' ThreadID='7080'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$serverName</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Process terminated:
UtcTime: $utc
ProcessGuid: {e90c18da-6a3a-5903-0000-001066f01b05}
ProcessId: 5716
Image: C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe</EventData></Event>"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile
