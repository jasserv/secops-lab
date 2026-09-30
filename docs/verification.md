# Verification

Checks that prove the paths described in [architecture](architecture.md) work.

| Check | Run from | Command | Expect |
|-------|----------|---------|--------|
| Corporate host reaches its gateway | Windows-Host | `ping 10.50.10.1` | Replies |
| Corporate host reaches internet | Ubuntu-FG | `curl -I https://example.com` | HTTP response (NAT via OPNsense) |
| Attacker reaches corporate | Kali-Attacker | `ping 10.50.10.100` | Replies (static route + FortiGate policy 1) |
| Path crosses both firewalls | Kali-Attacker | `traceroute 10.50.10.100` | Hops via 172.16.1.1, 10.0.0.2 |
| Agents are connected | Wazuh dashboard | Agents page | OPNsense, Windows-Host, Ubuntu-FG active |
| IDS is alerting | Kali-Attacker | `nmap -sS 10.50.10.100` | Suricata alerts visible in Wazuh |
| Endpoint telemetry flows | Windows-Host | Run any atomic test | Sysmon events appear in Wazuh |
