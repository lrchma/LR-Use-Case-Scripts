<#
.SYNOPSIS
Simulate malicious Windows registry auto-run key being logged by LogRhythm Registry Monitor

.DESCRIPTION
Takes three arguments: -impactedUser, -serverName and -fileName

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file Ransomware-LogRhythmRIM.ps1 -impactedUser "Charles.Lindbergh" -serverName "LRXM" -fileName "c1.exe"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>



param(
  [Parameter(Mandatory=$false)]
  [string]$impactedUser = 'charles.lindbergh',
  [Parameter(Mandatory=$false)]
  [string]$serverName = 'lrxm',
  [Parameter(Mandatory=$false)]
  [string]$fileName = 'asd7hjdf99.exe'
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Syslog date format, e.g. Linux Syslog File (<MM> <d> <h>:<m>:<s>)
$date = Get-Date -format 'MM d yyyy hh:mm:ss tt'

$log = "REGMON EVENT=MODIFY KEY=HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run VALUE=$fileName USER=$servername\$impacteduser PROCESS=Unknown DETAILS=time=$date -0700 usersid=S-1-5-21-4140510078-396723217-1023477983-9221 pid=577984 type=REG_SZ data=c:\windows\system32\$fileName"

#prefix for log file, this is used in flat file path wildcard
$prefix = "rim"

[string]$random = get-random
$outputfile = $path + $prefix + $random + $extension


try {
    $log | Set-Content $outputfile
    }catch{
       $ErrorMessage = $_.Exception.Message
       write-host $ErrorMessage   
    }
