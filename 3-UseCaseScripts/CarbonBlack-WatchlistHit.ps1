<#
.SYNOPSIS
Simulates a watchlist binary hit on Carbon Black.  Replays Carbon Black Respond logs.

.DESCRIPTION
Takes four arguments: -serverName, -fileName, userName and fileHash

.EXAMPLE
./C:\Windows\System32\WindowsPowershell\v1.0\powershell.exe -file CarbonBlack-WatchlistHit.ps1 -serverName "lrxm" -fileName "malicious.exe" -userName "victim" -fileHash "1234"

.NOTES
April 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$false)]
  [string]$serverName = 'lrxm',
  [Parameter(Mandatory=$false)]
  [string]$fileName = 'asdasdas.exe',
  [Parameter(Mandatory=$false)]
  [string]$userName = 'chuck',
  [Parameter(Mandatory=$false)]
  [string]$fileHash = '3bb7044eac724f7ac698504788c32712' #Don't change unless updated corresponding Threat List
)

#Dot Source Variables - scripts need have the working directory as this path or they'll fail
. .\variables.ps1

#Carbon Black Syslog Date
#TODO, at present simply rely on the acceptance date, i.e., not time parsing on log source

#prefix for log file, this is used in flat file path wildcard
$prefix = "cb"

[string]$random = get-random
$outputfile = $path + $prefix + $random + $extension

$log = '2017-01-09 14:07:05.485397 05 18 2016 09:46:15 10.0.6.250 <USER:NOTE> LEEF:1.0|CB|CB|5.1|watchlist.hit.binary|cb_server=cbserver	cb_version=511	comments=unknown	company_name=unknown	copied_mod_len=606208	digsig_result=Unsigned	digsig_result_code=2148204800	endpoint=["' + $servername + '|34"]	file_desc=unknown	file_version=5.0.1.0	group=["HQ"]	host_count=1	internal_name=' + $fileName + '	is_64bit=false	is_executable_image=true	last_seen=2016-05-18T16:39:27.05Z	legal_copyright=Warez Inc	md5=' + $fileHash + '	observed_filename=["c:\\users\\' + $userName + '\\appdata\\local\\temp\\qxhr91h5.wgv\\apgwqggq.h1d\\' + $fileName + '"]	orig_mod_len=606208	original_filename=' + $fileName + '	os_type=Windows	product_name=unknown	product_version=5.0.1.0	server_added_timestamp=2016-05-18T16:39:27.05Z	server_name=carbon02	signed=Unsigned	timestamp=2016-05-18T16:39:27.05Z	type=watchlist.hit.binary	watchlist_id=4	watchlist_name=Newly Loaded Modules'

try {
    $log | Set-Content $outputfile
    }catch{
        $ErrorMessage = $_.Exception.Message
        write-host $ErrorMessage 
    }