Param
(
    [string]$hostname, 
    [string]$command,
    [string]$object,
    [string]$key,
    [string]$location,
    [string]$baseURL
)

try{
 switch ($command)
    {
        "get" {write-host "Successfully retrieved $object to $location"} 
        "delete" {write-host "Successfully deleted $object"} 
        "isolate" {write-host "Successfully isolated $hostname"}
        "kill" {write-host "Succesfully killed $object"} 
        "memdump" {write-host "Successfully dumped $hostname to $object"}  
    }
 }
 catch{
        echo "SmartResponse Failure.  See logs for further details."
        exit 1
}
            
