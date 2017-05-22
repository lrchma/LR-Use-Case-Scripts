#AD DNS Logs date format
$date = get-date -format 'dd/MM/yyyy hh:mm:ss tt'

$srcip = '172.16.0.31'
$destip = '93.184.216.34'

$logs = @(" ",
"$date 0E2C PACKET  00000106B9753D50 UDP Rcv $srcIp     0002   Q [0001   D   NOERROR] A      www.example.com",
"$date 0E2C PACKET  00000106B8BD8080 UDP Snd $destIp    dd67   Q [0001   D   NOERROR] A      www.example.com",
"$date 0E2C PACKET  00000106B9640D10 UDP Rcv $destIp    dd67 R Q [8081   DR  NOERROR] A      www.example.com",
"$date 0E2C PACKET  00000106B9753D50 UDP Snd $srcIp     0002 R Q [8081   DR  NOERROR] A      www.example.com",
"$date 0E2C PACKET  00000106BA5ED1B0 UDP Rcv $srcIp     0003   Q [0001   D   NOERROR] AAAA   www.example.com",
"$date 0E2C PACKET  00000106B9753D50 UDP Snd $destIp    09e7   Q [0001   D   NOERROR] AAAA   www.example.com",
"$date 0E2C PACKET  00000106B958B560 UDP Rcv $destIp    09e7 R Q [8081   DR  NOERROR] AAAA   www.example.com",
"$date 0E2C PACKET  00000106BA5ED1B0 UDP Snd $srcIp     0003 R Q [8081   DR  NOERROR] AAAA   www.example.com")


#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "dns"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

try {
    Foreach($log in $logs)
        {
           $log | Add-Content $outputfile
        }
    }catch{
       $ErrorMessage = $_.Exception.Message
       write-host $ErrorMessage   
    }
