#PHISHING USE CASE

#############
# VARIABLES #
#############
$Computer = "LRXM" #should match the hostname of the VM and requires an Entity record be created
$LoginDomain = "EXAMPLE"
$LoginName = "Alice"
$IPAddress = "192.168.1.2" #should match the IP address of the VM and requires an Entity record be created
$FileExtension = ".log" #not used in this use case script, manually defined as parameter on Get-RandomFileName()
$FilePath = "C:\LogRhythm\Use Cases\Output\"

#############
# FUNCTIONS #
#############
Function Get-RandomFileName($FileExtension,$FilePath){
  $FileName = Get-Random
  $File = -join ($FilePath,$FileName,$FileExtension)
  Write-Output $File
} 

Function Get-Time($Format){
 switch ($Format)
 { 
  Windows {get-date -format yyyy-MM-ddTHH:mm:ss.012345678Z}
  SyslogHeader {get-date -format "MM dd yyyy HH:mm:ss"}
  Syslog {get-date -format "MMM dd HH:mm:ss"}
  LRFIM {get-date -format "dd/MM/yyyy HH:mm:ss 0100"}
 }
}

###############
# MAIN SCRIPT #
###############

Remove-Item $FilePath*.log


#************************************
#1 - Network Monitor - Phishing Email 
$log1 = "<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 4b03743f-8d06-4bdb-a9fe-63b6bb833376:00 $IPAddress,172.16.0.35,1205,25,00:50:56:a7:00:df,00:50:56:a7:35:ad,6,956,339816/339816,11920/11920,501/501,1475029082,1475029089,7/7,dname=mailserver01.acme.com,command=EHLO|MAIL|RCPT|DATA,sender=invoicetracking@acme.com,recipient=alice@example.com,subject=Status Update For Tracking# 123412341234,object=250,objectname=Invoice.pdf"

[string]$File = Get-RandomFileName -FileExtension ".1.phishing.netmon.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log1 -Encoding ASCII

Start-Sleep -s 30

#************************************
#2 - FIM - Malware dropped onto host via Phishing email
$log2 = "REALTIME FILEMON EVENT=ADD OBJECT=c:\windows\system32\c1.exe USER=$LoginDomain\$LoginName PROCESS=cmd.exe SIZE=0 DETAILS=lastaccess=$(Get-Time("LRFIM")) lastwrite=$(Get-Time("LRFIM")) create=$(Get-Time("LRFIM")) usersid=S-1-5-21-1624190486-2751062232-2429646973-1617 pid=2084 Policy=Example RIM Workstation Policy"

[string]$File = Get-RandomFileName -FileExtension ".2.phishing.fim.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log2 -Encoding ASCII

Start-Sleep -s 30

#************************************
#3 - RIM - Malware persistnece by creating Autorun Key
$log3 = "REGMON EVENT=MODIFY KEY=HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run VALUE=c1.exe USER=$LoginDomain\$LoginName PROCESS=reg.exe DETAILS=time=$(Get-Time("LRFIM")) usersid=S-1-5-21-1624190486-2751062232-2429646973-1617 pid=4652 type=REG_SZ data=c:\windows\system32\c1.exe"

[string]$File = Get-RandomFileName -FileExtension ".3.phishing.rim.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log3 -Encoding ASCII

Start-Sleep -s 30

#************************************
#4 = Network Monitor - Internal Network Scan

$log4 = @(
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 117e0266-5b98-4bb0-b45d-ee23d7391eed:00 $IPAddress,172.16.0.12,36841,22,00:50:56:a7:00:df,00:50:56:a7:78:69,6,734,128/128,0/0,2/2,1475029156,1475029174,18/18",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 235d7ecb-343d-4b3c-bebe-6ea52dda614b:00 $IPAddress,172.16.0.12,36842,22,00:50:56:a7:00:df,00:50:56:a7:78:69,6,734,128/128,0/0,2/2,1475029156,1475029174,18/18",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 9b8a7686-9179-4117-ba13-3dd04c82a833:00 $IPAddress,172.16.0.35,36841,22,00:50:56:a7:00:df,00:50:56:a7:35:ad,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 b378b9ac-ea93-4a7f-9b5b-98ec97eb864e:00 $IPAddress,172.16.0.35,36842,22,00:50:56:a7:00:df,00:50:56:a7:35:ad,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 8fc74e49-1002-4e6c-bcba-f9ddf9a4e935:00 $IPAddress,172.16.0.34,36841,22,00:50:56:a7:00:df,00:50:56:a7:24:41,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 ec2d1eeb-89e9-41cf-ba18-2f9e1aca952a:00 $IPAddress,172.16.0.20,36841,22,00:50:56:a7:00:df,e0:db:55:20:dc:ac,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 a9a65d07-b8e3-4e9e-b593-17b8cd392320:00 $IPAddress,172.16.0.34,36842,22,00:50:56:a7:00:df,00:50:56:a7:24:41,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 08175b3f-8792-4b38-b34a-52d9aefddc0b:00 $IPAddress,172.16.0.20,36842,22,00:50:56:a7:00:df,e0:db:55:20:dc:ac,6,734,128/128,0/0,2/2,1475029156,1475029171,15/15",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 206d91ab-1ba1-44bb-8dd9-cddad883a7f2:00 $IPAddress,172.16.0.21,36841,22,00:50:56:a7:00:df,a0:36:9f:2b:6b:1e,6,734,128/128,64/64,3/3,1475029156,1475029165,9/9",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 80e8aab9-615f-4c06-8c66-ba8f82f45f58:00 $IPAddress,172.16.0.22,36841,22,00:50:56:a7:00:df,00:25:90:d0:a3:bc,6,734,128/128,64/64,3/3,1475029156,1475029165,9/9",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 cc66174b-cc2a-4b28-9c3d-75f975499f18:00 $IPAddress,172.16.0.32,36841,22,00:50:56:a7:00:df,00:50:56:a7:56:1d,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 6a49910c-2a58-4291-8de9-f063c043dcb7:00 $IPAddress,172.16.0.109,36841,22,00:50:56:a7:00:df,00:50:56:a7:50:af,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 21cc3f2f-5ed8-460d-bf69-b8d91021dd3b:00 $IPAddress,172.16.0.33,36841,22,00:50:56:a7:00:df,00:50:56:a7:45:d9,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 f2a67c6f-3361-42a7-9ae6-f5f6188440da:00 $IPAddress,172.16.0.120,36841,22,00:50:56:a7:00:df,90:b1:1c:2f:54:b8,6,734,256/256,64/64,5/5,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 9dfced84-98cb-4546-92b1-e2d79596e8ca:00 $IPAddress,172.16.0.53,36841,22,00:50:56:a7:00:df,00:50:56:a7:01:2e,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 e4b48f1f-d16b-47a5-aff7-6080e8131d31:00 $IPAddress,172.16.0.59,36841,22,00:50:56:a7:00:df,00:50:56:a7:03:8c,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 c47c2e1a-72f3-4fa8-8d96-03145605aebf:00 $IPAddress,172.16.0.241,36841,22,00:50:56:a7:00:df,f0:1f:af:da:bb:70,6,734,128/128,64/64,3/3,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 283e30f0-6afa-4010-b549-17af82919f93:00 $IPAddress,172.16.0.201,36841,22,00:50:56:a7:00:df,00:50:56:a7:40:67,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 9147620d-a2e0-4b3e-afec-6483edd2bb7b:00 $IPAddress,172.16.0.203,36841,22,00:50:56:a7:00:df,00:50:56:a7:6c:e1,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 d8e7126b-fa2d-40da-84ee-b74f831beaa7:00 $IPAddress,172.16.0.104,36841,22,00:50:56:a7:00:df,00:50:56:a7:0c:27,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 ca5a7365-15a7-4965-afac-c769e5ff8a7b:00 $IPAddress,172.16.0.37,36841,22,00:50:56:a7:00:df,00:50:56:a7:0b:61,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 92119119-39a8-42ec-8e20-e7b2dbb7718b:00 $IPAddress,172.16.0.202,36841,22,00:50:56:a7:00:df,00:50:56:a7:69:46,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 b46f19c3-9f7a-42e3-b92e-50bb34eb3657:00 $IPAddress,172.16.0.254,36841,22,00:50:56:a7:00:df,00:1b:17:e9:a6:10,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 4346fc3f-15da-4536-bc6b-0d4e3f83a57e:00 $IPAddress,172.16.0.110,36841,22,00:50:56:a7:00:df,00:50:56:a7:74:d7,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 12f13f01-de54-4835-8943-d9c59becb8ae:00 $IPAddress,172.16.0.89,36841,22,00:50:56:a7:00:df,00:50:56:a7:42:21,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 48054b4d-6de8-4977-ac03-f8aa7f49fc4a:00 $IPAddress,172.16.0.108,36841,22,00:50:56:a7:00:df,00:50:56:a7:31:a9,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 51bda88b-c45f-42cc-ac9e-827c6aa6da4f:00 $IPAddress,172.16.0.107,36841,22,00:50:56:a7:00:df,00:50:56:a7:18:24,6,734,128/128,128/128,4/4,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 2e7cac4c-8f2d-4c50-ac17-7accfd0826e4:00 $IPAddress,172.16.0.38,36841,22,00:50:56:a7:00:df,00:50:56:a7:62:b2,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 6ed80964-8a1c-4095-b0f7-2dc06db315e8:00 $IPAddress,172.16.0.41,36841,22,00:50:56:a7:00:df,00:50:56:a7:60:bf,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6",
"<LOC4:DBUG> $(Get-Time("Syslog")) probe LogRhythmDpi: EVT:001 27dbd256-1774-4e76-a292-2fe901bec4fe:00 $IPAddress,172.16.0.253,36841,22,00:50:56:a7:00:df,00:50:56:a7:03:fb,6,734,256/256,128/128,6/6,1475029156,1475029162,6/6"
)

[string]$File = Get-RandomFileName -FileExtension ".4.phishing.netmon.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log4 -Encoding ASCII

Start-Sleep -s 30

#************************************
#5 - Kippo - Honeypot Tripped
$log5 = @(
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] root trying auth none",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] outgoing: aes256-ctr hmac-sha1 none",
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] root trying auth keyboard-interactive",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] incoming: aes256-ctr hmac-sha1 none",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] Remote SSH version: SSH-2.0-PuTTY_Release_0.63",
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] root failed auth keyboard-interactive",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] starting service ssh-userauth",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] kex alg, key alg: diffie-hellman-group1-sha1 ssh-rsa",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] NEW KEYS",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] Got remote error, code 13",
"$(Get-Time("Syslog")) [HoneyPotTransport,1469,$IPAddress] connection lost",
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] reason:",
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] Traceback (most recent call last):",
"$(Get-Time("Syslog")) [SSHService ssh-userauth on HoneyPotTransport,1469,$IPAddress] root trying auth keyboard-interactive"
)

[string]$File = Get-RandomFileName -FileExtension ".5.phishing.kippo.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log5 -Encoding ASCII

Start-Sleep -s 30

#************************************
#6 - Linux - Brute Force Attack
$log6 =  @(
"$(Get-Time("Syslog")) vgbsrv02 sshd[19984]: Failed password for root from $IPAddress port 1214 ssh2",
"$(Get-Time("Syslog")) vgbsrv02 sshd[19971]: Failed password for root from $IPAddress port 1213 ssh2",
"$(Get-Time("Syslog")) vgbsrv02 sshd[19945]: Failed password for root from $IPAddress port 1212 ssh2",
"$(Get-Time("Syslog")) vgbsrv02 sshd[19930]: Failed password for root from $IPAddress port 1211 ssh2",
"$(Get-Time("Syslog")) vgbsrv02 sshd[19915]: Failed password for root from $IPAddress port 1210 ssh2",
"$(Get-Time("Syslog")) vgbsrv02 sshd[19887]: Failed password for root from $IPAddress port 1209 ssh2"
)

[string]$File = Get-RandomFileName -FileExtension ".6.phishing.linux.log" -FilePath $FilePath
Out-File -FilePath $File -InputObject $log6 -Encoding ASCII

#And we're done!
