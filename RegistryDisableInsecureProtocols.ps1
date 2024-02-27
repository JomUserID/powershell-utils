<#
.SYNOPSIS
This script disables outdated and insecure protocols (TLS 1.0, TLS 1.1, SSL 2.0, and SSL 3.0) on Windows systems.

.DESCRIPTION
Disabling these protocols enhances the security posture of the system by mitigating various vulnerabilities associated with these older cryptographic standards. It is recommended for systems to rely on more secure protocols like TLS 1.2 and TLS 1.3.

#>

# Define a hashtable for each protocol and its settings
$protocols = @{
    "TLS 1.0" = @("Client", "Server");
    "TLS 1.1" = @("Client", "Server");
    "SSL 2.0" = @("Client", "Server");
    "SSL 3.0" = @("Client", "Server");
}

foreach ($protocol in $protocols.Keys) {
    foreach ($side in $protocols[$protocol]) {
        $path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\$protocol\$side"
        
        # Check if the path exists, create if not
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        # Disable the protocol
        New-ItemProperty -Path $path -Name "Enabled" -Value 0 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null
        New-ItemProperty -Path $path -Name "DisabledByDefault" -Value 1 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null

        Write-Output "$protocol $side has been disabled."
    }
}

Write-Output "All specified protocols have been disabled successfully."
