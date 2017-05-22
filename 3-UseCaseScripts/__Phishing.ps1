clear

$Path = "C:\Logs\Scripts\_WIPUseCases\Phish"

write-host "21-Qualsys-Vulns.ps1"
& "$path\21-Qualsys-Vulns.ps1"

write-host "0-NetMon-OtherPhishingEmails.ps1"
& "$path\0-NetMon-OtherPhishingEmails.ps1"

sleep 10

write-host "1-NetMon-PhishingEmail.ps1"
& "$path\1-NetMon-PhishingEmail.ps1"

sleep 60

write-host "3-Sysmon-Outlook-Opened.ps1"
& "$path\3-Sysmon-Outlook-Opened.ps1"

sleep 60

write-host "4-Sysmon-Outlook-OpenPhishingAttachment.ps1"
& "$path\4-Sysmon-Outlook-OpenPhishingAttachment.ps1"

write-host "5-Sysmon-Outlook-ChangeTempFileTime.ps1"
& "$path\5-Sysmon-Outlook-ChangeTempFileTime.ps1"

sleep 2

write-host "6-Sysmon-Excel-SpawnPowerShellDropper.ps1"
& "$path\6-Sysmon-Excel-SpawnPowerShellDropper.ps1"

sleep 1

write-host "7-DNS-QueryC2.ps1"
& "$path\7-DNS-QueryC2.ps1"

sleep 5

write-host "8-PAN-TIS.ps1"
& "$path\8-PAN-TIS.ps1"

sleep 1

write-host "9-Sysmon-DropperNetworkConnection.ps1"
& "$path\9-Sysmon-DropperNetworkConnection.ps1"

sleep 5

write-host "10-Sysmon-PowerShell-Dropper.ps1"
& "$path\10-Sysmon-PowerShell-Dropper.ps1"

sleep 5

write-host "11-Sysmon-Malware-Dropper.ps1"
& "$path\11-Sysmon-Malware-Dropper.ps1"

sleep 2

write-host "12-PAN-TIS-Deny.ps1"
& "$path\12-PAN-TIS-Deny.ps1"



#write-host "20-Sysmon-XLSAttachmentClosed.ps1"
#& "$20-Sysmon-XLSAttachmentClosed.ps1"
