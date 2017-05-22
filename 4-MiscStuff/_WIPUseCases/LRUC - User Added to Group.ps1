#VARIABLES
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z
$Computer = "JUMPBOX02"
$AccountDomain = "HR02"
$AccountName = "Alice1"
$LoginDomain = "ACME"
$LoginName = "Chuck1"
$FileExtension = ".useraddedtogroup.windows.log"
$FilePath = "C:\LogRhythm\Use Cases\Output\"
$File = -join ($FilePath,$FileName,$FileExtension)


#FUNCTIONS
Function Get-RandomFileName($FileExtension,$FilePath){
  $FileName = Get-Random
  $File = -join ($FilePath,$FileName,$FileExtension)
  Write-Output $File
}

#MAIN
Remove-Item $FilePath*.log

$log = "<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-Security-Auditing' Guid='{54849625-5478-4994-a5ba-3e3b0328c30d}'/><EventID>4732</EventID><Version>0</Version><Level>Information</Level><Task>Security Group Management</Task><Opcode>Info</Opcode><Keywords>Audit Success</Keywords><TimeCreated SystemTime='$now'/><EventRecordID>949178626</EventRecordID><Correlation/><Execution ProcessID='552' ThreadID='3704'/><Channel>Security</Channel><Computer>$Computer</Computer><Security/></System><EventData><Data Name='MemberName'>-</Data><Data Name='MemberSid'>$AccountDomain\$AccountName</Data><Data Name='TargetUserName'>Administrators</Data><Data Name='TargetDomainName'>Builtin</Data><Data Name='TargetSid'>BUILTIN\Administrators</Data><Data Name='SubjectUserSid'>$LoginDomain\$LoginName</Data><Data Name='SubjectUserName'>$LoginName</Data><Data Name='SubjectDomainName'>$LoginDomain</Data><Data Name='SubjectLogonId'>0x15ae63</Data><Data Name='PrivilegeList'>-</Data></EventData></Event>"

[string]$File = Get-RandomFileName -FileExtension $FileExtension -FilePath $FilePath
Out-File -FilePath $File -InputObject $log -Encoding ASCII

