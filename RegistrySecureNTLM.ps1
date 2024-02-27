<#
.SYNOPSIS
Enhances the security of NTLM authentication.

.DESCRIPTION
This script adjusts Windows Registry settings to secure NTLM authentication by setting the 'LMCompatibilityLevel' to 3 and ensuring 'NoLMHash' is enabled. These changes enforce the use of NTLMv2 session security, if negotiated, and prevent the storage of LM hash values, mitigating the risk of certain password-related attacks.

.NOTES
Warning: These changes may affect compatibility with older systems or applications that rely on less secure NTLM or LM authentication mechanisms. Ensure thorough testing in your environment before widespread deployment.

#>


# Define registry paths
$lsaPath = "HKLM:\System\CurrentControlSet\Control\Lsa"

# Check if the Lsa registry path exists
if (!(Test-Path $lsaPath)) {
    New-Item -Path $lsaPath -Force | Out-Null
}

# Set 'LMCompatibilityLevel' to 3
Set-ItemProperty -Path $lsaPath -Name "LMCompatibilityLevel" -Type DWord -Value 3

# Check if 'NoLMHash' exists. If not, create it and set it to 1
if (!(Get-ItemProperty -Path $lsaPath -Name "NoLMHash" -ErrorAction SilentlyContinue)) {
    New-ItemProperty -Path $lsaPath -Name "NoLMHash" -Type DWord -Value 1 | Out-Null
} else {
    Set-ItemProperty -Path $lsaPath -Name "NoLMHash" -Value 1
}
