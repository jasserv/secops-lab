# SecOPS Lab

A segmented, multi-firewall home lab for practising security monitoring and detection engineering. Traffic crosses two firewalls (OPNsense and FortiGate), an IDS watches the perimeter, and a Wazuh SIEM collects telemetry from every endpoint. A Kali machine attacks the lab and Atomic Red Team simulates attacker behaviour so each detection can be tested.

Everything runs as virtual machines on a single Proxmox host.

## Topology

```mermaid
flowchart TB
    NET(("Internet")) --- HOME["Home router<br/>192.168.1.1"]
    HOME ---|"WAN vtnet0 (DHCP)"| OPN

    subgraph OPN["OPNsense (perimeter firewall) + Suricata IDS + Wazuh agent"]
        direction LR
        L["LAN vtnet1<br/>172.16.1.1/24"]
        O["OPT1 vtnet2<br/>10.0.0.1/24"]
    end

    L --- KALI["Kali-Attacker<br/>172.16.1.50"]
    O --- SIEM["Ubuntu-SIEM (Wazuh)<br/>10.0.0.10"]
    O ---|"vmbr2"| FGP1["FortiGate port1<br/>10.0.0.2/24"]

    subgraph FG["FortiGate (internal firewall)"]
        direction LR
        FGP1 --- FGP2["port2<br/>10.50.10.1/24"]
    end

    FGP2 ---|"vmbr3"| CORP{{"Corporate 10.50.10.0/24"}}
    CORP --- UFG["Ubuntu-FG<br/>10.50.10.10"]
    CORP --- WIN["Windows-Host<br/>10.50.10.100<br/>Sysmon + Atomic Red Team"]
```

## Zones

| Zone | Subnet | Sits behind | Hosts |
|------|--------|-------------|-------|
| Public / WAN | DHCP from home router (192.168.1.1) | OPNsense `vtnet0` | none |
| Attacker | 172.16.1.0/24 | OPNsense LAN `vtnet1` | Kali-Attacker |
| Internal / transit (DMZ) | 10.0.0.0/24 | OPNsense OPT1 `vtnet2` | Ubuntu-SIEM, FortiGate `port1` |
| Corporate | 10.50.10.0/24 | FortiGate `port2` | Ubuntu-FG, Windows-Host |

## Components

| Component | Role | Version |
|-----------|------|---------|
| Proxmox VE | Hypervisor that hosts every VM | n/a |
| OPNsense | Perimeter firewall, NAT, routing | 26.1.11_10 (FreeBSD 14.3) |
| FortiGate-VM | Internal firewall for the corporate zone | v7.6.7 build 3704 |
| Wazuh | SIEM: log collection and alerting | 4.14.6 (OPNsense agent 4.14.5) |
| Suricata | IDS on OPNsense (detects, does not block) | 8.0.6 |
| Sysmon + SwiftOnSecurity config | Windows endpoint telemetry | config v74 |
| Atomic Red Team | ATT&CK-mapped attack simulations | see [attack-simulation](docs/attack-simulation.md) |
| Kali Linux | Attacker machine | n/a |

## Documentation

- [Architecture](docs/architecture.md): how traffic flows between zones
- [IP addressing](docs/ip-addressing.md): interfaces, hosts, routes
- [Firewall rules](docs/firewall-rules.md): OPNsense rules and NAT, FortiGate policies
- [Monitoring stack](docs/monitoring.md): Wazuh, Suricata, Sysmon
- [Attack simulation](docs/attack-simulation.md): Atomic Red Team plan and detection results
- [Verification](docs/verification.md): checks that prove the lab works
- [Security notes](docs/security-notes.md): known limitations of this design

## Repository layout

```
docs/       write-ups and diagrams
configs/    firewall, Wazuh and Sysmon configs (see configs/README.md and SANITIZATION.md)
diagrams/   diagram sources
```

## Credentials

No credentials are stored in this repository. Lab logins live in a private password manager.

## Credits

The Sysmon configuration is the community template by [SwiftOnSecurity](https://github.com/SwiftOnSecurity/sysmon-config), licensed CC BY 4.0.
