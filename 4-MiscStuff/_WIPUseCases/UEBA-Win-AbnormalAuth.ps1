#Windows date format
$date = Get-Date -format s

$logs = @("<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4624</EventID><Version>0</Version><Level>Information</Level><Task>Logon</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreatedSystemTime='" + $date + ".123456789Z'/><EventRecordID>176705</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='9280'/><Channel>Security</Channel><Computer>JUMPBOX02</Computer><Security/></System><EventData><Data Name='SubjectUserSid'>ACME\Chuck1</Data><Data Name='SubjectUserName'>Chuck1</Data><Data Name='SubjectDomainName'>ACME</Data><Data Name='SubjectLogonId'>0x795b8</Data><Data Name='TargetUserSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='TargetUserName'>Alice</Data><Data Name='TargetDomainName'>ACME</Data><Data Name='TargetLogonId'>0x1ed2f6c3</Data><Data Name='LogonType'>2</Data><Data Name='LogonProcessName'>seclogo</Data><Data Name='AuthenticationPackageName'>Negotiate</Data><Data Name='WorkstationName'>JUMPBOX02</Data><Data Name='LogonGuid'>{00000000-0000-0000-0000-000000000000}</Data><Data Name='TransmittedServices'>-</Data><Data Name='LmPackageName'>-</Data><Data Name='KeyLength'>0</Data><Data Name='ProcessId'>0x350</Data><Data Name='ProcessName'>C:\Windows\System32\svchost.exe</Data><Data Name='IpAddress'>192.168.3.111</Data><Data Name='IpPort'>0</Data></EventData></Event>")

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "winsec"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

Foreach($log in $logs)
    {
       $log | Add-Content $outputfile
    }