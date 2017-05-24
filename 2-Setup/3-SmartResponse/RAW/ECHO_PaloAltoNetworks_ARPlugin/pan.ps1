Param
(
    [string]$target, 
    [string]$panaddressgroup,
    [string]$pantag
)


try{
	write-host "Successfully added $target to $panaddressgroup."
 }
 catch{
        echo "SmartResponse Failure.  See logs for further details."
        exit 1
}
            
