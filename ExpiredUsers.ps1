<#
.SYNOPSIS
Identifies users with passwords expiring within the next week and sends a report via email.

.DESCRIPTION
This script queries Active Directory for enabled users and checks for password expiration dates falling within the upcoming week. It compiles a list of these users, generates a report, and emails this report to a specified recipient. 

.NOTES
Dependencies:   ActiveDirectory Module
Warning:        

#>


Import-Module ActiveDirectory

$outputFile = "C:\temp\expired_users.txt"
$errorLog = "C:\temp\error_log.txt"

Remove-Item $outputFile
Remove-Item $errorLog

# Email parameters
$smtpServer = "smtp01.example.com"
$smtpPort = 465  # Change this to your SMTP server's port
$smtpUser = "from-email@example.com"

# Email recipient and subject
$to = "to-email@example.com"
$subject = "Passwords Expiring this Week"

# Initialize the array for storing user data
$userData = @()

# Get current date and end of the week date (upcoming Sunday 11:59 PM)
$currentDate = Get-Date
$endOfWeek = (Get-Date).AddDays(7 - (Get-Date).DayOfWeek.value__).Date.AddHours(23).AddMinutes(59).AddSeconds(59)

$users = Get-ADUser -Filter 'Enabled -eq $true' | Select-Object SamAccountName

foreach ($user in $users) {
    try {
        $dateInfo = net user $user.SamAccountName | findstr /C:"Password expires"

        # Extracting the date from the string
        if ($dateInfo -match '(\d{1,2}/\d{1,2}/\d{4})') {
            $expirationDate = New-Object DateTime
            $parseResult = [datetime]::TryParse($matches[1], [ref]$expirationDate)

            if ($parseResult -and $expirationDate -ge $currentDate -and $expirationDate -le $endOfWeek) {
                # Create a custom object and add it to the array
                $userData += New-Object PSObject -Property @{
                    UserName = $user.SamAccountName
                    ExpirationDate = $expirationDate
                }
            }
        } else {
            throw "Date format not found or not recognized"
        }
    } catch {
        $errorMessage = "Error processing user $($user.SamAccountName): $_"
        $errorMessage | Out-File -FilePath $errorLog -Append
    }
}

# Sort the user data by ExpirationDate and then UserName
$sortedUserData = $userData | Sort-Object ExpirationDate, UserName

# Generate the email body and write the sorted data to the output file
$body = "If there is a username on this list that is a member of your team, please let them know that they need to connect to the VPN and reset their password as soon as possible. Please feel free to ignore usernames that you do not recognize as one of your own team members. `n`n Passwords expiring this week:`n`n"
foreach ($data in $sortedUserData) {
    $outputLine = "$($data.UserName): $($data.ExpirationDate.ToString('MM/dd/yyyy'))"
    $body += "$outputLine`n"
    $outputLine | Out-File -FilePath $outputFile -Append
}

# Create the credentials
$credentials = New-Object System.Management.Automation.PSCredential ($smtpUser, ($smtpPassword | ConvertTo-SecureString -AsPlainText -Force))

# Send the email
Send-MailMessage -To $to -From $smtpUser -Subject $subject -Body $body -SmtpServer $smtpServer -Port $smtpPort -Credential $credentials -UseSsl
