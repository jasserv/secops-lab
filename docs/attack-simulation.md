# Attack simulation

## Tools

- **Kali Linux (172.16.1.50):** attacker machine in the attacker zone, used to attack the lab from outside the corporate network.
- **Atomic Red Team:** small, safe tests mapped to MITRE ATT&CK techniques, run on Windows-Host to imitate attacker behaviour. After each test, check whether Sysmon and Wazuh detected it.

## Detection results

Record one row per technique tested.

| ATT&CK ID | Technique | Atomic test | Sysmon event | Wazuh alert | Suricata alert | Detected? | Notes |
|-----------|-----------|-------------|--------------|-------------|----------------|-----------|-------|
|           |           |             |              |             |                |           |       |

## Method

1. Run one atomic test on Windows-Host.
2. Note the time.
3. Look for the matching Sysmon event in Event Viewer, then the alert in the Wazuh dashboard.
4. Record the result above. If nothing fired, note the gap and the tuning you applied.
