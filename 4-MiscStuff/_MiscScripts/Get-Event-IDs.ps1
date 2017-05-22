Get-EventLog -LogName Security | Group-Object source,eventid | Sort-Object count -desc | Select-Object -first 100 | Format-Table count,name | clip
