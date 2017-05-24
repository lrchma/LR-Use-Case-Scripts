Param
(
    [string]$targethost, 
    [string]$privusername,
    [string]$privpassword
)


try{
	write-host "Successfully isolated $targethost."
 }
 catch{
        echo "SmartResponse Failure.  See logs for further details."
        exit 1
}
            
