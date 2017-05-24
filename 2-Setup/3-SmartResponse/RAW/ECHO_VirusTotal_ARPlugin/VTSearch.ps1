param(
  [Parameter(Mandatory=$true)]
  [string]$Hash = '4eea9bdfe0eb41759d96ec9bd224c4519314a8fa'
)


try{
    $Table = @()
	#Enter Your VirusTotal API Key
	$APIKey = ''
    $Body = @{ resource = $Hash; apikey = $APIKey }
    $Scan = Invoke-RestMethod -Method 'POST' -Uri 'https://www.virustotal.com/vtapi/v2/file/report' -Body $Body

    Write-Host "Virus Total scan results"
    Write-Host "------------------------"
    Write-Host "Positives: " $scan.positives " / " $scan.total
    Write-Host "Scan date: " $scan.scan_date
    Write-Host "URL: " $Scan.permalink
    Write-Host "MD5: " $scan.md5
    Write-Host "SHA1: " $scan.sha1
    Write-Host "SHA256: " $scan.sha256

 }
 catch{
        Write-Host "SmartResponse error.  Exception details: $ErrorMessage = $_.Exception.Message"
        exit 1
}