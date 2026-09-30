# Run in an elevated PowerShell on Windows-Host.
# Put Sysmon64.exe (from https://learn.microsoft.com/sysinternals/downloads/sysmon) in the current folder first.
$ConfigUrl = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml"
Invoke-WebRequest -Uri $ConfigUrl -OutFile .\sysmonconfig-export.xml

if (Get-Service Sysmon64 -ErrorAction SilentlyContinue) {
    .\Sysmon64.exe -c .\sysmonconfig-export.xml     # update config on an existing install
} else {
    .\Sysmon64.exe -accepteula -i .\sysmonconfig-export.xml
}

# Optional: let the Network Service read the Sysmon log
wevtutil.exe sl Microsoft-Windows-Sysmon/Operational /ca:O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;NS)
