<#
.SYNOPSIS
Reverts NTLM authentication security enhancements.

.DESCRIPTION
This script modifies Windows Registry settings to revert changes made to secure NTLM authentication. It sets the 'LMCompatibilityLevel' back to 1 and removes the 'NoLMHash' setting if present. These actions restore compatibility with systems or applications requiring less secure NTLM or LM authentication mechanisms but may increase vulnerability to specific password-related attacks.

.NOTES
Warning: Reverting these security settings can reduce the system's defense against certain attacks. It's recommended to evaluate the necessity of these changes carefully and consider maintaining enhanced security settings where possible.

#>


# Define registry paths
$lsaPath = "HKLM:\System\CurrentControlSet\Control\Lsa"

# Check if the Lsa registry path exists
if (Test-Path $lsaPath) {
    # Set 'LMCompatibilityLevel' to 1
    Set-ItemProperty -Path $lsaPath -Name "LMCompatibilityLevel" -Type DWord -Value 1

    # Check if 'NoLMHash' exists. If it does, remove it
    if (Get-ItemProperty -Path $lsaPath -Name "NoLMHash" -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $lsaPath -Name "NoLMHash"
    }
} else {
    Write-Output "Registry path $lsaPath does not exist."
}
