

$serverIP = "172.16.0.19"
$serverName = "LRXM" 
$firstFound = (get-date).AddHours(-1).ToString("yyyy-MM-dd hh:mm:ss")
$lastFound = (get-date).AddHours(-24).ToString("yyyy-MM-dd hh:mm:ss")

$logs = @(" ",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=3389 PROTOCOL=tcp QID=38170 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=SSL Certificate - Subject Common Name Does Not Match Server FQDN VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=2 PATCHABLE=0 KBLASTUPDATE= CVE=",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=443 PROTOCOL=tcp QID=38170 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=SSL Certificate - Subject Common Name Does Not Match Server FQDN VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=2 PATCHABLE=0 KBLASTUPDATE= CVE=",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=443 PROTOCOL=tcp QID=38657 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=Birthday attacks against TLS ciphers with 64bit block size vulnerability (Sweet32) VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=3 PATCHABLE=0 KBLASTUPDATE= CVE=CVE-2016-2183(http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-2183)",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=3389 PROTOCOL=tcp QID=38657 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=Birthday attacks against TLS ciphers with 64bit block size vulnerability (Sweet32) VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=3 PATCHABLE=0 KBLASTUPDATE= CVE=CVE-2016-2183(http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-2183)",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=3389 PROTOCOL=tcp QID=38601 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=SSL/TLS use of weak RC4 cipher VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=3 PATCHABLE=0 KBLASTUPDATE= CVE=CVE-2013-2566(http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2013-2566),CVE-2015-2808(http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-2808)",
"HOSTIP=$serverIP HOSTNAME=$serverName HOSTOS=Windows Vista / Windows 2008 / Windows 7 / Windows 2012 / Windows 8 PORT=3389 PROTOCOL=tcp QID=38628 DETECTIONTYPE=Confirmed STATUS=Active FIRSTFOUND=$firstFoundZ LASTFOUND=$lastFoundZ VULNERABILITY=SSL/TLS Server supports TLSv1.0 VULNERABILITYTYPE=Vulnerability CATEGORY=General remote services SEVERITYLEVEL=3 PATCHABLE=0 KBLASTUPDATE= CVE="
)

#needs trailing backslash
$path = "c:\logs\"

#prefix for log file, this is used in flat file path wildcard
$prefix = "qualys"
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

   
#^HostIP=<dip>\sHostname=(?<dname>.*?) HostOS=(?<version>.*?) port=(?<dport>.*?) Protocol=(?<protname>.*?) qid=\d+ Detectiontype=(?<tag2>.*?) Status=(?<tag3>.*?)\s.*?Vulnerability=(?<threatname>.*?) Vulnerabilitytype=.*? Category=(?<tag4>.*?) SeverityLevel=(?<severity>(?<tag5>.*?))\s.*?CVE=(?<cve>CVE-\d+-\d+)?(?<vendorinfo>.*?)$