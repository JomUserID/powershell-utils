<#
.SYNOPSIS
Disables SMB Signing for Microsoft Network Client and Server.

.DESCRIPTION
This script alters the Windows Registry settings to disable SMB signing on both the Microsoft Network Client and Server. While SMB signing enhances security by preventing man-in-the-middle attacks, in certain environments, the need for compatibility with older systems or devices that do not support SMB signing may necessitate disabling it.

.NOTES
Warning: Restarting the Server service can cause temporary disruption to SMB services. Ensure this script is run during a maintenance window or when the impact is minimal.

#>

# Enable SMB signing for Microsoft Network Client
$networkClientKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$networkClientValueName = "RequireSecuritySignature"
$networkClientValueData = 0

Set-ItemProperty -Path $networkClientKey -Name $networkClientValueName -Value $networkClientValueData -Type DWord

# Enable SMB signing for Microsoft Network Server
$networkServerKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$networkServerValueName = "RequireSecuritySignature"
$networkServerValueData = 0

Set-ItemProperty -Path $networkServerKey -Name $networkServerValueName -Value $networkServerValueData -Type DWord

# Restart the Server service to apply the changes
Restart-Service -Name LanmanServer -Force
