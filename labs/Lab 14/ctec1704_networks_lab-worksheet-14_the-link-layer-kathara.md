# CTEC1704 Lab Worksheet 14: The Link Layer

## Topic

The Link Layer, MAC addresses, switches/bridges, hubs, Ethernet, and the Spanning Tree Protocol.

## Objectives

By the end of this lab you should be able to:

- explain the difference between a hub and a switch at the Link Layer;
- configure and inspect a Linux software switch/bridge in Kathara;
- explain how a switch learns MAC addresses;
- interpret packet captures taken from different bridge ports;
- describe why redundant Layer 2 links can cause loops, and how STP prevents them.

## Expected Outcomes

After the laboratory session, you should be able to:

| Outcome | You should be able to show this by |
|---|---|
| Explain hubs and switches | Describing flooding, forwarding, and MAC learning |
| Configure a software switch | Reading and explaining the `ip link ... type bridge` setup in the startup files |
| Inspect learned MAC addresses | Using `bridge fdb show br sw0` on switch nodes |
| Capture traffic | Using `tcpdump` inside Kathara nodes and opening captures in Wireshark |
| Explain STP | Showing why redundant links can loop and how STP blocks selected paths |

## Workplan

Keep accurate notes of everything you do. Record commands, outputs, observations, and answers to the questions in this worksheet. These notes will be useful for revision and for comparing your results with other students.

This is a detailed lab. Read each instruction carefully. Missing a step can change the observed traffic and MAC-learning behaviour.

## Starting Assumptions

You should already be comfortable with:

- basic Linux commands for inspecting directories and files;
- starting Kathara labs;
- using `ip` commands inside virtual machines;
- using `tcpdump` to save traffic captures;
- opening `.pcap` files in Wireshark on the host system.

## Netkit to Kathara Translation

The original worksheet used Netkit. This version uses Kathara.

| Original Netkit item | Kathara equivalent |
|---|---|
| `netkit_lab_14_a` | `kathara_lab_14_a` |
| `netkit_lab_14_b` | `kathara_lab_14_b` |
| `lstart` | `kathara lstart` |
| `lhalt` / `lclean` | `kathara lclean` |
| `brctl showmacs sw0` | `bridge fdb show br sw0` |
| `brctl stp sw0 off` | `ip link set dev sw0 type bridge stp_state 0` |
| `brctl stp sw0 on` | `ip link set dev sw0 type bridge stp_state 1` |
| `brctl addif sw0 eth4` | `ip link set dev eth4 master sw0` |
| Netkit VM terminal | Kathara container shell |

> Note: `brctl` is a legacy bridge-management tool. The Kathara files in this lab use the modern Linux `ip` and `bridge` commands.

## Lab Files

The lab contains two Kathara topologies:

| Directory | Purpose |
|---|---|
| `kathara_lab_14_a` | One access-layer switch, `a0`, connected to three hosts |
| `kathara_lab_14_b` | Additional switches and hosts used to build a redundant Layer 2 topology |
| `kathara_lab_14_full` | Complete topology for Part B, combining Part A and Part B in one Kathara scenario |

Each lab directory contains:

| File type | Purpose |
|---|---|
| `lab.conf` | Defines Kathara nodes and their Ethernet collision domains |
| `*.startup` | Commands run automatically when each node starts |
| `shared/` | Shared directory for moving files between the host and Kathara nodes |

Useful host commands:

```bash
cd ~/ctec1704/lab_14
tree
```

If your lab files are provided as an archive, extract them first:

```bash
tar -xvf lab_14.tar.xz
```

## Part A: One Switch and Three Hosts

### Topology

Start in the first Kathara lab:

```bash
cd ~/ctec1704/lab_14/kathara_lab_14_a
```

This lab creates one software switch, `a0`, and three hosts, `h1`, `h2`, and `h3`.

```text
                 Switch a0
              +-------------+
              |     sw0     |
              +-------------+
                |    |    |
                |    |    |
               h1   h2   h3
```

### Link Table

The connections are defined in `kathara_lab_14_a/lab.conf`.

| Node | Interface | Collision domain | Connected to |
|---|---:|---|---|
| `a0` | `eth1` | `a01` | `h1 eth0` |
| `a0` | `eth2` | `a02` | `h2 eth0` |
| `a0` | `eth3` | `a03` | `h3 eth0` |
| `a0` | `eth0` | `a0_d0` | reserved for Part B |
| `a0` | `eth7` | `a0_d1` | reserved for Part B |
| `a0` | `eth4`-`eth6` | `a04`-`a06` | unused |

### Host Addressing

Read the startup files:

```bash
cat h1.startup
cat h2.startup
cat h3.startup
cat a0.startup
```

Record the details in your notes.

| Host | Interface | MAC address | IP address |
|---|---|---|---|
| `h1` | `eth0` | `02:60:ac:9a:bc:01` | `192.168.97.41/24` |
| `h2` | `eth0` | `02:60:ac:9a:bc:02` | `192.168.97.42/24` |
| `h3` | `eth0` | `02:60:ac:9a:bc:03` | `192.168.97.43/24` |

### Switch Configuration

The `a0.startup` file configures `a0` as a software bridge.

| Configuration step | Command pattern used |
|---|---|
| Set each switch-port MAC address | `ip link set dev "$iface" address ...` |
| Remove IP addresses from switch ports | `ip addr flush dev "$iface"` |
| Enable promiscuous mode | `ip link set dev "$iface" promisc on` |
| Bring switch ports up | `ip link set dev "$iface" up` |
| Create the bridge | `ip link add name sw0 type bridge` |
| Enable STP | `ip link set dev sw0 type bridge stp_state 1` |
| Attach interfaces to the bridge | `ip link set dev "$iface" master sw0` |
| Bring the bridge up | `ip link set dev sw0 up` |

Answer these questions in your notes:

1. What is the name of the bridge created on `a0`?
2. Which command attaches an Ethernet interface to the bridge?
3. Do any of the network devices on `a0` have an IP address?
4. What do you notice about the MAC addresses assigned to the switch ports?

### Start the Lab

From inside `kathara_lab_14_a`, start the lab:

```bash
kathara lstart
```

Open shells if needed:

```bash
kathara connect a0
kathara connect h1
kathara connect h2
kathara connect h3
```

When finished with this part, do not clean the lab yet if you plan to continue into Part B.

### Inspect the Switch

On `a0`, inspect the link configuration:

```bash
ip link
```

Then inspect the bridge forwarding database:

```bash
bridge fdb show br sw0
```

Record what the switch knows before any ping traffic is generated.

### Capture Traffic on `h2` and `h3`

On `h2`, start a capture:

```bash
tcpdump -i eth0 -s0 -w /shared/h2-d1.pcap
```

On `h3`, start another capture:

```bash
tcpdump -i eth0 -s0 -w /shared/h3-d1.pcap
```

Leave both captures running.

### Generate a Single Ping

On `h1`, ping `h3` once:

```bash
ping -c1 192.168.97.43
```

Stop both `tcpdump` commands with `Ctrl-C`.

Record how many frames were captured on each host.

### Inspect MAC Learning Again

On `a0`, run:

```bash
bridge fdb show br sw0
```

Compare the result with the earlier output.

Open the captures from the host system using Wireshark:

```bash
wireshark kathara_lab_14_a/shared/h2-d1.pcap
wireshark kathara_lab_14_a/shared/h3-d1.pcap
```

Answer these questions:

1. Which frames did `h2` see?
2. Which frames did `h3` see?
3. Why might a switch flood a frame out of ports other than the incoming port?
4. How does the switch learn which MAC address is behind which port?

### Generate More Traffic

On `h2`, ping `h3` twice:

```bash
ping -c2 192.168.97.43
```

On `a0`, inspect the forwarding database again:

```bash
bridge fdb show br sw0
```

Explain what changed.

## Part B: Adding a Distribution Layer

### Topology

Part B extends the network with three more switches and three more hosts:

- access switch `a10`;
- distribution switches `d0` and `d1`;
- hosts `h101`, `h102`, and `h103`.

Kathara note: unlike the original Netkit version, separate Kathara lab directories are separate scenarios. To make the `a0_d0` and `a0_d1` links connect correctly, use the combined `kathara_lab_14_full` directory for Part B.

Clean the Part A lab first:

```bash
cd ~/ctec1704/lab_14/kathara_lab_14_a
kathara lclean
```

Then start the complete topology:

```bash
cd ~/ctec1704/lab_14/kathara_lab_14_full
kathara lstart
```

The combined topology is:

```text
                         d0 ---------------- d1
                         | \                / |
                         |  \              /  |
                         |   \            /   |
                         |    \          /    |
                         a0 ------------ a10
                       /  |  \          /  |  \
                      h1 h2  h3      h101 h102 h103
```

### Part B Node Table

| Node | Role | IP address |
|---|---|---|
| `a10` | Access-layer switch | none |
| `d0` | Distribution-layer switch | none |
| `d1` | Distribution-layer switch | none |
| `h101` | Host | `192.168.97.101/24` |
| `h102` | Host | `192.168.97.102/24` |
| `h103` | Host | `192.168.97.103/24` |

### Part B Host Addressing

| Host | Interface | MAC address | IP address |
|---|---|---|---|
| `h101` | `eth0` | `02:60:ac:10:10:01` | `192.168.97.101/24` |
| `h102` | `eth0` | `02:60:ac:10:10:02` | `192.168.97.102/24` |
| `h103` | `eth0` | `02:60:ac:10:10:03` | `192.168.97.103/24` |

### Part B Link Table

| Node | Interface | Collision domain | Purpose |
|---|---:|---|---|
| `a10` | `eth0` | `a10_d1` | link to `d1` |
| `a10` | `eth1` | `a101` | link to `h101` |
| `a10` | `eth2` | `a102` | link to `h102` |
| `a10` | `eth3` | `a103` | link to `h103` |
| `a10` | `eth7` | `a10_d0` | link to `d0` |
| `d0` | `eth2` | `d0_d1` | link to `d1` |
| `d0` | `eth3` | `a0_d0` | link to `a0` |
| `d0` | `eth4` | `a10_d0` | link to `a10` |
| `d1` | `eth2` | `d0_d1` | link to `d0` |
| `d1` | `eth3` | `a0_d1` | link to `a0` |
| `d1` | `eth4` | `a10_d1` | link to `a10` |

### Redundant Links

There are multiple Layer 2 paths between hosts. For example, traffic from `h1` to `h102` might travel through:

| Possible path |
|---|
| `h1 -> a0 -> d1 -> a10 -> h102` |
| `h1 -> a0 -> d0 -> a10 -> h102` |
| `h1 -> a0 -> d1 -> d0 -> a10 -> h102` |

These redundant paths provide resilience, but they can also cause Layer 2 loops. A loop can make frames circulate repeatedly, which can cause a broadcast storm. STP prevents this by blocking selected bridge ports so that the active topology becomes loop-free.

### Inspect Learned MAC Addresses

Connect to each switch and inspect its forwarding database:

```bash
kathara connect a0
bridge fdb show br sw0
```

Repeat for:

```bash
kathara connect a10
kathara connect d0
kathara connect d1
```

Record the MAC addresses each switch has learned. Add the information to your topology diagram.

### Ping Across the Extended Network

On `h101`, ping `h3` once:

```bash
ping -c1 192.168.97.43
```

Inspect the forwarding database on each switch again:

```bash
bridge fdb show br sw0
```

Answer these questions:

1. Which switches appear to have carried the ping traffic?
2. Which MAC addresses were learned on each switch?
3. Which ports were used to reach the source and destination hosts?
4. How does this differ from the single-switch topology in Part A?

## Extension: Broadcast Storms and STP

### Capture on a Switch

On `d1`, start a capture on the bridge:

```bash
tcpdump -s0 -i sw0 -w /shared/d1-dump1.pcap
```

You can open the capture later from the host:

```bash
wireshark kathara_lab_14_full/shared/d1-dump1.pcap
```

### Bring Down a Link

On `d0`, bring down one inter-switch link:

```bash
ip link set eth3 down
```

Observe how connectivity and forwarding-database entries change.

Bring the link back up:

```bash
ip link set eth3 up
```

### Inspect STP State

On each switch, inspect bridge and port state:

```bash
bridge link
ip -d link show sw0
```

Look for ports that STP has blocked or placed into a forwarding state.

### Disable STP

Only do this as an experiment, and be ready to stop the lab if traffic grows quickly.

On each switch, disable STP:

```bash
ip link set dev sw0 type bridge stp_state 0
```

Then ping a non-existent host from one of the hosts:

```bash
ping -c1 192.168.97.250
```

Because the destination is unknown, ARP broadcasts may be flooded. With redundant links and STP disabled, this can create a broadcast storm.

Stop captures with `Ctrl-C`, then inspect them in Wireshark.

### Re-enable STP

On each switch, re-enable STP:

```bash
ip link set dev sw0 type bridge stp_state 1
```

## Cleanup

When finished, stop the Kathara labs from the directory you used:

```bash
cd ~/ctec1704/lab_14/kathara_lab_14_full
kathara lclean
```

```bash
cd ~/ctec1704/lab_14/kathara_lab_14_a
kathara lclean
```

## Questions to Answer in Your Lab Notes

| Question | Key idea to discuss |
|---|---|
| What is the difference between a hub and a switch? | Hubs repeat bits to all ports; switches learn MAC addresses and forward selectively |
| How does a switch learn MAC addresses? | It records the source MAC address and ingress port of received frames |
| What happens when the destination MAC address is unknown? | The switch floods the frame out of other active ports |
| Why did `h2` see some traffic between `h1` and `h3`? | Unknown unicast and broadcast behaviour before the switch learns enough |
| Why does `a0` not need an IP address? | It is forwarding Layer 2 frames, not routing Layer 3 packets |
| What problem can redundant Layer 2 paths create? | Loops and broadcast storms |
| How does STP help? | It blocks selected ports to create a loop-free active topology |

## Command Reference

| Task | Command |
|---|---|
| Start a Kathara lab | `kathara lstart` |
| Stop and remove a Kathara lab | `kathara lclean` |
| Connect to a node | `kathara connect <node>` |
| Show interfaces | `ip link` |
| Show IP addresses | `ip addr` |
| Show bridge forwarding database | `bridge fdb show br sw0` |
| Show bridge port state | `bridge link` |
| Create a bridge | `ip link add name sw0 type bridge` |
| Attach interface to bridge | `ip link set dev ethX master sw0` |
| Enable STP | `ip link set dev sw0 type bridge stp_state 1` |
| Disable STP | `ip link set dev sw0 type bridge stp_state 0` |
| Capture traffic | `tcpdump -i eth0 -s0 -w /shared/file.pcap` |
| Open capture on host | `wireshark path/to/file.pcap` |
