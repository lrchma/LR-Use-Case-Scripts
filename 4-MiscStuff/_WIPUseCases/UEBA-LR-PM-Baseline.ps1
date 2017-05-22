#LogRhythm Process Monitor Format
$date = Get-Date -format 'dd/MM/yyyy H:m:'

$logs = @("PM TIMESTAMP= " + $date + "01 EVENT=START PID=22220 PNAME=process1.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "01 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "02 EVENT=START PID=27213 PNAME=process2.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "02 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "03 EVENT=START PID=17216 PNAME=process3.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "03 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "04 EVENT=START PID=75416 PNAME=process4.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "04 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "05 EVENT=START PID=19992 PNAME=process5.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "05 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "06 EVENT=START PID=11232 PNAME=process6.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "06 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "07 EVENT=START PID=98522 PNAME=process7.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "07 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "08 EVENT=START PID=22122 PNAME=process8.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "08 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "09 EVENT=START PID=34122 PNAME=process9.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "09 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "10 EVENT=START PID=93422 PNAME=process10.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "10 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "11 EVENT=START PID=83222 PNAME=process11.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "11 0000 DETAILS=",
"`r`nPM TIMESTAMP= " + $date + "12 EVENT=START PID=73423 PNAME=process12.exe OWNER=ACME\Alice ORIGIN=JumpBox02 STARTTIME=" + $date + "12 0000 DETAILS=")

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "lr-pm"
[string]$random = get-random
$extension = ".log"
$outputfile = $path + $prefix + $random + $extension

Foreach($log in $logs)
    {
       $log | Add-Content $outputfile
    }






