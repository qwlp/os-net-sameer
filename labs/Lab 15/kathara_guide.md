# CTEC1704 Lab 15: IPv4 Static Routing with Kathara

This guide explains the Kathara version of Lab 15. The lab is organised as a
single Kathara topology, but the work is still described in two sections:

- Part A builds and tests networks W and X, which both connect to the shared D
  network.
- Part B adds networks Y and Z, adds DNS on D, and tests routing across the
  whole topology.

Use `kathara_lab_15/` for both parts. The Part A and Part B labels in this
guide are teaching sections, not separate folders.

## Files

| Path | Purpose |
| --- | --- |
| `kathara_lab_15/` | The working Kathara lab directory. Start the lab from here. |
| `kathara_lab_15/lab.conf` | Defines which machines are connected to each collision domain. |
| `kathara_lab_15/*.startup` | Per-machine startup scripts that assign addresses, enable interfaces, and add routes. |
| `kathara_lab_15/shared/etc/resolv.conf` | Shared resolver configuration pointing machines at `dns1`. |
| `kathara_lab_15/dns1/etc/bind/` | BIND DNS zone files used by `dns1`. |
| `kathara_lab_15_bundle.tar.xz` | Archive of the Kathara lab. |
| `Lab_15_kathara.zip` | Zip archive of the Kathara lab files. |
| `ctec1704_networks_lab-worksheet-15_static-routing.pdf` | Lab worksheet. |

## Starting and Stopping

Run all commands in this section from the host terminal.

Start the lab:

```sh
cd kathara_lab_15
kathara lstart
```

Open a shell on a machine:

```sh
kathara connect m1
```

Open more terminals when you need to work on several machines at the same
time. For example, keep one terminal connected to `m1`, another connected to
`gw`, and another connected to `dns1`.

Stop and clean the lab:

```sh
kathara lclean
```

If a test gives an unexpected result, first check that the lab is running and
that you are connected to the right machine:

```sh
hostname
ip addr
ip route
```

## Topology Overview

The topology contains five networks:

| Network | Prefix | Role |
| --- | --- | --- |
| W | `172.28.97.40/29` | Part A client LAN for `m1`, `m2`, and `gww`. |
| X | `172.21.62.96/27` | Part A client LAN for `m6`, `m7`, and `gwx`. |
| D | `10.227.0.0/16` | Shared backbone network that connects `gww`, `gwx`, `gwz`, `gw`, and `dns1`. |
| Y | `172.19.78.0/23` | Part B client LAN for `m12`, `m13`, and `gwy`. |
| Z | `172.17.32.0/20` | Part B client LAN for `m16`, `m17`, `gwy`, and `gwz`. |

The D network acts as the central transit network. Part A routers `gww` and
`gwx` connect W and X to D. Part B router `gwz` connects D to Z, and `gwy`
connects Y to Z.

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
           172.21.62.96/27                  | .150.254 +----+
   --+------------+-------------+--         +----------| gw |
     |            |             |           |          +----+
     |.106        |.107         |.126       |
  +-----+      +-----+       +-----+        |
  | m6  |      | m7  |       | gwx |.150.56 |
  +-----+      +-----+       |     |--------+
                             +-----+        |
                  Y                         | .150.220 +------+
          172.19.78.0/23                    +----------| dns1 |
   --+------------+-------------+--         |          +------+
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

## Addressing Reference

| Machine | Interface | Address | Connected network | Default route |
| --- | --- | --- | --- | --- |
| `m1` | `eth0` | `172.28.97.41/29` | W | `172.28.97.46` |
| `m2` | `eth0` | `172.28.97.42/29` | W | `172.28.97.46` |
| `gww` | `eth0` | `172.28.97.46/29` | W | |
| `gww` | `eth1` | `10.227.150.55/16` | D | `10.227.150.254` |
| `m6` | `eth0` | `172.21.62.106/27` | X | `172.21.62.126` |
| `m7` | `eth0` | `172.21.62.107/27` | X | `172.21.62.126` |
| `gwx` | `eth0` | `172.21.62.126/27` | X | |
| `gwx` | `eth1` | `10.227.150.56/16` | D | `10.227.150.254` |
| `m12` | `eth0` | `172.19.78.112/23` | Y | `172.19.79.254` |
| `m13` | `eth0` | `172.19.79.213/23` | Y | `172.19.79.254` |
| `gwy` | `eth0` | `172.19.79.254/23` | Y | |
| `gwy` | `eth1` | `172.17.47.253/20` | Z | `172.17.47.254` |
| `m16` | `eth0` | `172.17.33.116/20` | Z | `172.17.47.254` |
| `m17` | `eth0` | `172.17.44.217/20` | Z | `172.17.47.254` |
| `gwz` | `eth0` | `10.227.150.58/16` | D | |
| `gwz` | `eth1` | `172.17.47.254/20` | Z | `10.227.150.254` |
| `gw` | `eth0` | `10.227.150.254/16` | D | |
| `dns1` | `eth0` | `10.227.150.220/16` | D | `10.227.150.254` |

## What the Startup Files Do

Each `.startup` file is run when Kathara starts the matching machine.

Host startup files, such as `m1.startup`, do three things:

```sh
ip addr add 172.28.97.41/29 dev eth0
ip link set eth0 up
ip route add default via 172.28.97.46
```

This gives the host an IP address, enables its interface, and sends traffic for
other networks to its local gateway.

Router startup files, such as `gww.startup`, also enable IPv4 forwarding:

```sh
sysctl -w net.ipv4.ip_forward=1
```

Forwarding is required because routers must accept packets on one interface and
send them out through another interface. Without forwarding, a router can talk
for itself but will not route traffic for other machines.

Router startup files also add static routes. A static route says, "to reach
this destination prefix, send packets to this next-hop address." For example,
`gww` reaches network X through `gwx` on the D network:

```sh
ip route add 172.21.62.96/27 via 10.227.150.56
```

## Part A: Networks W and X

Part A focuses on these machines:

| Machine | Role |
| --- | --- |
| `m1`, `m2` | Hosts on network W. |
| `gww` | Gateway between W and D. |
| `m6`, `m7` | Hosts on network X. |
| `gwx` | Gateway between X and D. |
| `gw` | Router on D used as the default path from the D network. |

### Part A Addressing

Network W is `172.28.97.40/29`. A `/29` network has eight addresses. In this
case, `172.28.97.40` is the network address and `172.28.97.47` is the broadcast
address, so usable host addresses are `172.28.97.41` to `172.28.97.46`.

| Machine | Address |
| --- | --- |
| `m1` | `172.28.97.41/29` |
| `m2` | `172.28.97.42/29` |
| `gww` W-side interface | `172.28.97.46/29` |

Network X is `172.21.62.96/27`. A `/27` network has 32 addresses. In this
case, `172.21.62.96` is the network address and `172.21.62.127` is the
broadcast address, so usable host addresses are `172.21.62.97` to
`172.21.62.126`.

| Machine | Address |
| --- | --- |
| `m6` | `172.21.62.106/27` |
| `m7` | `172.21.62.107/27` |
| `gwx` X-side interface | `172.21.62.126/27` |

Both Part A gateways also connect to D:

| Router | D address |
| --- | --- |
| `gww` | `10.227.150.55/16` |
| `gwx` | `10.227.150.56/16` |
| `gw` | `10.227.150.254/16` |

### Part A Routing

`m1` and `m2` use `gww` as their default gateway because `gww` is the router on
network W:

```sh
ip route add default via 172.28.97.46
```

`m6` and `m7` use `gwx` as their default gateway because `gwx` is the router on
network X:

```sh
ip route add default via 172.21.62.126
```

The routers need routes for remote networks. For example:

| Router | Destination | Next hop | Reason |
| --- | --- | --- | --- |
| `gww` | `172.21.62.96/27` | `10.227.150.56` | Send traffic for X to `gwx`. |
| `gwx` | `172.28.97.40/29` | `10.227.150.55` | Send traffic for W to `gww`. |
| `gw` | `172.28.97.40/29` | `10.227.150.55` | Return traffic for W through `gww`. |
| `gw` | `172.21.62.96/27` | `10.227.150.56` | Return traffic for X through `gwx`. |

### Part A Tests

Connect to `m1`:

```sh
kathara connect m1
```

Test the local W network:

```sh
ping -c 2 172.28.97.42
ping -c 2 172.28.97.46
```

The first command tests host-to-host communication on W. The second command
tests that `m1` can reach its gateway.

Test the D-side address of `gww`:

```sh
ping -c 2 10.227.150.55
```

This proves that `m1` can send packets through `gww` to the router interface on
D.

Test network X from `m1`:

```sh
ping -c 2 172.21.62.126
ping -c 2 172.21.62.106
ping -c 2 172.21.62.107
```

These commands prove that traffic can leave W through `gww`, cross D, enter X
through `gwx`, and return by the reverse path.

Trace the route from W to X:

```sh
traceroute -n 172.21.62.106
```

Expected path:

```text
m1 -> gww -> gwx -> m6
```

## Part B: Networks Y, Z, and DNS

Part B focuses on these additional machines:

| Machine | Role |
| --- | --- |
| `m12`, `m13` | Hosts on network Y. |
| `gwy` | Gateway between Y and Z. |
| `m16`, `m17` | Hosts on network Z. |
| `gwz` | Gateway between Z and D. |
| `dns1` | DNS server on D. |

Part B depends on the Part A routing because W and X traffic reaches Y and Z
through the D network.

### Part B Addressing

Network Y is `172.19.78.0/23`. A `/23` network spans two adjacent third-octet
values, so this network covers `172.19.78.0` through `172.19.79.255`.

| Machine | Address |
| --- | --- |
| `m12` | `172.19.78.112/23` |
| `m13` | `172.19.79.213/23` |
| `gwy` Y-side interface | `172.19.79.254/23` |

Network Z is `172.17.32.0/20`. A `/20` network spans `172.17.32.0` through
`172.17.47.255`.

| Machine | Address |
| --- | --- |
| `m16` | `172.17.33.116/20` |
| `m17` | `172.17.44.217/20` |
| `gwy` Z-side interface | `172.17.47.253/20` |
| `gwz` Z-side interface | `172.17.47.254/20` |

`gwz` also connects to D:

| Router | D address |
| --- | --- |
| `gwz` | `10.227.150.58/16` |
| `dns1` | `10.227.150.220/16` |

### Part B Routing

`m12` and `m13` use `gwy` as their default gateway:

```sh
ip route add default via 172.19.79.254
```

`m16` and `m17` use `gwz` as their default gateway:

```sh
ip route add default via 172.17.47.254
```

`gwy` sends all non-local traffic to `gwz` through network Z:

```sh
ip route add default via 172.17.47.254
```

`gwz` knows that Y is behind `gwy`:

```sh
ip route add 172.19.78.0/23 via 172.17.47.253
```

`gwz` also knows how to reach W and X through the D network:

```sh
ip route add 172.28.97.40/29 via 10.227.150.55
ip route add 172.21.62.96/27 via 10.227.150.56
```

The central `gw` router sends Y and Z traffic to `gwz`:

```sh
ip route add 172.19.78.0/23 via 10.227.150.58
ip route add 172.17.32.0/20 via 10.227.150.58
```

### Part B Tests

Connect to `m12` and test the local Y network:

```sh
kathara connect m12
ping -c 2 172.19.79.213
ping -c 2 172.19.79.254
```

The first command tests host-to-host communication on Y. The second tests that
`m12` can reach its gateway.

Test Z from Y:

```sh
ping -c 2 172.17.47.253
ping -c 2 172.17.47.254
ping -c 2 172.17.33.116
ping -c 2 172.17.44.217
```

This confirms that `gwy` and `gwz` can forward between Y and Z.

Test D from Y:

```sh
ping -c 2 10.227.150.58
ping -c 2 10.227.150.254
ping -c 2 10.227.150.220
```

This confirms that Y can reach `gwz` on D, the central `gw` router, and the DNS
server.

Test from Part A to Part B:

```sh
kathara connect m1
ping -c 2 172.19.78.112
ping -c 2 172.17.44.217
traceroute -n 172.19.78.112
traceroute -n 172.17.44.217
```

Expected route from `m1` to `m12`:

```text
m1 -> gww -> gwz -> gwy -> m12
```

Expected route from `m1` to `m17`:

```text
m1 -> gww -> gwz -> m17
```

## DNS

`dns1` is connected to D at `10.227.150.220/16`. Its startup file assigns the
address, adds a default route through `gw`, and starts BIND:

```sh
ip addr add 10.227.150.220/16 dev eth0
ip link set up dev eth0
ip route add default via 10.227.150.254
service bind9 start || named -c /etc/bind/named.conf
```

The shared resolver file contains:

```text
nameserver 10.227.150.220
```

That tells lab machines to send DNS queries to `dns1`.

Test DNS from any host after the lab starts:

```sh
host m1.csc.dmu.test 10.227.150.220
host m17.csc.dmu.test 10.227.150.220
host gw.csc.dmu.test 10.227.150.220
```

If `host` is not installed in the selected image, use `dig`:

```sh
dig @10.227.150.220 m1.csc.dmu.test
```

DNS only proves name resolution. Routing still has to work for traffic to reach
the resolved IP address.

## Packet Capture

Packet captures are useful when you need to prove which path traffic follows.
Create a capture directory on the host:

```sh
mkdir -p ~/ctec1704/captures
```

Inside a Kathara machine, the host home directory is normally mounted at
`/hosthome`.

Capture on `m2`:

```sh
kathara connect m2
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m2.pcap
```

Capture on `m7`:

```sh
kathara connect m7
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-m7.pcap
```

Capture on `gw`:

```sh
kathara connect gw
tcpdump -s0 -i eth0 -w /hosthome/ctec1704/captures/lab15-gw.pcap
```

Start the capture first, generate traffic from another terminal, then stop the
capture with `Ctrl-C`.

## Troubleshooting

Check interface addresses:

```sh
ip addr
```

Check the routing table:

```sh
ip route
```

Check whether a router is forwarding packets:

```sh
sysctl net.ipv4.ip_forward
```

The value should be `1` on `gww`, `gwx`, `gwy`, `gwz`, and `gw`.

Check direct neighbour discovery:

```sh
ip neigh
```

If a host can ping its gateway but cannot reach another network, the most likely
problem is a missing route on one of the routers or a missing return route.

If a host cannot ping its own gateway, check the host address, subnet prefix,
gateway address, and `lab.conf` collision domain for that machine.

If DNS queries fail but IP pings work, check that `dns1` is running BIND and
that `/etc/resolv.conf` points to `10.227.150.220`.
