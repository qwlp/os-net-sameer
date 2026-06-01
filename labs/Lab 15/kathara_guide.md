# CTEC1704 Lab 15 Kathara Guide

This directory contains the original Netkit archive plus Kathara-compatible lab copies.

## Directory Layout

- `netkit_lab_15.tar.xz` - original archive.
- `netkit_lab_15_a/` and `netkit_lab_15_b/` - extracted original Netkit labs.
- `kathara_lab_15/` - combined Kathara lab for the full topology.
- `kathara_lab_15_a/` - Kathara-compatible copy of part A.
- `kathara_lab_15_b/` - Kathara-compatible copy of part B.

Use `kathara_lab_15/` for the complete exercise. Kathara scopes collision domains to a lab, so the combined lab is the reliable way to make W, X, Y, Z, and D share one topology.

Kathara VM names are lowercase in this conversion: Netkit `gwW`, `gwX`, `gwY`, and `gwZ` are `gww`, `gwx`, `gwy`, and `gwz`.

## Topology

| LAN | Network | Machines |
| --- | --- | --- |
| W | `172.28.97.40/29` | `m1`, `m2`, `gww` |
| X | `172.21.62.96/27` | `m6`, `m7`, `gwx` |
| Y | `172.19.78.0/23` | `m12`, `m13`, `gwy` |
| Z | `172.17.32.0/20` | `m16`, `m17`, `gwy`, `gwz` |
| D | `10.227.0.0/16` | `gw`, `gww`, `gwx`, `gwz`, `dns1` |

## Addressing

| Machine | Interface | Address | Default route |
| --- | --- | --- | --- |
| `m1` | `eth0` | `172.28.97.41/29` | `172.28.97.46` |
| `m2` | `eth0` | `172.28.97.42/29` | `172.28.97.46` |
| `gww` | `eth0` | `172.28.97.46/29` | |
| `gww` | `eth1` | `10.227.150.55/16` | `10.227.150.254` |
| `m6` | `eth0` | `172.21.62.106/27` | `172.21.62.126` |
| `m7` | `eth0` | `172.21.62.107/27` | `172.21.62.126` |
| `gwx` | `eth0` | `172.21.62.126/27` | |
| `gwx` | `eth1` | `10.227.150.56/16` | `10.227.150.254` |
| `m12` | `eth0` | `172.19.78.112/23` | `172.19.79.254` |
| `m13` | `eth0` | `172.19.79.213/23` | `172.19.79.254` |
| `gwy` | `eth0` | `172.19.79.254/23` | |
| `gwy` | `eth1` | `172.17.47.253/20` | `172.17.47.254` |
| `m16` | `eth0` | `172.17.33.116/20` | `172.17.47.254` |
| `m17` | `eth0` | `172.17.44.217/20` | `172.17.47.254` |
| `gwz` | `eth0` | `10.227.150.58/16` | `10.227.150.254` |
| `gwz` | `eth1` | `172.17.47.254/20` | |
| `gw` | `eth0` | `10.227.150.254/16` | |
| `dns1` | `eth0` | `10.227.150.220/16` | `10.227.150.254` |

## Start the Lab

From this directory:

```sh
cd kathara_lab_15
kathara lstart
```

Open a shell on a machine:

```sh
kathara connect m1
```

Stop and clean the lab:

```sh
kathara lclean
```

## Verification Commands

Run these from `m1`:

```sh
ping -c 2 172.28.97.46
ping -c 2 10.227.150.55
ping -c 2 10.227.150.56
ping -c 2 172.21.62.126
ping -c 2 172.21.62.106
ping -c 2 172.19.78.112
ping -c 2 172.17.44.217
ping -c 2 10.227.150.220
traceroute -n 172.19.78.112
```

Useful inspection commands inside any container:

```sh
ip addr
ip route
ip neigh
```

On a router, confirm forwarding is enabled:

```sh
sysctl net.ipv4.ip_forward
```

## Packet Capture

Create a capture directory on the host before starting captures:

```sh
mkdir -p ~/ctec1704/captures
```

Inside a Kathara machine, host home is normally available at `/hosthome`. Example from `m2`:

```sh
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m2.pcap
```

Suggested capture points for the original worksheet:

```sh
# on m2
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m2.pcap

# on m7
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m7.pcap

# on gw, interface on D
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-gw.pcap
```

Then generate traffic from `m1` and stop each capture with `Ctrl-C`.

## DNS

The original archive includes BIND zone files under `dns1/etc/bind`. The Kathara startup for `dns1` starts BIND if it is available in the image. The resolver file now uses the provided server:

```text
nameserver 10.227.150.220
```

If the selected Kathara image does not include BIND, IP routing still works; only name lookups such as `m1.csc.dmu.test` will fail until BIND is installed or the image is changed.

## Changes Made from the Netkit Lab

- Extracted `netkit_lab_15.tar.xz`.
- Added `kathara_lab_15/` as one complete lab containing both original parts.
- Added Kathara-compatible part copies: `kathara_lab_15_a/` and `kathara_lab_15_b/`.
- Renamed gateway VM identifiers to lowercase for Kathara parser compatibility.
- Replaced part A `ifup` startup dependency with direct `ip` commands.
- Enabled IPv4 forwarding on all router machines.
- Removed the undefined `dns2` VM from Kathara lab configs.
- Fixed the part B `m12` default route to use `172.19.79.254`.
- Updated resolver config to use the provided `dns1` address first.
