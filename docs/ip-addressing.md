# IP addressing

## OPNsense interfaces

| Name | Interface | Addressing | Description |
|------|-----------|------------|-------------|
| WAN | vtnet0 | DHCP (IPv4) | Public internet |
| LAN | vtnet1 | 172.16.1.1/24 | Attacker zone |
| OPT1 | vtnet2 | 10.0.0.1/24 | Internal zone (DMZ / transit) |
| lo0 | lo0 | 127.0.0.1/8, ::1/128 | Loopback |

## FortiGate interfaces

| Port | IP | Allowed access | Connects to | Role |
|------|----|----------------|-------------|------|
| port1 | 10.0.0.2/24 | ping, https, ssh | OPNsense OPT1 (vmbr2) | Transit / DMZ side (upstream) |
| port2 | 10.50.10.1/24 | ping, https, ssh | Corporate (vmbr3) | Gateway for 10.50.10.0/24 |

## Hosts

| Host | IP | Zone |
|------|----|------|
| Home router | 192.168.1.1 | Upstream of WAN |
| Ubuntu-SIEM | 10.0.0.10 | Internal / transit |
| Ubuntu-FG | 10.50.10.10 | Corporate |
| Windows-Host | 10.50.10.100 | Corporate |
| Kali-Attacker | 172.16.1.50 | Attacker |

## Routing

### OPNsense

| Destination | Next hop | Description |
|-------------|----------|-------------|
| 0.0.0.0/0 | 192.168.1.1 | Default route to internet |
| 10.50.10.0/24 | 10.0.0.2 | Static route to corporate |
| 172.16.1.0/24 | connected (LAN) | To attacker |
| 10.0.0.0/24 | connected (OPT1) | To internal |

### FortiGate

| Type | Destination | Next hop | Interface |
|------|-------------|----------|-----------|
| Static (default) | 0.0.0.0/0 | 10.0.0.1 | port1 |
| Connected | 10.0.0.0/24 | direct | port1 |
| Connected | 10.50.10.0/24 | direct | port2 |
