# Architecture

## Design goals

- Put two different firewalls in series so traffic is inspected and filtered at two points.
- Separate the attacker, transit and corporate zones so lateral movement has to cross a firewall.
- Collect logs from every system in one SIEM and test detections with real attack behaviour.

## Traffic paths

| Path | Why it works |
|------|--------------|
| Corporate host to internet | Host goes to FortiGate (10.50.10.1), whose default route points at 10.0.0.1. OPNsense NATs 10.50.10.0/24 out the WAN. |
| Internet or Kali to corporate | OPNsense has a static route for 10.50.10.0/24 via 10.0.0.2, then FortiGate policy 1 allows it through. |
| Return traffic | FortiGate has a connected route on `port2`. |

## Layers

1. **Perimeter (OPNsense):** WAN, NAT, the attacker zone (LAN) and the transit zone (OPT1). Suricata inspects traffic here.
2. **Internal (FortiGate):** sits between the transit zone and the corporate network and enforces policy for the corporate hosts.
3. **Monitoring (Ubuntu-SIEM):** the Wazuh server, reachable from every zone through the transit network.
4. **Endpoints:** Ubuntu-FG and Windows-Host run Wazuh agents. Windows-Host also runs Sysmon.

## Proxmox bridges

FortiGate `port1` attaches to bridge `vmbr2` and `port2` to `vmbr3`.
