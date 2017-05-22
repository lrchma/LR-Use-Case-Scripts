#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$utc = (get-date).ToUniversalTime().ToString("yyyy-mm-ddTHH:mm:ss.ssfffffffZ")


#Workstation
$serverName = 'LRXM'

#User Name & Domain
$loginDomain = "ACME"
$LoginName = "bsmith"
$sourceIP = '172.16.0.19'
$destIP = '93.184.216.34'

$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Sysmon' Guid='{5770385F-C22A-43E0-BF4C-06F5698FFBD9}'/><EventID>3</EventID><Version>5</Version><Level>Information</Level><Task>Network connection detected (rule: NetworkConnect)</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>21486</EventRecordID><Correlation/><Execution ProcessID='4036' ThreadID='4072'/><Channel>Microsoft-Windows-Sysmon/Operational</Channel><Computer>$serverName</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData>Network connection detected:
UtcTime: $utc
ProcessGuid: {d4fbe8ff-5eda-466f-8922-9ccdbcff2f88}
ProcessId: 4004
Image: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
User: $loginDomain\$LoginName
Protocol: tcp
Initiated: true
SourceIsIpv6: false
SourceIp: $sourceIP
SourceHostname: $serverName
SourcePort: 53777
SourcePortName: 
DestinationIsIpv6: false
DestinationIp: $destIP
DestinationHostname: 
DestinationPort: 80
DestinationPortName: http</EventData></Event><EventData><EventData><Data Name='UtcTime'>2017-04-28 17:12:32.559</Data><Data Name='ProcessGuid'>{D8AFD204-0977-5902-0000-00106DF76E00}</Data><Data Name='ProcessId'>9524</Data><Data Name='Image'>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data><Data Name='User'>SIP01\Administrator</Data><Data Name='Protocol'>tcp</Data><Data Name='Initiated'>true</Data><Data Name='SourceIsIpv6'>false</Data><Data Name='SourceIp'>172.16.0.31</Data><Data Name='SourceHostname'>SIP01</Data><Data Name='SourcePort'>53777</Data><Data Name='SourcePortName'></Data><Data Name='DestinationIsIpv6'>false</Data><Data Name='DestinationIp'>93.184.216.34</Data><Data Name='DestinationHostname'></Data><Data Name='DestinationPort'>80</Data><Data Name='DestinationPortName'>http</Data></EventData>"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "sysmon"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile