##########################################################
# Emails a XP end of life report showing days left and   # 
# the PCs we still need to replace.                      #
##########################################################

# OU to monitor
$ou = "OU=SomeSite,DC=GenCorp,DC=Net"
$to = "Admins@GenCorp.net"
$from = "XP-EOL@GenCorp.net"
$smtpServer = "192.168.0.1"
# Need RSAT Tools
Import-Module ActiveDirectory
# Location of Send-HTML script.
Import-Module .Send-HTMLEmail/Send-HTMLEmail.ps1
# XP End of life is April 8th, 2014
$DaysLeft =  [DateTime]"4/8/2014" - (Get-Date)
$XPComputers = Get-ADComputer -SearchBase $ou -Properties * -Filter {OperatingSystem -like '*Windows*XP*' -and Enabled -eq 'True'} | Select Name,OperatingSystem,LastLogonDate,Description | Sort Name
$Subject = ("{0} days until XP end of life. You still have {1} PCs needing replacement." -f $DaysLeft."Days", ($XPComputers|Measure)."Count") 
Send-HTMLEmail -InputObject $XPComputers -To $to -From $from -Subject $Subject -SmtpServer $smtpServer