<#
.SYNOPSIS
Simulates Palo Alto Networks firewall recording a network connection that then matches a LogRhythm Threat Intelligence Service watchlist.

.DESCRIPTION
Takes two arguments: -srcIP, -destIP

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file PaloAltoNetworks-TIS.ps1 -srcIP "1.2.3.4" -destIP "5.6.7.8"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$srcIP = '172.16.0.19',
  [Parameter(Mandatory=$false)]
  [string]$destIP = '93.184.216.34' #Don't change
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Add Syslog Date sometime


#prefix for log file, this is used in flat file path wildcard
$prefix = "pan"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

$log = "1,2016/05/22 15:49:40,001801011183,TRAFFIC,end,0,2016/05/22 15:49:40,$srcip,$dstip,0.0.0.0,$dstip,Allow_ACME_Internet,,,incomplete,vsys1,z-ACME-cxc,z-ACME Link,ethernet1/3.251,ethernet1/1,ACME_Syslog,2016/05/22 15:49:40,115005,1,2013,80,42096,80,0x40401c,tcp,allow,380,258,122,6,2016/05/22 15:49:07,18,any,0,69169405283,0x0,192.168.3.0.0-192.168.255.255,US,0,4,2,tcp-fin"

try{
    $log | Set-Content $outputfile
    }catch{
         $ErrorMessage = $_.Exception.Message
         write-host $ErrorMessage 
    }