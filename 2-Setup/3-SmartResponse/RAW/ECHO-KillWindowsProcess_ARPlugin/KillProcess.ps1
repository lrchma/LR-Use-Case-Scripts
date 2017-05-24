Param
(
    [string]$targetserver, 
    [string]$targerprocess
)


try{
	write-host "Successfully killed $targerprocess on $targetserver."
 }
 catch{
        echo "SmartResponse Failure.  See logs for further details."
        exit 1
}
            
