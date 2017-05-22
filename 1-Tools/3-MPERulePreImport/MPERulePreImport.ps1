# #######################################################################################################
# Update Rule XML prior to import
# Andrew Hollister
# 31-12-12
# v1
# 
# This script updates an exported rule xml file to contain appropriate resource IDs for the target system
# The Script reads the target EMDB to find the latest MPERuleID, MPERuleRegexID, CommonEventID and 
# MsgSourceTypeID, it then updates the IDs in the XML ready for import to the target system
# NB: The script OVERWRITES the source xml file
# 
# This script should be run on the Event Manager containing the target EMDB
# 
# The script has the following steps:
# - prompt for SQL or Windows Authentication
# - prompt for XML file name (fileopen dialog box)
# - retrieve current IDs from EMDB
# - process the xml
# 
# If you want diags, just change the $DebugPreference to "Continue" instead of "SilentlyContinue" below
# #######################################################################################################


# ###############################
# Define constants for the script
# ###############################
#$DebugPreference = "Continue"
$DebugPreference = "SilentlyContinue"

# #############################
# Define script level variables
# #############################
$script:MPERuleID = ""
$script:MPERuleRegExID = ""
$script:CommonEventID = ""
$script:MsgSourceTypeID = ""

# ###############################
# Define Functions for the script
# ###############################

# ###########################
# Prompt for a file selection
Function Get-FileName($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files (*.xml)| *.xml"
 $OpenFileDialog.showHelp = $true
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}

# ##############################
# Prompt for Authentication Type
function Get-LRAuth() {
	Write-Debug "Getting Authentication Type"
	# ----- Build menu constants
	$LRWinInt = New-Object System.Management.Automation.Host.ChoiceDescription "&Windows Auth", `
		"Windows Integrated Authentication"
	$LRSqlAuth = New-Object System.Management.Automation.Host.ChoiceDescription "&SQL Auth", `
		"SQL Authentication"
	$upoptions = [System.Management.Automation.Host.ChoiceDescription[]] ($LRWinInt, $LRSqlAuth)

	$uptitle = "LogRhythm Script"
	$upmessage = "Select the Authentication Method for the SQL Server connection:"
	$result = $Host.UI.PromptForChoice($uptitle, $upmessage, $upoptions, 0)
    switch ($result) {
	0 { Return "Windows"; }
	1 { Return "SQL"; }
	}
}

# ##############################
# Get IDs from the EMDB database
function Get-IDs() {
	Write-Debug "Getting IDs"
	
	# Get the login details if using SQL Server Authentication
	# No extra steps required for Integrated Windows Authentication
	if ($AuthType -eq "SQL") {
		# Ask the user for the SQL User Account
		$sqlusername = Read-Host "Please enter an SQL User account name with rights to read the EMDB.`n(or Enter X to quit)"
		if ($sqlusername -ne "X") {
			# Ask the user for the SQL Password to that account
			$sqlpwd = Read-Host -asSecureString "Please enter the SQL User account password"
			$Server.ConnectionContext.LoginSecure = $false;
			$Server.ConnectionContext.set_login($sqlusername);
			$Server.ConnectionContext.set_SecurePassword($sqlpwd);

		} else {
			"Quitting the script"
			Exit 1
		}
	}
	
	# This is here just to test the credentials
	try { 
		$Server.Logins | Out-Null 
		}
	catch {
		"`nYour credentials were not valid. The script will exit`n"
		Exit 1
	}
	
	# Retrieve each highest numbered ID
	$db = $Server.Databases["LogRhythmEMDB"]
	Write-Debug $db
	try {
		$script:MPERuleID = $db.ExecuteWithResults("SELECT TOP 1 MPERuleID, Name FROM [LogRhythmEMDB].[dbo].[MPERule] where MPERuleID > '1000000000' order by MPERuleID desc").Tables[0].Rows[0].Item('MPERuleID')
	} catch {
		$script:MPERuleID = 1000000000
	}
	Write-Debug "MPERuleID: $MPERuleID"
	try {
		$script:MPERuleRegExID = $db.ExecuteWithResults("SELECT TOP 1 MPERuleRegexID, RegexTagged FROM [LogRhythmEMDB].[dbo].[MPERuleRegex] where MPERuleRegExID > '1000000000' order by MPERuleRegExID desc").Tables[0].Rows[0].Item('MPERuleRegExID')
	} catch {
		$script:MPERuleRegExID = 1000000000
	}
	Write-Debug "MPERuleRegExID: $MPERuleRegExID"
	try {
		$script:CommonEventID = $db.ExecuteWithResults("SELECT TOP 1 CommonEventID, Name FROM [LogRhythmEMDB].[dbo].[CommonEvent] where CommonEventID > '999999999' order by CommonEventID desc").Tables[0].Rows[0].Item('CommonEventID')
	} catch {
		$script:CommonEventID = 999999999
	}
	Write-Debug "CommonEventID: $CommonEventID"
	try {
		$script:MsgSourceTypeID = $db.ExecuteWithResults("SELECT TOP 1 MsgSourceTypeID, Name FROM [LogRhythmEMDB].[dbo].[MsgSourceType] where MsgSourceTypeID > '1000000000' order by MsgSourceTypeID desc").Tables[0].Rows[0].Item('MsgSourceTypeID')
	} catch {
		$script:MsgSourceTypeID = 1000000000
	}
	Write-Debug "MsgSourceTypeID: $MsgSourceTypeID"
}

# #########################
# Write IDs to the XML file
function Write-IDs() {
	# Prompt the user to select the relevant XML file
	"You will now be prompted to select the XML file for processing. Note that the FileOpen Dialog may pop-under"
	$xmlfile = Get-FileName -initialDirectory "C:\LogRhythm"
	if ($xmlfile.length -eq 0){
		"No file selected"
		Exit 1
	}
	# Show the original content of the IDs we are interested in
	# Get-Content($xmlfile) | %{ if ($_.contains('<MPERuleID>') -or $_.contains('<MPERuleRegExID>') -or $_.contains('<CommonEventID>') -or $_.contains('<MsgSourceTypeID>')) {"$_"} }

	#Get the file contents in XML format and list current values
	[xml]$MPERule = Get-Content $xmlfile
	Write-Debug "MPERuleIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MPERuleID} }
	Write-Debug "MPERuleRegExIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MPERuleRegExID } }
	Write-Debug "CommonEventIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.CommonEventID } }
	Write-Debug "MsgSourceTypeIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MsgSourceTypeID } }

	# Handle the MPERuleIDs
	if ($MPERuleID -ne "") {
		$minMPERuleID = $MPERuleID
		Write-Debug "minMPERuleID: $minMPERuleID"
	
		# Populate the array with all the MPERuleIDs found in the XML
		$mpeArray = @()
		$MPERule.ruledataset.childnodes | %{ if([int]$_.MPERuleID -gt 1000000000){$mpeArray += $_.MPERuleID}}
	
		# Remove duplicates from the array and sort descending
		$mpeArray = $mpeArray | sort -descending -uniq
		
		# Iterate through array
		$minMPERuleID = 100 + $mpeArray.count
		$newArray = @()
		foreach ($element in $mpeArray) {
			Write-Debug "element: $element"
			$MPERule.ruledataset.childnodes | %{ if([int]$_.MPERuleID -eq $element){$_.MPERuleID = [string]$minMPERuleID; Write-Debug $minMPERuleID } }
			$newArray += $minMPERuleID			
			$minMPERuleID -= 1
		}
	
		# Sort array ascending
		$newArray = $newArray | sort
		$minMPERuleID = $MPERuleID
		foreach ($element in $newArray) {
			Write-Debug "element: $element"
			$minMPERuleID += 1
			$MPERule.ruledataset.childnodes | %{ if([int]$_.MPERuleID -eq $element){$_.MPERuleID = [string]$minMPERuleID; Write-Debug $minMPERuleID } }
		}
	
	
	}

	# There will only be one MPERuleRegExID in the XML - replace all of them with the same new value
	if ($MPERuleRegExID -ne "") {
		$minMPERuleRegExID = $MPERuleRegExID += 1
		Write-Debug "minMPERuleRegExID: $minMPERuleRegExID"
		$MPERule.ruledataset.childnodes | %{ if([int]$_.MPERuleRegExID -gt 1000000000){$_.MPERuleRegExID = [string]$minMPERuleRegExID; Write-Debug $minMPERuleRegExID } }
	}

	# Handle the CommonEventIDs
	if ($CommonEventID -ne "") {
		$minCommonEventID = $CommonEventID 
		Write-Debug "minCommonEventID: $minCommonEventID"
		
		# Populate the array with all the CommonEventIDs found in the XML
		# CommonEventID>999999999 instead of 1000000000 as number for user CommonEvents starts at 1000000000 not 1000000001
		$ceArray = @()
		$MPERule.ruledataset.childnodes | %{ if([int]$_.CommonEventID -gt 999999999){$ceArray += $_.CommonEventID}}

		# Remove duplicates from the array
		$ceArray = $ceArray | sort -descending -uniq
		
		# Iterate through the array
		$minCommonEventID = 100 + $ceArray.count
		$newArray = @()
		foreach ($element in $ceArray) {
			Write-Debug "element: $element"
			$MPERule.ruledataset.childnodes | %{ if([int]$_.CommonEventID -eq $element){$_.CommonEventID = [string]$minCommonEventID; Write-Debug $minCommonEventID } }
			$newArray += $minCommonEventID
			$minCommonEventID -= 1
		}
	
		
		# Sort array ascending
		$newArray = $newArray | sort
		$minCommonEventID = $CommonEventID 
		foreach ($element in $newArray) {
			Write-Debug "element: $element"
			$minCommonEventID += 1
			$MPERule.ruledataset.childnodes | %{ if([int]$_.CommonEventID -eq $element){$_.CommonEventID = [string]$minCommonEventID; Write-Debug $minCommonEventID } }
		}
	
	}

	# There will only be one MsgSourceTypeID in the XML - replace all of them with the same new value
	if ($MsgSourceTypeID -ne "") {
		$minMsgSourceTypeID = $MsgSourceTypeID += 1
		Write-Debug "minMsgSourceTypeID: $minMsgSourceTypeID"
	$MPERule.ruledataset.childnodes | %{ if([int]$_.MsgSourceTypeID -gt 1000000000){$_.MsgSourceTypeID = [string]$minMsgSourceTypeID; Write-Debug $minMsgSourceTypeID } }
	}

	# Save the new values back to disk - overwrites the existing file
	$MPERule.Save($xmlfile)


	# List the new values
	[xml]$MPERule = Get-Content $xmlfile
	Write-Debug "New MPERuleIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MPERuleID } }
	Write-Debug "New MPERuleRegExIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MPERuleRegExID } }
	Write-Debug "New CommonEventIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.CommonEventID } }
	Write-Debug "New MsgSourceTypeIDs"
	$MPERule.ruledataset.childnodes | %{ if($DebugPreference -eq "Continue"){ $_.MsgSourceTypeID } }
	
	
}

# ##############################
# Actual Script flow starts here
# ##############################

Clear-Host

if (!"Get-Service scarm -ErrorAction SilentlyContinue" ) {
   "This script will only run on the Event Manager"
   exit 1
}

"This Script reads the EMDB to find the latest MPERuleID, MPERuleRegexID, CommonEventID and MsgSourceTypeID"
"It then rewrites a previously exported rule XML file with appropriate IDs"

# Load the .Net Assembly
try {
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
}
catch{
	"An error occurred loading the SQL Server .Net Assembly. The process will exit"
	exit 1
}
try {
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
}
catch{
	"An error occurred loading the SQL Server .Net Assembly. The process will exit"
	exit 1
}

# Create a new object with the local server name
$Server = new-object ("Microsoft.SqlServer.Management.Smo.Server") "localhost"
if (!$Server) {
	Write-Error "An error occured when connecting to the target server"
	exit 1
}

# Select Authentication type
$AuthType = Get-LRAuth
Write-Debug "Authentication Type: $AuthType"

# Pull the latest IDs from the EMDB
Get-IDs

# Write new IDs to the XML file
Write-IDs

# End
"`nLR Script completed - xml file updated`n"






