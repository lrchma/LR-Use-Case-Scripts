<#
.SYNOPSIS
Encode/Decode to/from Base64 input

.DESCRIPTION
Takes two arguments, $action = (encode|decode), $value = (base64 encoded input | string to be base64 encoded)

.EXAMPLE
base64.ps1' -action decode -value "VGhpcyBpcyBhIHRlc3Q="

.NOTES
May 2017 @chrismartin

.LINK
https://github.com/lrchma/Use-Case-Scripts

#>

param(
  [Parameter(Mandatory=$true)]
  [string]$action = 'encode',
  [Parameter(Mandatory=$true)]
  [string]$value = 'test'
)


Function Base64Encode($value) 
{
    $encoded = [System.Convert]::ToBase64String([System.Text.Encoding]::UNICODE.GetBytes($value))
    return $encoded    
}

Function Base64Decode($value) 
{
    $decoded = [System.Text.Encoding]::UNICODE.GetString([System.Convert]::FromBase64String($value))
    return $decoded
}


try{
    switch ($action)
    {
        "encode" {
            Base64Encode($value)
        }
        "decode"  {
            Base64Decode($value)
        }  
    }

 }
 catch{
        echo "SmartResponse error.  Exception details: $ErrorMessage = $_.Exception.Message"
        exit 1
}

