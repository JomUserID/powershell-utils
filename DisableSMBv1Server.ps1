<#
.SYNOPSIS
Disables SMBv1 Server to mitigate CVE-2017-0144.

.DESCRIPTION
This script disables the SMBv1 Server on Windows systems as a security measure against CVE-2017-0144, a known Windows SMB Remote Code Execution Vulnerability. By disabling SMBv1, the script helps protect the system from exploits targeting this outdated protocol. The script includes functionality to check the current SMBv1 status before and after attempting to disable it, ensuring the operation's success.

.NOTES
Warning: Disabling SMBv1 may impact older applications or devices that rely on this protocol for file sharing or network communication. Ensure compatibility testing is conducted before deployment in a production environment.

#>


function CheckSMBv1ServerStatus {
    try {
        $SMBServerConfig = Get-SmbServerConfiguration
        if ($SMBServerConfig.EnableSMB1Protocol -eq $false) {
            Write-Output "SMBv1 Server is disabled."
        } else {
            Write-Output "SMBv1 Server is enabled."
        }
    } catch {
        Write-Output "Error retrieving SMBv1 Server configuration."
    }
}

# Check SMBv1 Server status before disabling the protocol
CheckSMBv1ServerStatus

# Disable SMBv1 Protocol on the Server
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

# Check SMBv1 Server status again after disabling the protocol
CheckSMBv1ServerStatus
