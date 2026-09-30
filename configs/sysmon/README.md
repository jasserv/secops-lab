# Sysmon

Windows-Host runs Sysmon with the [SwiftOnSecurity sysmon-config](https://github.com/SwiftOnSecurity/sysmon-config) unmodified (source version 74, 2021-07-08; fork fields are N/A in the lab notes).

The config is not vendored here. `install-sysmon.ps1` downloads it fresh and installs Sysmon. If you later fork it, save your version in this folder with the original header intact: the licence is CC BY 4.0 and requires attribution.

Requires Sysmon 13 or higher.
