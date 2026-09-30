# Security notes

This is a lab built to be attacked, so several settings are deliberately open. They would need tightening outside a lab.

- OPNsense LAN (attacker zone) allows all traffic to any destination.
- OPNsense OPT1 has any-to-any pass rules.
- Both FortiGate policies allow all sources, destinations and services, with no UTM profiles.
- FortiGate management (https, ssh) is open on both ports.
- Suricata runs in detection mode only.

Ideas for hardening as the lab matures: restrict the attacker zone to specific corporate targets, limit management access to the SIEM or an admin host, add FortiGate service-specific policies and enable Suricata blocking on selected rules.
