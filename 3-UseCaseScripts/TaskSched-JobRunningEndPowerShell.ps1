<#
.SYNOPSIS
Simulates Windows Task Scheduler creating a new task and calling an encoded PowerShell command to avoid detection, uses Windows Task Scheduler Logs.

.DESCRIPTION
Takes one arguments: -serverName

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file TaskSched-JobRunningEncPowerShell.ps1 -serverName "lrxm" 

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$serverName = 'lrxm'
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Windows date format
$now = get-date -format yyyy-mm-ddTHH:mm:ss.ss1234567Z

#prefix for log file, this is used in flat file path wildcard
$prefix = "tasksched"
[string]$random = get-random

$outputfile = $path + $prefix + $random + $extension

$logs = @(" ",
"<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-TaskScheduler' Guid='{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}'/><EventID>110</EventID><Version>0</Version><Level>Information</Level><Task>Task triggered by user</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>14</EventRecordID><Correlation ActivityID='{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}'/><Execution ProcessID='848' ThreadID='15492'/><Channel>Microsoft-Windows-TaskScheduler/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData Name='TaskRunEvent'><Data Name='TaskName'>\AV Update</Data><Data Name='InstanceId'>{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}</Data><Data Name='UserContext'>Administrator</Data></EventData></Event>",
"<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-TaskScheduler' Guid='{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}'/><EventID>200</EventID><Version>1</Version><Level>Information</Level><Task>Action started</Task><Opcode>Start</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>13</EventRecordID><Correlation ActivityID='{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}'/><Execution ProcessID='848' ThreadID='15492'/><Channel>Microsoft-Windows-TaskScheduler/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData Name='ActionStart'><Data Name='TaskName'>\AV Update</Data><Data Name='ActionName'>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data><Data Name='TaskInstanceId'>{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}</Data><Data Name='EnginePID'>12516</Data></EventData></Event>",
"<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-TaskScheduler' Guid='{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}'/><EventID>129</EventID><Version>0</Version><Level>Information</Level><Task>Created Task Process</Task><Opcode>Info</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>11</EventRecordID><Correlation ActivityID='{FDB84D25-9E9E-0002-424D-B8FD9E9ED201}'/><Execution ProcessID='848' ThreadID='15492'/><Channel>Microsoft-Windows-TaskScheduler/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData Name='CreatedTaskProcess'><Data Name='TaskName'>\AV Update</Data><Data Name='Path'>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</Data><Data Name='ProcessID'>12516</Data><Data Name='Priority'>16384</Data></EventData></Event>",
"<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-TaskScheduler' Guid='{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}'/><EventID>100</EventID><Version>0</Version><Level>Information</Level><Task>Task Started</Task><Opcode>Start</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>12</EventRecordID><Correlation ActivityID='{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}'/><Execution ProcessID='848' ThreadID='15492'/><Channel>Microsoft-Windows-TaskScheduler/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData Name='TaskStartEvent'><Data Name='TaskName'>\AV Update</Data><Data Name='UserContext'>LRXM\Administrator</Data><Data Name='InstanceId'>{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}</Data></EventData></Event>",
"<Event xmlns='http://schemas.microsoft.com/win/2004/08/events/event'><System><Provider Name='Microsoft-Windows-TaskScheduler' Guid='{DE7B24EA-73C8-4A09-985D-5BDADCFA9017}'/><EventID>102</EventID><Version>0</Version><Level>Information</Level><Task>Task completed</Task><Opcode>Stop</Opcode><Keywords></Keywords><TimeCreated SystemTime='$now'/><EventRecordID>16</EventRecordID><Correlation ActivityID='{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}'/><Execution ProcessID='848' ThreadID='14720'/><Channel>Microsoft-Windows-TaskScheduler/Operational</Channel><Computer>$servername</Computer><Security UserID='NT AUTHORITY\SYSTEM'/></System><EventData Name='TaskSuccessEvent'><Data Name='TaskName'>\AV Update</Data><Data Name='UserContext'>LRXM\Administrator</Data><Data Name='InstanceId'>{3B80B8C9-5C6E-4CE6-B58A-C9BAC5AC45DB}</Data></EventData></Event>"
)

try{
    Foreach($log in $logs)
        {
            $log | Add-Content $outputfile
        }
    }catch{
            $ErrorMessage = $_.Exception.Message
            write-host $ErrorMessage 
    }





