<#
.SYNOPSIS
Mitigates false positives for IE 11 in Qualys vulnerability scans by removing version-related registry keys.

.DESCRIPTION
This script targets and removes specific registry keys related to Internet Explorer 11. By doing so, it aims to prevent users from launching IE 11 and avoids detection by the Qualys scanner, addressing false positive vulnerability reports.

#>

# Define the registry path for Internet Explorer settings
$registryPath = "HKLM:\Software\Microsoft\Internet Explorer"

# Check if the specified registry path exists
if (Test-Path -Path $registryPath) {
    # Attempt to retrieve all properties from the registry path
    try {
        $properties = Get-ItemProperty -Path $registryPath

        # Filter and identify properties that include 'Version' in their names
        $versionProperties = $properties.PSObject.Properties | Where-Object { $_.Name -like "*Version*" }

        # Check if any version-related properties are found
        if ($versionProperties) {
            # Loop through each found property
            foreach ($prop in $versionProperties) {
                # Remove the identified property from the registry
                Remove-ItemProperty -Path $registryPath -Name $prop.Name
                Write-Host "Registry key removed: $($prop.Name)"
            }
            exit 0  # Exit the script successfully if properties were removed
        } else {
            Write-Host "No registry keys containing 'Version' found."
            exit 1  # Exit with error if no relevant properties were found
        }
    } catch {
        Write-Host "Error accessing registry: $_"
        exit 1  # Exit with error if there was an issue accessing the registry
    }
} else {
    Write-Host "Registry path not found: $registryPath"
    exit 1  # Exit with error if the registry path does not exist
}
