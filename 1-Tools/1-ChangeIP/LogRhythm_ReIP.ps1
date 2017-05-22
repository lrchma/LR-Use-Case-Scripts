# ==============================================================================================
#    NAME: LogRhythm_ReIP.ps1
#  Initial Version by
#  AUTHOR: Nick Carstensen | nick.carstensen@logrhythm.com
#    DATE: 11/5/2013
#  Updated by
#  AUTHOR: Cameron Erens & Jake Halderman | cameron.erens@logrhythm.com; jake.halderman@logrhythm.com
#    DATE: 6/30/16

# COMMENT: Re-IP LogRhythm EMDB and the *.ini files automatically.  
# COMMENT: Script cannot run unless the SQL file "LogRhythm_ReIP.sql" is in the current working directory.       
#   USAGE: .\LogRhythm_ReIP.ps1 <old_ip_address> <new_ip_address)  ( i.e. .\LogRhythm_ReIP.ps1 192.168.1.50 172.16.10.10 )
# ===============================================================================================


[CmdletBinding()]
Param (
    [Parameter(Position=0)]
    [string]$old_ip,

    [Parameter(Position=1)]
    [string]$new_ip
)


function SQLUpdate {
    # Now get ready to run the .SQL script to update the IP addresses within the LogRhythm EMDB (configuration) database
    $message = "LogRhythm databse credentials needed.  Please enter the sa password."
    Write-Host $message
    $Credential = $Host.ui.PromptForCredential("Need database credentials.", $message, "sa", "")
    $framework=$([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory())

    #$currentPath=Split-Path ((Get-Variable MyInvocation -Scope 0).Value).MyCommand.Path
    $scriptFile = ".`\LogRhythm_ReIP.sql"
    $server = "localhost"
    $username = "sa"
    $password = $Credential.GetNetworkCredential().password

	$exe = "SQLCMD.EXE"
	&$exe -v OLDIP=$old_ip ip=$new_ip -m-1  -i $scriptFile -S $server -U $username -P $password | Tee-Object -Variable sqlOut
	
	if ($sqlOut -like "*Login failed*") {
		$message = "The SQL Command failed due to an incorrect password, would you like to try again?"
		$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
		if($result -eq 0) { SQLUpdate } 
		if($result -eq 1) { return }
		}
}
    


#Check to make sure running as Admin, this is required to start/stop services
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nRe-run this script as an Administrator (needed to stop/start services)."
    exit
}
if(!$old_ip -OR !$new_ip)
{

		$old_ip = Read-host "What is the OLD IP Address being replaced?";

		$new_ip = Read-host "What is the NEW IP Address being used?";
}
# Making sure SQL file is in the right place
	if (! (Test-Path ".\LogRhythm_ReIP.sql")) {
	Write-Warning "SQL file was not found!  Script cannot run unless the SQL file `"LogRhythm_ReIP.sql`" is in the current working directory."
	exit
}
$services = "lrjobmgr","scarm","LRAIEComMgr","LRAIEEngine","scmedsvr","scsm","LogRhythm Services Host"

Write-Host "1) Assuming this is an XM with a Windows-based DX, if you changed the Data Indexer (ElasticSearch) IP from the default"
Write-Host " 127.0.0.1, then, FIRST log in into the DX config webpage (http://ip_of_this_XM:9100) to update the IP!  In any case,"
Write-Host " note that the script will NOT need to stop the DX services."
Write-Host "2) Please close any instances of the LogRhythm Console.  The script will stop the LogRhythm services automatically."
Write-Host "3) If you already have LogRhythm Console installed & configured for auto-login on any remote workstations,"
Write-Host " then on those workstations, you will need to delete "
Write-Host " C:\Users\%username%\AppData\Roaming\LogRhythm\config\prefs_Startup.cfg so that you are prompted for the new IP."
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
$caption = "Warning!"
$message = "Are you sure you want to proceed & change all instances in the LogRhythm config of $old_ip to $new_ip`?"
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "You answered YES"} 
if($result -eq 1) { Write-Host "You answered NO, Exiting"; exit }
# File Security Bypass
$env:SEE_MASK_NOZONECHECKS = 1


Write-Host "Stopping the LogRhythm services..."
# Stop LogRhythm services
$ScriptBlock = {
	param($s)
	$service = Get-Service $s
	if($service.Status -eq "Running") {
		Stop-Service $s
	}
}
foreach($s in $services) { Start-Job $ScriptBlock -ArgumentList $s | out-null}

$KeepRunning = $true
$i = 0
While ($KeepRunning)
{
	
	$jobs = Get-Job -State "Running" | out-null
	if($jobs.ChildJobs.count -gt 0) {
		Write-Progress -Activity "Stopping LogRhythm Services" -Status "Stopping services" -percentComplete ($i)
	$i = $i + 15
	} else {
		$KeepRunning = $false}
	Start-Sleep -s 1
}


$all_stopped = $false
$timer = 0
$sleep_seconds = 5
$timer_max = 60
while($timer -lt $timer_max -AND -NOT $all_stopped)
{
    $i = 0
    if($timer -eq 0)
    {
        Write-Host "Checking status of the LogRhythm services..."
    }
    else
    {
        Write-Host "Checking status of the LogRhythm services, waiting $timer of $timer_max seconds..."
    }
    foreach($s in $services) 
    {
        $status = (Get-Service | Where-Object { $_.Name -eq $s} ).status
        # Write-Host "$s status is: $status"
        if( $status -eq "Pending" -OR $status -eq "StopPending" )
        {
            $all_stopped = $false
            Write-Host -ForegroundColor Yellow " $s is still stopping..."
        }
        elseif($status -eq "Stopped")
        {
            if($i -eq 0)
            {
                $all_stopped = $true
            }
            Write-Host -ForegroundColor Green " $s is stopped!"
        }
        elseif($timer -ge $timer_max - $sleep_seconds )
        {
            $all_stopped = $false
        }
        elseif($status -eq "Running")
        {
            $all_stopped = $false
            Write-Host -ForegroundColor Yellow " $s is still running."
        }
        else
        {
            $all_stopped = $false
            Write-Host -ForegroundColor Yellow " $s is in status: $status"
        }
        $i = $i + 1
    }
    $timer = $timer + $sleep_seconds
    Start-Sleep -s $sleep_seconds
}
if($all_stopped)
{
    Write-Host -ForegroundColor Green "Successfully stopped all of the LogRhythm services!!"
    Start-Sleep -s $sleep_seconds
}
else
{
    Write-Host -ForegroundColor Red "$s has not yet stopped & this script has run out of patience!"
    Write-Host -ForegroundColor Red "Please make sure this service is stopped before continuing."
    $message = "Would you like to continue?"
	$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
	if($result -eq 1) { exit }
}

$message = "Would you like to proceed updating the IP addresses in the LogRhythm configuration (.ini) files?"
Write-Host $message
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "You answered YES"} 
if($result -eq 1) { Write-Host "You answered NO, Exiting"; exit }

$files = "C:\Program Files\LogRhythm\LogRhythm System Monitor\config\scsm.ini",
		"C:\Program Files\LogRhythm\LogRhythm Mediator Server\config\scmedsvr.ini",
		"C:\Program Files\LogRhythm\LogRhythm Job Manager\config\lrjobmgr.ini",
		"C:\Program Files\LogRhythm\LogRhythm Alarming and Response Manager\config\scarm.ini",
		"C:\Program Files\LogRhythm\LogRhythm AI Engine\config\LRAIEEngine.ini",
        "$env:APPDATA\LogRhythm\config\prefs_Startup.cfg"
		
foreach($file in $files)
{
    try {
	    $BkpFileArray = $file.split('.')
	    $BkpFile = "$($BkpFileArray[0]).$($BkpFileArray[1]).bak" 
	    Copy-Item "$file" "$BkpFile" -force
	    Write-Host "Made a backup copy at: $BkpFile"
	    (get-content "$file") | foreach-object {$_ -replace $old_IP, $new_ip} | set-content "$file"
	    if(Compare-Object -ReferenceObject $(Get-Content "$file") -DifferenceObject $(Get-Content "$BkpFile"))
        {
		    Write-Host "$file has been modified" -ForegroundColor green
	    }
        else {
		    Write-Host "$file has NOT been modified" -ForegroundColor yellow
	    }
    }
    Catch {
	    Write-Host -ForegroundColor yellow "Error changing IPs in $file!`n`n"
	    Write-Host "Error Message: $($_.Exception.Message)"
	    $message = "Would you like to continue updating the IP addresses in the .ini files?"
        Write-Host $message
	    $result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
	    if($result -eq 0) { Write-Host "Continuing"} 
	    if($result -eq 1) { Write-Host "Exiting"; exit }
    }
}

$message = "Finished attempting to update the IP within the LogRhythm configuration files.
Write-Host $message
Ready to update the IP addresses in the LogRhythm EMDB?"
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "You answered YES"} 
if($result -eq 1) { Write-Host "You answered NO, Exiting"; exit }

SQLUpdate

$message = "Ready to start all of the LogRhythm services?"
Write-Host $message
$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
if($result -eq 0) { Write-Host "You answered YES"} 
if($result -eq 1) { Write-Host "You answered NO, Exiting"; exit }

Write-Host "Starting the LogRhythm services..."
# Start LogRhythm services
$ScriptBlock = {
	param($s)
	$service = Get-Service $s
	if($service.Status -eq "Stopped") {
		Start-Service $s
	}
}
foreach($s in $services) { Start-Job $ScriptBlock -ArgumentList $s | out-null}

$KeepRunning = $true
$i = 0
While ($KeepRunning)
{
	
	$jobs = Get-Job -State "Running" | out-null
	if($jobs.ChildJobs.count -gt 0) {
		Write-Progress -Activity "Starting LogRhythm Services" -Status "Starting services" -percentComplete ($i)
	$i = $i + 15
	} else {
		$KeepRunning = $false}
}


$all_started= $false
$timer = 0
$sleep_seconds = 5
$timer_max = 60
while($timer -lt $timer_max -AND -NOT $all_started)
{
    if($timer -eq 0)
    {
        Write-Host "Checking status of the LogRhythm Services..."
    }
    else
    {
        Write-Host "Checking status of the LogRhythm services, waiting $timer of $timer_max seconds..."
      
    }
    foreach($s in $services) 
    {
        $i = 0
        $status = (Get-Service | Where-Object { $_.Name -eq $s} ).status
	    if($status -eq "StartPending") {
            #Write-Host "service $s status: $status"
            Write-Host -ForegroundColor Yellow " $s is still starting..."
            $all_started = $false
        }
        elseif($status -eq "Running")
        {
            if($i -eq 0)
            {
                $all_started = $true
            }
            Write-Host -ForegroundColor Green " $s has started!"
        }
        elseif($timer -ge $timer_max - $sleep_seconds )
        {
            $all_started=$false
            
	    }
        elseif($status -eq "Stopped")
        {
             Write-Host -ForegroundColor Yellow " $s is still stopped."
             $all_started = $false
        }
        
        else
        {
            $all_started=$false
            Write-Host -ForegroundColor Yellow " $s is in status: $status"
        }
        $i = $i + 1
    }
    $timer = $timer + $sleep_seconds
    Start-Sleep -s $sleep_seconds
}
if($all_started)
{
    Write-Host -ForegroundColor Green "Successfully started all of the LogRhythm services!!"
}
else
{
    Write-Host -ForegroundColor Red "$s has not yet started & this script has run out of patience!"
	Write-Host -ForegroundColor Red " Please ensure the service has started."
}

# Remove File Security Bypass
Remove-Item env:\SEE_MASK_NOZONECHECKS