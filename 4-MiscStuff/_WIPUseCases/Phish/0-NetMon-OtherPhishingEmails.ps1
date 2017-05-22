#Syslog date format, e.g. Linux Syslog File (<MM> <d> <h>:<m>:<s>)
#$date1 = Get-Date -format 'MM d yyyy hh:mm:ss'
#$date2 = Get-Date -format 'MMM d hh:mm:ss'

$date1 = (get-date).AddHours(-2).ToString("MM d yyyy hh:mm:ss")
$date2 = (get-date).AddHours(-2).ToString("MMM d hh:mm:ss")

$sender = "invoice-finance@gmail.com"
$recipient = "bsmith@acme.com"
$subject = "Overdue Invoice"
$attachment = "Invoice.xls"

$logs = @(" ",
"$date1 172.16.0.21 <LOC4:DBUG> $date2 localhost LogRhythmDpi: EVT:001 2a214253-22b7-4776-9b02-165cb80f4540:00 74.125.136.26,172.16.0.31,25250,25,00:50:56:a7:35:ad,00:1b:17:00:01:12,6,956,39961/39961,1907/1907,49/49,1493393668,1493393675,7/7,dname=mx.google.com,command=EHLO|MAIL|RCPT|BDAT|QUIT,sender=$sender,recipient=alice@acme.com,subject=$subject,object=221,objectname=$attachment"
"$date1 172.16.0.21 <LOC4:DBUG> $date2 localhost LogRhythmDpi: EVT:001 2a214253-22b7-4776-9b02-165cb80f4540:00 74.125.136.26,172.16.0.31,25250,25,00:50:56:a7:35:ad,00:1b:17:00:01:12,6,956,39961/39961,1907/1907,49/49,1493393668,1493393675,7/7,dname=mx.google.com,command=EHLO|MAIL|RCPT|BDAT|QUIT,sender=$sender,recipient=chuck@acme.com,subject=$subject,object=221,objectname=$attachment"
)

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "nm"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

write-host $outputfile

try {
    Foreach($log in $logs)
        {
           $log | Add-Content $outputfile
        }
    }catch{
       $ErrorMessage = $_.Exception.Message
       write-host $ErrorMessage   
    }
