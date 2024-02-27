<#
.SYNOPSIS
Resets Windows Update components to resolve common issues.

.DESCRIPTION
This script stops essential Windows Update services, clears the Windows Update cache and restarts the services. It's designed to fix common problems with Windows Update, such as failed installations and downloads.

#>

$services = @("wuauserv", "cryptSvc", "bits", "msiserver")

function Stop-Services {
    $services | ForEach-Object { net stop $_ }
}

function Start-Services {
    $services | ForEach-Object { net start $_ }
}

function Reset-UpdateComponents {
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate", "C:\Windows\SoftwareDistribution", "C:\Windows\System32\catroot2" -Recurse -Force -ErrorAction Ignore
    New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Force -ErrorAction Ignore
}

Stop-Services
Reset-UpdateComponents
Start-Services
