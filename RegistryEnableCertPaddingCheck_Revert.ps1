$Path1 = "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config"
$Path2 = "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config"


if (!(Test-Path $Path1)) {
    New-Item -Path $Path1 -Force | Out-Null
}
Set-ItemProperty -Path $Path1 -Name "EnableCertPaddingCheck" -Value "0" -Type "String"


if (!(Test-Path $Path2)) {
    New-Item -Path $Path2 -Force | Out-Null
}
Set-ItemProperty -Path $Path2 -Name "EnableCertPaddingCheck" -Value "0" -Type "String"
