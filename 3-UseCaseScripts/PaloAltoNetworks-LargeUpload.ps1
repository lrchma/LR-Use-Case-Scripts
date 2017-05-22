<#
.SYNOPSIS
Simulates Palo Alto Networks firewall recording a large encrypted upload to Box.com

.DESCRIPTION
Takes two arguments: -srcIP, -destIP

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file PaloAltoNetworks-LargeUpload.ps1 -srcIP "1.2.3.4" -destIP "5.6.7.8"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$srcIP = '172.16.0.19',
  [Parameter(Mandatory=$false)]
  [string]$destIP = '65.127.112.139' #Don't change
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Add Syslog Date sometime
#DATE goes here

#prefix for log file, this is used in flat file path wildcard
$prefix = "pan"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

$log = "1,2017/01/07 16:00:43,001801011183,TRAFFIC,end,0,2016/05/22 16:00:43,$srcip,74.112.184.87,$dstip,74.112.184.87,Allow_ACME_Internet,,,boxnet-uploading,vsys1,z-ACME-cxc,z-ACME Link,ethernet1/3.251,ethernet1/1,ACME_Syslog,2016/05/22 16:00:43,115890,1,2171,443,11417,443,0x404053,tcp,allow,79021864,77480007,1541857,77376,2016/05/22 15:50:02,612,online-storage-and-backup,0,69169424183,0x0,192.168.3.0-192.168.3.255,US,0,51729,25647,tcp-rst-from-server"

try{
        $log | Set-Content $outputfile
    }catch{
         $ErrorMessage = $_.Exception.Message
         write-host $ErrorMessage 
    }