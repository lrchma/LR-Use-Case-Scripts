#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$utc = (get-date).ToUniversalTime().ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")
$then = (get-date).AddDays(-7).ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")


#Workstation
$serverName = 'LRXM'

#User Name & Domain
$LoginDomain = "ACME"
$LoginName = "bsmith"

$attachment = "Invoice.xls"

$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385f-c22a-43e0-bf4c-06f5698ffbd9}'/><EventID>2</EventID><Version>4</Version><Level>Information</Level><Task>File creation time changed (rule: FileCreateTime)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>19839388</EventRecordID><Correlation/><Execution ProcessID='2620' ThreadID='2680'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$serverName</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>File creation time changed:
UtcTime: $utc
ProcessGuid: {e90c18da-6255-5903-0000-00106b1c1905}
ProcessId: 4512
Image: C:\Program Files\Microsoft Office\Office15\OUTLOOK.EXE
TargetFilename: C:\Users\$LoginName\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Outlook\1GAF11VU\$attachment
CreationUtcTime: $utc
PreviousCreationUtcTime: $then</EventData></Event>"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile