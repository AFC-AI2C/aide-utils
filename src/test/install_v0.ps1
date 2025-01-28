# Install AIDE-Test configuration.
 
# Download the root CA certificate.
Write-Output "[+] Downloading root CA certificate..."
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/angusmf1/aide-utils/refs/heads/main/files/test/MyCustomCA.crt" -OutFile "$env:USERPROFILE\Downloads\MyCustomCA.crt"
 
# Install the root CA certificate.
Write-Output "[+] Preparing root CA..."
Import-Certificate -FilePath "$env:USERPROFILE\Downloads\MyCustomCA.crt" -CertStoreLocation "Cert:\CurrentUser\Root\"

# Define paths
$HostsFilePath = "C:\Windows\System32\drivers\etc\hosts"
$BackupHostsFilePath = "C:\Windows\System32\drivers\etc\hosts.bak"
$HostsTxtUrl = "https://raw.githubusercontent.com/angusmf1/aide-utils/refs/heads/main/files/test/hosts.txt"

# Back up the original hosts file
Copy-Item -Path $HostsFilePath -Destination $BackupHostsFilePath -Force

# Download the hosts.txt content
$HostsContent = Invoke-WebRequest -Uri $HostsTxtUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# Remove any CRLF characters (if necessary)
$CleanHostsContent = $HostsContent -replace "`r", ""

# Append the downloaded content to the hosts file
Add-Content -Path $HostsFilePath -Value $CleanHostsContent

# Add a blank line at the end of the hosts file
Add-Content -Path $HostsFilePath -Value ""

Write-Host "Hosts file updated successfully. Backup saved at: $BackupHostsFilePath"
