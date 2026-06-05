#import "prelude.typ": *;
#show: styling

== Network Layer

In this layer, there are multiple other smaller layers:
- Hops: the number of router-to-router steps a packet takes to reach its
  destination.
- Routing protocols: rules that help routers choose the best path for data to
  travel across networks.
  - `RIP` (Routing Information Protocol): a simple protocol that picks routes by
    the fewest hops; best for small networks.
  - `OSPF` (Open Shortest Path First): a faster, smarter protocol that learns
    the network map and picks efficient routes inside an organization.
  - `BGP` (Border Gateway Protocol): the protocol that connects different
    networks on the internet and decides how traffic moves between ISPs and
    large providers.
- All of these use a routing table, which is like a router's address book: it
  tells the router where to send a packet next so it can reach its destination.

- The main protocol here is the IP protocol (Internet Protocol): it provides
  logical addressing and packet delivery across interconnected networks.
  - IP is connectionless, so each packet is routed independently and may take a
    different path.
  - It works with addresses like `IPv4` and `IPv6` to identify the source and
    destination of data.
  - Routers read the destination IP address and forward the packet toward the
    next hop using routing tables.
  - IP does not guarantee delivery, ordering, or error recovery; those are
    handled by higher-layer protocols.
  - It also supports fragmentation and reassembly when packets are too large for
    a network link.

- Errors, and signaling is done through the ICMP protocol:
  - `ICMP` (Internet Control Message Protocol) is used by routers and hosts to
    report network problems and diagnostic information.
  - It does not carry user data like TCP or UDP; instead, it sends control
    messages such as destination unreachable, time exceeded, and redirect.
  - Tools like `ping` and `traceroute` rely on ICMP to test reachability and
    measure the path packets take across the network.

Main functions of the network layer:
- Data plane: handles the actual movement of packets from one router to the
  next.
- Control plane: decides the best path packets should take across the network.
- Forwarding: sends each packet to the correct next hop using the routing table.
- Routing: builds and updates the paths that packets should follow to reach
  their destination.
Main SLAs of the Network layer is guaranteed delivery, delivery with bounded
delay and in-order packet delivery, guaranteed minimal bandwidth, guaranteed
minimal jitter, and other security services (CIA triad)

=== Network Services Type

- Connection-oriented service: a path is established before data is sent.
  - The sender and receiver set up a session first.
  - Packets usually follow the same route, so delivery is more predictable and
    often in order.
  - It adds setup overhead, but reliability and consistency are better.

- Connectionless service: each packet is sent independently without setup.
  - No session is created before transmission.
  - Packets may take different paths and can arrive out of order.
  - It is simpler and faster to start, but less predictable.

- Virtual circuits: a connection-oriented service where a path is established
  before data is sent.
  - Packets usually follow the same route.
  - The network can provide more predictable delivery and ordering.
  - Examples include ATM and frame relay style networks.

- Datagram network: a connectionless service where each packet is routed
  independently.
  - No setup is needed before sending data.
  - Packets can take different paths and may arrive out of order.
  - The network stays simpler and more flexible, which is why IP uses this
    model.

=== IP Addresses

- An IP address is just a numerical label associated with each device connected
  to a computer network, which uses the IP protocol for communication.
- Two main functions:
  - Network/host identification: the IP address is split into a network part and
    a host part, so routers can tell which network a device belongs to and which
    specific device to reach.
  - Routing and delivery: routers use the network portion to forward packets
    toward the correct network, then the host portion to deliver the packet to
    the final device inside that network.
  - The prefix length (like `/24` or `/16`) tells us how many bits belong to the
    network part.
  - This is why two devices can share the same network prefix but still have
    different host addresses.
  - In practice, the IP address acts like a location label, helping data move
    across interconnected networks without needing to know the device's physical
    hardware address.

- IP address space is managed in a hierarchy:
  - `IANA` (Internet Assigned Numbers Authority) manages the global pool of IP
    addresses and delegates large blocks to regional registries.
  - `RIRs` (Regional Internet Registries) distribute address blocks to
    countries, ISPs, universities, and organizations in their regions.
- The main Regional Internet Registries are:
  - `ARIN` (American Registry for Internet Numbers)
  - `RIPE NCC` (RIPE Network Coordination Centre)
  - `APNIC` (Asia-Pacific Network Information Centre)
  - `LACNIC` (Latin America and Caribbean Network Information Centre)
  - `AFRINIC` (African Network Information Centre)
- This system prevents conflicts and helps keep IP allocation coordinated across
  the internet.
- Organizations usually do not receive random individual IPs from IANA; they get
  address blocks from an ISP or RIR, and then subnet them internally.
- Some address ranges are reserved for special use and are not publicly routed,
  such as private networks, loopback, and link-local addresses.


IPv4 addresses were distributed by IANA to the RIRs in blocks of approximately
16.8 million addresses.

- These public IPv4 blocks were eventually exhausted at the IANA level.
- DMUC uses the private Class A `10.0.0.0/8` network.

=== IPv4 Rundown

IPv4 is the version of IP most people still recognize today. It uses a 32-bit
address, meaning there are $2^32$ possible combinations in total, which is about
`4.3` billion addresses. In practice, some of these are reserved for special
uses, so the number of publicly routable addresses is smaller. IPv4 addresses
are usually written as four decimal numbers separated by dots, like
`192.168.1.10`.

- Each IPv4 address has two parts:
  - Network part: tells routers which network the device is on.
  - Host part: identifies the device inside that network.
- A prefix like `/24` tells us how many bits belong to the network part.
- Routers use the network part to move packets between networks.
- Once the packet reaches the right network, the host part gets it to the
  correct device.
- IPv4 has a limited number of addresses, so private ranges, subnetting, and NAT
  became important.

#figure(
  table(
    columns: 4,
    [192], [168], [1], [10],
    [Network], [Network], [Host], [Host],
  ),
  caption: [A simple IPv4 address split into network and host parts.],
)

- Common private IPv4 ranges:
  - `10.0.0.0/8`
  - `172.16.0.0/12`
  - `192.168.0.0/16`
- Special-purpose addresses:
  - `127.0.0.1` for loopback
  - `169.254.0.0/16` for link-local
  - `255.255.255.255` for broadcast


=== IPv4 Classes and `/8`

- IPv4 used to be divided into classes, called classful addressing.
- The class was determined by the first bits of the address, which also changed
  the default prefix:
  - Class A: `/8`
  - Class B: `/16`
  - Class C: `/24`
  - Class D: multicast
- A `/8` prefix means the first 8 bits are the network part and the remaining 24
  bits are the host part.
- That gives a Class A network a very large address space:
  $2^24 - 2 = 16,777,214$ usable host addresses.
- `10.0.0.0/8` is a private Class A block, so any address from `10.0.0.0` to
  `10.255.255.255` stays inside private networks unless routed specially.
- Classful addressing is mostly historical now, but it was the main reason IPv4
  space ran out so quickly. Under classful rules, organizations got fixed-size
  blocks: Class A (`/8`), Class B (`/16`), or Class C (`/24`).
- This caused massive waste. A company that needed a few thousand addresses
  might receive a whole Class B block with 65,534 usable hosts, while a much
  larger organization might still outgrow what it had. Because blocks were
  handed out in large, rigid chunks, huge portions of the IPv4 space were
  allocated long before they were actually used.
- The exhaustion happened in stages:
  - First, the usable public IPv4 pool kept shrinking as more devices, ISPs,
    universities, and companies connected to the internet.
  - Second, early allocation policies were generous and inefficient, so many
    organizations held address blocks much larger than they needed.
  - Third, the internet exploded in size, especially with home networks, mobile
    devices, cloud services, and always-connected systems.
  - Finally, `IANA` ran out of free public IPv4 space and could no longer hand
    out large new blocks to the `RIRs`; after that, the regional registries also
    became tight on supply.
- The main solutions were:
  - `CIDR` (Classless Inter-Domain Routing): replaced fixed classes with
    variable-length prefixes like `/12`, `/20`, and `/27`, so networks could get
    blocks that matched their actual size needs.
  - Route aggregation: CIDR also let routers summarize many smaller networks
    into one advertisement, reducing routing-table growth.
  - `Subnetting`: organizations split one allocated block into smaller internal
    networks instead of requesting many separate public blocks.
  - `NAT` (Network Address Translation) and `PAT` (Port Address Translation):
    allowed many private devices to share one public IPv4 address.
  - Private address ranges: `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`
    were reserved for internal use so organizations could reuse the same space
    locally without consuming public IPv4.
  - `IPv6`: introduced a much larger 128-bit address space to solve the
    long-term shortage.
- How they were implemented:
  - `CIDR` changed how addresses are assigned and advertised. Instead of
    assuming the class from the first bits, routers and administrators use the
    prefix length explicitly, like `203.0.113.0/27`.
  - `NAT` is usually implemented at the network edge, such as a home router or
    ISP gateway. Internal devices use private IPs, and the NAT device rewrites
    source addresses and ports so many hosts can appear as one public IP.
  - `IPv6` is deployed with dual-stack systems, tunneling, and translation where
    needed, so networks can gradually move from IPv4 without breaking old
    services.
  - RIR policies became stricter, so new IPv4 allocations are smaller and based
    on real need rather than historical class sizes.
- In short, IPv4 was exhausted because it was distributed inefficiently,
  fixed-size classes wasted space, and internet growth outpaced the 32-bit
  address pool. CIDR, NAT, private addressing, and IPv6 are the main responses
  to that shortage.
- Even though classes are obsolete in practice, they are still useful for
  understanding older documents, default masks, and why `/8`, `/16`, and `/24`
  are such common shorthand.

=== CIDR and Subnet Masking

- `CIDR` (Classless Inter-Domain Routing) is a way to write an IP network with a
  prefix, like `192.168.1.0/24`.
- The `/24` part is the subnet mask in prefix form. It tells how many bits are
  used for the network.
- A bigger prefix number means a smaller network:
  - `/24` = 256 addresses total, 254 usable
  - `/16` = much larger network
  - Formula is $2^h - 2$, h is taking 32 from the network part.
- Subnet masking is the process of separating the network part from the host
  part of an IP address.
- Routers use the mask to know whether a packet stays local or gets forwarded.
- In short: CIDR is the notation, and the subnet mask defines the network size.

=== IPv6 Rundown

- `IPv6` is the newer version of IP designed to replace `IPv4` and solve address
  exhaustion.
- It uses `128` bits, which gives an enormous address space: $2^128$ possible
  addresses.
- An IPv6 address is written in hexadecimal, grouped into 8 blocks of 16 bits,
  like `2001:db8:abcd:12::1`.
- Its main composition is:
  - `Global routing prefix`: identifies the larger network on the internet.
  - `Subnet ID`: identifies the local subnet inside that network.
  - `Interface ID`: identifies the device or interface on that subnet.
- IPv6 supports features like:
  - `Stateless Address Autoconfiguration (SLAAC)` for automatic address setup.
  - `DHCPv6` for managed address assignment.
  - `Link-local addresses` for local network communication, usually starting
    with `fe80::/10`.
  - `Multicast` instead of broadcast; IPv6 does not use broadcast addresses.
- Common shorthand rules:
  - Leading zeros can be omitted.
  - One run of all-zero blocks can be compressed with `::` only once per
    address.
- IPv6 is usually deployed with `dual stack`, where IPv4 and IPv6 run side by
  side during migration.
- Early IPv6 history and proposal work appear in documents such as RFC `1752`,
  and later IPv6-era documents include RFC `2480` among many others.
- In short, IPv6 keeps the same basic job as IPv4, but with a much larger
  address space, cleaner autoconfiguration, and better long-term scalability.

#table(
  columns: 5,
  [Class],
  [IP Range Starts With...],
  [Default Prefix],
  [Hosts per Network],
  [Historical Use Case],

  [Class A],
  [1 to 126],
  [/8],
  [16,777,214],
  [Governments, massive ISPs, global tech giants],

  [Class B], [128 to 191], [/16], [65,534], [Mid-sized companies, universities],
  [Class C], [192 to 223], [/24], [254], [Small businesses, home networks],
  [Class D],
  [224 to 239],
  [N/A],
  [None (Multicast)],
  [One-to-many data streaming],
)

- A router is a networking device that connects different networks and directs
  packets between them.
- Its two primary functions are:
  - Forwarding: sending each packet to the correct next hop using the
    destination IP address and routing table.
  - Routing: building and updating the paths in the routing table so packets can
    reach their destination.

=== RIP, OSPF, and BGP Comparison

- These three routing protocols solve different problems:
  - `RIP` is simple and works best in small networks.
  - `OSPF` is designed for fast, efficient routing inside an organization.
  - `BGP` connects different networks across the internet and follows routing
    policy.

#table(
  columns: 5,
  [Protocol],
  [Type / Scope],
  [How It Chooses a Path],
  [Best For],
  [Easy Summary],

  [`RIP`],
  [Interior Gateway Protocol `IGP` used inside small networks],
  [Chooses the route with the fewest hops. It does not look deeply at link speed
    or quality.],
  [Small networks with simple topologies],
  [Simple, easy to learn, but not very scalable],

  [`OSPF`],
  [Interior Gateway Protocol `IGP` used inside organizations and enterprises],
  [Builds a full map of the network and uses shortest-path calculations based on
    link cost.],
  [Medium to large internal networks],
  [Faster and smarter than RIP for internal routing],

  [`BGP`],
  [Exterior Gateway Protocol `EGP` used between autonomous systems],
  [Uses policy and path attributes such as `AS-path`, local preference, and next
    hop.],
  [Internet-scale routing between ISPs and large organizations],
  [The main protocol that keeps the internet connected],
)

- Quick way to remember them:
  - `RIP`: fewest hops.
  - `OSPF`: best internal path.
  - `BGP`: best policy between networks.

- Main difference:
  - `RIP` and `OSPF` are mostly for routing *inside* one organization.
  - `BGP` is for routing *between* different organizations and networks.


== Link Layer

- The link layer moves frames between neighboring nodes on the same link.
- It is responsible for local delivery, not end-to-end internet delivery.
- Examples:
  + Ethernet.
  + Wi-Fi.
  + Point-to-point links.
  + Switches
- Important link-layer concepts:
  + *Frame*: link-layer data unit.
  + *MAC address*: hardware/link-layer address, such as `00:1a:a0:b4:4b:c1`.
  + *Network adapter/NIC*: hardware that sends and receives frames.
  + *Error detection*: checking whether a frame was corrupted.

=== CSMA

- CSMA means Carrier Sense Multiple Access.
- It is a media-access idea used when multiple devices share the same
  transmission medium.
- A device listens before transmitting:
  + If the medium is idle, it may transmit.
  + If the medium is busy, it waits.
- Ethernet historically used CSMA/CD, where `CD` means collision detection.
- Wi-Fi uses CSMA/CA, where `CA` means collision avoidance, because wireless
  devices cannot reliably detect collisions in the same way as wired Ethernet.

=== ARP

- ARP maps an IPv4 address to a MAC address on the local network.
- A host uses ARP when it knows the destination IP but needs the destination MAC
  address for the Ethernet or Wi-Fi frame.
- Basic ARP flow:
  + Host broadcasts: "Who has this IP address?"
  + The matching host replies with its MAC address.
  + The sender stores the result in its ARP cache/table.
- ARP is local to a subnet. Routers do not forward ARP broadcasts across normal
  routed networks.

=== Ethernet and Switching

- Ethernet frames contain source and destination MAC addresses.
- A switch learns which MAC addresses are reachable on which ports by observing
  incoming frames.
- If the switch knows the destination MAC, it forwards the frame only out the
  correct port.
- If it does not know the destination MAC, it floods the frame out other ports.
- Switches operate mainly at layer 2, while routers operate at layer 3.

=== CRC and Error Detection

- CRC means cyclic redundancy check.
- The sender computes a check value from the frame bits and includes it with the
  frame.
- The receiver recomputes the check value.
- If the values do not match, the receiver treats the frame as corrupted.
- CRC detects many common transmission errors, but it is not encryption and does
  not prove authenticity.

== File Transfer and Remote Access

=== Netkit and Kathara

- Netkit is a network emulation tool used in older networking labs.
- It lets students run multiple virtual Linux machines connected by virtual
  links, so routing, addressing, and packet capture can be practised safely.
- This repo also contains Kathara lab material. Kathara is a more modern
  Docker-based replacement for many Netkit-style labs.
- Typical lab workflow:
  + inspect the topology files.
  + start the lab.
  + run commands such as `ip`, `ping`, `tcpdump`, and `route`.
  + inspect packets in Wireshark.
  + stop and clean the lab.
- These labs help connect theory to real protocol behaviour.

=== FTP

- FTP means File Transfer Protocol.
- It shares files and directories between remote systems using a client-server
  model.
- FTP uses TCP and traditionally uses two connections:
  + port `21` for commands/control.
  + port `20` or a negotiated port for data.
- FTP can use different representations:
  + ASCII mode for text.
  + Image/binary mode for byte-for-byte transfer.
  + EBCDIC mode for IBM text.
  + Local mode for compatible systems using a local format.
- Data transfer modes include:
  + stream mode.
  + block mode.
  + compressed mode.

=== Active and Passive FTP

- In active mode, the client opens the control connection and the server opens a
  data connection back to the client.
- Active mode often fails through NAT or firewalls because the client may not
  accept incoming connections from the internet.
- In passive mode, the client asks the server for a data port and then the
  client opens the data connection.
- Passive mode is commonly used when clients are behind NAT or firewalls.

=== FTP Security

- Plain FTP can expose usernames, passwords, commands, and file contents.
- Common risks include:
  + brute-force login attempts.
  + packet sniffing.
  + spoofing.
  + bounce attacks.
  + port stealing.
- Secure alternatives:
  + *FTPS*: FTP extended with SSL/TLS.
  + *SFTP*: SSH File Transfer Protocol. It is not the same protocol as FTP.
  + *SCP*: secure copy over SSH.
  + `rsync` over SSH for efficient synchronization.

=== SSH

- SSH means Secure Shell.
- It is a cryptographic protocol for secure remote login, remote command
  execution, tunneling, and file transfer.
- Default port: `22`.
- Common commands:

```sh
ssh user@host
ssh -p 2222 user@host
sftp -P 2222 user@host
scp file.txt user@host:/path/
```

- SSH uses cryptography to authenticate the server and encrypt the session.
- Users may authenticate with passwords or public/private key pairs.

== Web Security and TLS

- HTTPS is HTTP carried over TLS.
- TLS provides:
  + confidentiality through encryption.
  + integrity protection against undetected modification.
  + server authentication using certificates.
- SSL is the older predecessor to TLS and is now considered deprecated.

=== Certificates and Certificate Authorities

- A certificate binds a public key to a domain name or identity.
- A certificate authority (CA) signs certificates so clients can decide whether
  to trust a server.
- Browsers and operating systems include trusted CA root certificates.
- If a server presents a valid certificate for the requested domain, the browser
  can verify that it is talking to the expected server.

=== TLS Handshake

- A simplified TLS handshake:
  + Client offers supported TLS versions and cipher suites.
  + Server chooses protocol parameters.
  + Server sends its certificate.
  + Client verifies the certificate.
  + Client and server establish shared session keys.
  + Later HTTP data is encrypted using fast symmetric encryption.
- Public-key cryptography is mainly used during setup and authentication.
- Symmetric encryption is used for the main data transfer because it is faster.

== DHCP and the DORA Cycle

- DHCP means Dynamic Host Configuration Protocol.
- It automatically gives hosts network settings such as:
  + IP address.
  + subnet mask.
  + default gateway.
  + DNS server.
  + lease time.
- DHCP uses UDP and is connectionless.
- DORA cycle:
  + *Discover*: client broadcasts to find DHCP servers.
  + *Offer*: server offers an available address and settings.
  + *Request*: client requests one offered address.
  + *Acknowledge*: server confirms the lease.
- Clients often broadcast because they do not yet have a valid IP address.
- DHCP relay is used when clients and DHCP servers are on different subnets.
- A client may use ARP to check whether an offered address is already in use.

== DNS

- DNS means Domain Name System.
- It translates human-readable names into IP addresses, such as resolving a web
  domain to an IPv4 or IPv6 address.
- DNS is hierarchical:
  + root servers.
  + top-level domain servers, such as `.com`, `.org`, or country-code TLDs.
  + authoritative name servers for specific domains.
  + recursive resolvers used by clients.
- Common DNS record types:
  + `A`: name to IPv4 address.
  + `AAAA`: name to IPv6 address.
  + `CNAME`: alias to another name.
  + `MX`: mail exchanger for email delivery.
  + `NS`: authoritative name server.
  + `TXT`: text records, often used for verification and email security.
- DNS responses are cached for their TTL, which reduces load and improves
  performance.

=== Recursive Lookup

- A typical DNS lookup:
  + The client asks a recursive resolver.
  + The resolver asks a root server where to find the TLD server.
  + The resolver asks the TLD server where to find the domain's authoritative
    server.
  + The resolver asks the authoritative server for the record.
  + The resolver returns the answer to the client and caches it.

=== DNS Security Issues

- Traditional DNS responses are not encrypted and were not designed with strong
  authentication.
- DNS cache poisoning tries to insert false records into a resolver cache.
- Attackers may use misleading domains for phishing.
- DNSSEC adds signatures to DNS data so resolvers can validate authenticity and
  integrity, but it does not encrypt the query.

== Quick Acronyms

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  table.header([*Acronym*], [*Meaning*]),
  [`ARP`], [Address Resolution Protocol],
  [`CSMA`], [Carrier Sense Multiple Access],
  [`CRC`], [Cyclic Redundancy Check],
  [`DHCP`], [Dynamic Host Configuration Protocol],
  [`DNS`], [Domain Name System],
  [`DORA`], [Discover, Offer, Request, Acknowledge],
  [`FTP`], [File Transfer Protocol],
  [`RFC`], [Request for Comments],
  [`SFTP`], [SSH File Transfer Protocol],
  [`SSH`], [Secure Shell],
  [`SSL`], [Secure Sockets Layer, older predecessor to TLS],
  [`TLS`], [Transport Layer Security],
  [`TLD`], [Top-Level Domain],
)
