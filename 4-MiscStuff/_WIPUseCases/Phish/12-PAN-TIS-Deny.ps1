#Syslog date format, e.g. Linux Syslog File (<MM> <d> <h>:<m>:<s>)
$generatedTime = get-date -format 'yyyy/MM/dd hh:mm:ss'
$receivedTime = get-date -format 'yyyy/MM/dd hh:mm:ss'

#Enter the srcip, should map to an Entity record in your deployment
$srcip="172.16.0.19"

#Enter the dstip, should map to a TIS entry in your deployment
$dstip="93.184.216.34"

#Enter the ip range, assumes /24, if not the case change in raw log below
$ipRange = "172.16.0"


$log = "1,$generatedTime,001801011183,TRAFFIC,end,0,$receivedTime,$srcip,$dstip,0.0.0.0,$dstip,Deny_ACME_Internet,,,incomplete,vsys1,z-ACME-cxc,z-ACME Link,ethernet1/3.251,ethernet1/1,ACME_Syslog,$receivedTime,115006,1,2013,80,42096,80,0x40401c,tcp,deny,380,258,122,0,2$receivedTime,18,any,0,69169405283,0x0,$ipRange.0-$ipRange.255,US,0,4,2,tcp-fin"

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "pan"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

$log | Set-Content $outputfile
