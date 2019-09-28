# ----------------------------------------------------------------------------
# Script: Internet Access Control
# Version: 1.0
# Author: Mike Galvin
# Contact: mike@gal.vin or twitter.com/mikegalvin_
# Date: 2019-09-28
# ----------------------------------------------------------------------------

# Creates the disable option used by the script
Param(
   [parameter(Mandatory=$False)]
   [switch]$Enable,
   [switch]$Disable
)

# If the -disable switch is used, the script adds a Firewall Rule to block traffic on ports 80 (http) and 443 (https).
If ($Disable)
{
   Write-Output "Blocking Ports 80 and 443"
   New-NetFirewallRule -DisplayName "Block Outgoing 80, 443" -Enabled True -Direction Outbound -Profile Any -Action Block -Protocol TCP -RemotePort 80,443
}

# If the -enable switch is used, the script removes the Firewall Rule created above.
If ($Enable)
{
   Write-Output "Allowing Ports 80 and 443"
   Get-NetFirewallRule -DisplayName "Block Outgoing 80, 443" | Remove-NetFirewallRule
}

# End