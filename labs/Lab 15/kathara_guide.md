# CTEC1704 Lab 15: IPv4 Static Routing for Kathara

This is the Kathara version of the original Netkit Lab 15 files.  The lab
keeps the same addressing, topology, routing exercise, and part A/part B
layout, but uses Kathara-compatible machine names and startup commands.

Kathara machine names are lowercase in this conversion.  The original Netkit
routers `gwW`, `gwX`, `gwY`, and `gwZ` are named `gww`, `gwx`, `gwy`, and
`gwz` here.

## Files

- `kathara_lab_15/`: combined Kathara lab for the full topology.
- `kathara_lab_15_a/`: Kathara-compatible copy of part A.
- `kathara_lab_15_b/`: Kathara-compatible copy of part B.
- `netkit_lab_15.tar.xz`: original Netkit lab archive.
- `kathara_lab_15_bundle.tar.xz`: Kathara lab archive.

Use `kathara_lab_15/` for the main exercise.  Kathara scopes collision domains
to one lab directory, so the combined lab is the reliable way to make networks
W, X, Y, Z, and D share one topology.

The split `kathara_lab_15_a/` and `kathara_lab_15_b/` directories are kept so
the Kathara version still resembles the original Netkit distribution.

## Original Lab Split

Part A contains networks W and X, plus the D network gateway:

- W: `172.28.97.40/29`
- X: `172.21.62.96/27`
- D: `10.227.0.0/16`

Part B adds networks Y and Z, plus DNS on D:

- Y: `172.19.78.0/23`
- Z: `172.17.32.0/20`
- D: `10.227.0.0/16`

The original Netkit part B referenced `dns2`, but no `dns2` files were
provided.  The Kathara conversion includes `dns1` only.

## Topology

```text
                  W
           172.28.97.40/29
   --+------------+-------------+--              D
     |            |             |           10.227.0.0/16
     |.41         |.42          |.46        +-----------------
  +-----+      +-----+       +-----+        |
  | m1  |      | m2  |       | gww |.150.55 |
  +-----+      +-----+       |     |--------+
                             +-----+        |
                  X                         |
           172.21.62.96/27                  | .150.254 +----
   --+------------+-------------+--         +----------| gw
     |            |             |           |          +----
     |.106        |.107         |.126       |
  +-----+      +-----+       +-----+        |
  | m6  |      | m7  |       | gwx |.150.56 |
  +-----+      +-----+       |     |--------+
                             +-----+        |
                  Y                         | .150.220 +-----+
          172.19.78.0/23                    +----------|dns1 |
   --+------------+-------------+--         |          +-----+
     |            |             |           |
     |78.112      |79.213       |79.254     |
  +-----+      +-----+       +-----+        |
  | m12 |      | m13 |       | gwy |        |
  +-----+      +-----+       |     |        |
                             +--+--+        |
                  Z             |.47.253    |
           172.17.32.0/20       |           |
   --+------------+-------------+--         |
     |            |             |           |
     |33.116      |44.217       |.47.254    |
  +-----+      +-----+       +-----+        |
  | m16 |      | m17 |       | gwz |.150.58 |
  +-----+      +-----+       |     |--------+
                             +-----+        |
```

## Addressing

| Machine | Interface | Address             | Default route     |
| ------- | --------- | ------------------- | ----------------- |
| `m1`    | `eth0`    | `172.28.97.41/29`   | `172.28.97.46`    |
| `m2`    | `eth0`    | `172.28.97.42/29`   | `172.28.97.46`    |
| `gww`   | `eth0`    | `172.28.97.46/29`   |                   |
| `gww`   | `eth1`    | `10.227.150.55/16`  | `10.227.150.254`  |
| `m6`    | `eth0`    | `172.21.62.106/27`  | `172.21.62.126`   |
| `m7`    | `eth0`    | `172.21.62.107/27`  | `172.21.62.126`   |
| `gwx`   | `eth0`    | `172.21.62.126/27`  |                   |
| `gwx`   | `eth1`    | `10.227.150.56/16`  | `10.227.150.254`  |
| `m12`   | `eth0`    | `172.19.78.112/23`  | `172.19.79.254`   |
| `m13`   | `eth0`    | `172.19.79.213/23`  | `172.19.79.254`   |
| `gwy`   | `eth0`    | `172.19.79.254/23`  |                   |
| `gwy`   | `eth1`    | `172.17.47.253/20`  | `172.17.47.254`   |
| `m16`   | `eth0`    | `172.17.33.116/20`  | `172.17.47.254`   |
| `m17`   | `eth0`    | `172.17.44.217/20`  | `172.17.47.254`   |
| `gwz`   | `eth0`    | `10.227.150.58/16`  |                   |
| `gwz`   | `eth1`    | `172.17.47.254/20`  | `10.227.150.254`  |
| `gw`    | `eth0`    | `10.227.150.254/16` |                   |
| `dns1`  | `eth0`    | `10.227.150.220/16` | `10.227.150.254`  |

## Starting the Lab

Start the combined lab from this directory:

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

If you want to run only one original section, start the matching split lab:

```sh
cd kathara_lab_15_a
kathara lstart
```

or:

```sh
cd kathara_lab_15_b
kathara lstart
```

Use the combined lab when you need traffic to pass between all five networks.

## Kathara Differences

The Netkit lab used uppercase gateway names such as `gwW`.  Kathara machine
names are handled more consistently when lowercase, so this conversion uses
`gww`, `gwx`, `gwy`, and `gwz`.

Netkit examples often use `vstart`, `vclean`, or host-specific startup
scripts.  In this version, start and stop the lab with Kathara:

```sh
kathara lstart
kathara lclean
```

Use `kathara connect <machine>` instead of opening a Netkit console:

```sh
kathara connect gwx
```

The startup files use Linux `ip` commands and enable forwarding on router
machines with:

```sh
sysctl -w net.ipv4.ip_forward=1
```

## Routing Checks

Run these commands from `m1` after the combined lab has started:

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

Useful inspection commands inside any Kathara machine are:

```sh
ip addr
ip route
ip neigh
```

On a router, confirm that IPv4 forwarding is enabled:

```sh
sysctl net.ipv4.ip_forward
```

## Packet Capture

Create a capture directory on the host before starting captures:

```sh
mkdir -p ~/ctec1704/captures
```

Inside a Kathara machine, the host home directory is normally mounted at
`/hosthome`.  For example, on `m2`:

```sh
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m2.pcap
```

Suggested capture points for the original worksheet are:

```sh
# on m2
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m2.pcap

# on m7
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m7.pcap

# on gw, interface on D
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-gw.pcap
```

Generate traffic from another shell, then stop each capture with `Ctrl-C`.

## DNS

The original archive included BIND files under `dns1/etc/bind`.  The Kathara
startup for `dns1` starts BIND if it is available in the selected image.

The shared resolver file points machines at the provided DNS server:

```text
nameserver 10.227.150.220
```

If the selected Kathara image does not include BIND, IP routing still works.
Only name lookups, such as `m1.csc.dmu.test`, will fail until BIND is
installed or the image is changed.
