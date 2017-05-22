# ==============================================================================================
#    NAME: LogRhythm_ReIP.ps1
#  Initial Version by
#  AUTHOR: Nick Carstensen | nick.carstensen@logrhythm.com
#    DATE: 11/5/2013
#  Updated by
#  AUTHOR: Cameron Erens & Jake Halderman | cameron.erens@logrhythm.com; jake.halderman@logrhythm.com
#    DATE: 6/30/16

# COMMENT: Re-IP LogRhythm EMDB and the *.ini files automatically.         
# COMMENT: Script cannot run unless the SQL file "LogRhythm_ReIP.sql" is in the current working directory.          
#   USAGE: .\LogRhythm_ReIP.ps1 <old_ip_address> <new_ip_address)  ( i.e. .\LogRhythm_ReIP.ps1 192.168.1.50 172.16.10.10 )
# 
# ===============================================================================================
# For further notes, see comments within the PowerShell script
