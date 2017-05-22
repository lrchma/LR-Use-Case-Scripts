
#############
# VARIABLES #
#############
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$Computer = "LRXM"
$AccountDomain = "EXAMPLE"
$AccountName = "Alice2"
$LoginDomain = "ACME"
$LoginName = "Chuck2"
$IPAddress = "192.168.1.2"
$FileExtension = ".tempaccntabuse.windows.log"
$FilePath = "C:\LogRhythm\Use Cases\Output\"

#############
# FUNCTIONS #
#############
Function Get-RandomFileName($FileExtension,$FilePath){
  $FileName = Get-Random
  $File = -join ($FilePath,$FileName,$FileExtension)
  Write-Output $File
}

###############
# MAIN SCRIPT #
###############

Remove-Item $FilePath*.log

#************************************
# 1 - User Account Created
$log1 = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4720</EventID><Version>0</Version><Level>Information</Level><Task>User Account Management</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>176693</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='9280'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='TargetUserName'>$AccountName</Data><Data Name='TargetDomainName'>$LoginDomain</Data><Data Name='TargetSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x79588</Data><Data Name='PrivilegeList'>-</Data><Data Name='SamAccountName'>$AccountName</Data><Data Name='DisplayName'>%%1793</Data><Data Name='UserPrincipalName'>-</Data><Data Name='HomeDirectory'>%%1793</Data><Data Name='HomePath'>%%1793</Data><Data Name='ScriptPath'>%%1793</Data><Data Name='ProfilePath'>%%1793</Data><Data Name='UserWorkstations'>%%1793</Data><Data Name='PasswordLastSet'>%%1794</Data><Data Name='AccountExpires'>%%1794</Data><Data Name='PrimaryGroupId'>513</Data><Data Name='AllowedToDelegateTo'>-</Data><Data Name='OldUacValue'>0x0</Data><Data Name='NewUacValue'>0x15</Data><Data Name='UserAccountControl'>
		%%2080
		%%2082
		%%2084</Data><Data Name='UserParameters'>%%1793</Data><Data Name='SidHistory'>-</Data><Data Name='LogonHours'>%%1797</Data></EventData></Event>"

[string]$File = Get-RandomFileName -FileExtension $FileExtension -FilePath $FilePath
Out-File -FilePath $File -InputObject $log1 -Encoding ASCII
		
Start-Sleep -s 30		

#************************************		
# 2 - User account logged on with
$log2 = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4624</EventID><Version>0</Version><Level>Information</Level><Task>Logon</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>176705</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='9280'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x795b8</Data><Data Name='TargetUserSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='TargetUserName'>$AccountName</Data><Data Name='TargetDomainName'>$LoginDomain</Data><Data Name='TargetLogonId'>0x1ed2f6c3</Data><Data Name='LogonType'>2</Data><Data Name='LogonProcessName'>seclogo</Data><Data Name='AuthenticationPackageName'>Negotiate</Data><Data Name='WorkstationName'>$Computer</Data><Data Name='LogonGuid'>{00000000-0000-0000-0000-000000000000}</Data><Data Name='TransmittedServices'>-</Data><Data Name='LmPackageName'>-</Data><Data Name='KeyLength'>0</Data><Data Name='ProcessId'>0x350</Data><Data Name='ProcessName'>C:\Windows\System32\svchost.exe</Data><Data Name='IpAddress'>$IPAddress</Data><Data Name='IpPort'>0</Data></EventData></Event>"

[string]$File = Get-RandomFileName -FileExtension $FileExtension -FilePath $FilePath
Out-File -FilePath $File -InputObject $log2 -Encoding ASCII
		
Start-Sleep -s 30

#************************************
# 3 - User Account Deleted		
$log3 = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4726</EventID><Version>0</Version><Level>Information</Level><Task>User Account Management</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>176716</EventRecordID><Correlation/><Execution ProcessID='524' ThreadID='572'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='TargetUserName'>$AccountName</Data><Data Name='TargetDomainName'>$LoginDomain</Data><Data Name='TargetSid'>S-1-5-21-913142522-1338411742-1619602686-1007</Data><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x79588</Data><Data Name='PrivilegeList'>-</Data></EventData></Event>"

[string]$File = Get-RandomFileName -FileExtension $FileExtension -FilePath $FilePath
Out-File -FilePath $File -InputObject $log3 -Encoding ASCII
		
Start-Sleep -s 30

#And rest
