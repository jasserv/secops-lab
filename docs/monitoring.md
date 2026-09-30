# Monitoring stack

## Wazuh (SIEM)

The Wazuh server runs on Ubuntu-SIEM (10.0.0.10). Agents report to it from the other systems.

| Device | Wazuh version |
|--------|---------------|
| Ubuntu-SIEM | 4.14.6 |
| OPNsense | 4.14.5 (`wazuh-agent` package 1.3_1) |
| Windows-Host | 4.14.6 |
| Ubuntu-FG | 4.14.6 |

## Suricata (IDS)

Suricata 8.0.6 runs on OPNsense. It watches traffic and alerts on known attack patterns. It detects but does not block.

## Sysmon (Windows endpoint telemetry)

Windows-Host runs Sysmon with the [SwiftOnSecurity configuration](https://github.com/SwiftOnSecurity/sysmon-config) (source version 74, 2021-07-08, no local fork changes). It logs process creation, network connections and file changes that default Windows logs miss. The Wazuh agent forwards these events to the SIEM.

- Requires Sysmon version 13 or higher.
- The config is not copied into this repo. Download it from the upstream project and keep it in `configs/sysmon/` if you fork it, keeping the attribution header (CC BY 4.0).
- The upstream notes warn that DNS logging is very noisy. Remove that section if you are starting out.
- To let the Network Service read the Sysmon log (needed for some collectors):

```
wevtutil.exe sl Microsoft-Windows-Sysmon/Operational /ca:O:BAG:SYD:(A;;0xf0005;;;SY)(A;;0x5;;;BA)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;NS)
```
