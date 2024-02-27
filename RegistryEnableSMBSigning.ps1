<#
.SYNOPSIS
Enables SMB Signing for Microsoft Network Client and Server.

.DESCRIPTION
This script configures the Windows Registry to enforce SMB signing on both the Microsoft Network Client and Server. SMB signing enhances security by ensuring the authenticity of the SMB traffic between the client and the server. This is crucial for preventing man-in-the-middle attacks in environments where SMB traffic is not encrypted.

.NOTES
Warning: Restarting the Server service can cause temporary disruption to SMB services. Ensure this script is run during a maintenance window or when the impact is minimal.

#>


# Enable SMB signing for Microsoft Network Client
$networkClientKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
$networkClientValueName = "RequireSecuritySignature"
$networkClientValueData = 1

Set-ItemProperty -Path $networkClientKey -Name $networkClientValueName -Value $networkClientValueData -Type DWord

# Enable SMB signing for Microsoft Network Server
$networkServerKey = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$networkServerValueName = "RequireSecuritySignature"
$networkServerValueData = 1

Set-ItemProperty -Path $networkServerKey -Name $networkServerValueName -Value $networkServerValueData -Type DWord

# Restart the Server service to apply the changes
Restart-Service -Name LanmanServer -Force