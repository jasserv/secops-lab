# Firewall rules

## OPNsense

### LAN (attacker zone)

| # | Action | Family | Source | Destination | Description |
|---|--------|--------|--------|-------------|-------------|
| 1 | Pass | IPv4 | LAN net | any | Default allow LAN to any |
| 2 | Pass | IPv6 | LAN net | any | Default allow LAN IPv6 to any |

### OPT1 (DMZ / transit)

| # | Action | Direction | Family | Source | Destination | Gateway |
|---|--------|-----------|--------|--------|-------------|---------|
| 1 | Pass (quick) | in | IPv4 | any | any | none |
| 2 | Pass (quick) | in | IPv6 | any | any | none |
| 3 | Pass (quick) | out | IPv4 | 10.50.10.0/24 | any | Internal |
| 4 | Pass (quick) | in | IPv4 | 10.50.10.0/24 | any | Internal |

### Outbound NAT (Firewall > NAT)

| Setting | Value |
|---------|-------|
| Interface | WAN |
| Source | 10.50.10.0/24 |
| Destination | any |
| Translation target | WAN address |
| Protocol family | IPv4 |

Automatic outbound NAT already covers the LAN (172.16.1.0/24) and OPT1 (10.0.0.0/24) networks. This manual rule covers the corporate network behind the FortiGate, which the automatic rules do not know about.

## FortiGate

| ID | Name | From | To | Source | Destination | Service | Action | NAT |
|----|------|------|----|--------|-------------|---------|--------|-----|
| 1 | port1-to-port2 | port1 | port2 | all | all | ALL | Accept | Off |
| 2 | port2-to-port1 | port2 | port1 | all | all | ALL | Accept | Off |

NAT is off on the FortiGate because OPNsense performs the translation at the edge.
