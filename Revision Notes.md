# Revision Phase Test 3

# Operating Systems

Numbers

Finite state automata & Introduction to data encryption

Hardware

Software

# Network

Network Overview

Application Layer

Transport Layer

Network Layer

Link Layer

File Transfers

Web Servers and Clients

# Network Security

SSL, TLS, HTTPS, CAs, Firewalls, IDS, DMZ

DHCP

DNS

# Network Week 4

Here is a summary 

## Overview of Networking 

The "Overview of Networking" lecture introduces the fundamental concepts of computer networks, specifically focusing on the Internet and its structure, protocols, the Internet protocol stack, and physical media.

* **The Internet and its Structure**

  * The Internet connects millions of devices globally, referred to as **hosts or end systems**.

  * These devices are interconnected using **communication links** and **packet switches**.

  * Information is sent by segmenting data into **packets**, each including header information, and these packets are directed to their destination via **routers** and **link-layer switches**.

  * The Internet's structure involves various **Internet Service Providers (ISPs)**, including **access networks**, which can connect to global transit ISPs.

  * Initially, connecting every ISP to every other ISP was an option, but a more viable model involves global transit ISPs.

  * Today, there are typically 10 to 20 **global ISPs** (e.g., AT\&T, Level 3, Deutsche Telekom), which are identified as **Autonomous Systems (AS)**.

  * These global ISPs interconnect at **Internet Exchange Points (IXPs)** through **peering links**.

  * **Regional networks** also exist, connecting local ISPs to global ISPs. For example, in the UK, British Telecom (AS5400) buys transit from NTT Communications Corp (AS2914) and Level 3 (AS3356).

* **Protocols**

  * A **protocol** defines the **format, order, and actions** for messages exchanged between two or more communicating entities.

  * Protocols can involve more than two parties, especially when not all information is known, when the purpose cannot be fulfilled at a selected endpoint, or to arbitrate issues of trust.

  * Protocols in the Internet are **organized in layers**, which simplifies dealing with complex systems, allows for clear identification of system pieces, and eases maintenance and updates.

* **Internet Protocol Stack (Layered Architecture)** The Internet protocol stack typically consists of five layers, each with a specific role:

  * **Application Layer**: Contains protocols used by applications, such as **HTTP (web browsing)**, **SMTP (email)**, **FTP (file transfer)**, and **DNS (domain name service)**. Packets at this layer are called **messages**.

  * **Transport Layer**: Responsible for transporting messages between end points. Key protocols are **TCP (connection-oriented)** and **UDP (connectionless)**. TCP guarantees delivery and provides flow control. Packets at this layer are called **segments**.

  * **Network Layer**: Provides a delivery service and uses the **Internet Protocol (IP)** for addressing. **Routing protocols** at this level determine the path for **datagrams** (network-layer packets).

  * **Link Layer**: Delivers packets from node to node (or "hop") in the network. Examples of protocols include **Ethernet** or **PPP**. Packets at this layer are called **frames**, and protocols can differ between links.

  * **Physical Layer**: Moves individual bits from node to node.

* **Physical Media**

  * Physical media refers to the technology that carries bits between nodes.

  * **Guided media** includes solid media like copper, fiber, or co-axial cables, where signals propagate within the medium.

  * **Unguided media** allows signals to propagate freely, such as radio or microwave transmissions.

## The Application Layer

The "Application Layer" lecture delves into the highest layer of the Internet protocol stack, focusing on application architectures, addressing, transport service requirements, and specific protocols like Telnet and HTTP.

* **Application Layer Architectures and Addressing**

  * The common architecture is **client-server**, characterized by a one-to-one asynchronous relationship.

  * **Servers** are always-on hosts with permanent IP addresses, often scaled using data centers.

  * **Clients** communicate with servers, may be intermittently connected, and can have dynamic IP addresses, but they typically **do not communicate directly with each other**.

  * To receive messages, a server process needs an **identifier**. This identifier consists of both the **IP address** of the host and a **port number** associated with the specific process on that host. Examples include HTTPS (port 443\) and POP mail (port 110).

  * Processes send and receive messages through **sockets**, where each socket corresponds to one port number, and the IP address and port number are "bound". The operating system controls the socket, while the application developer controls the process.

* **Application-Layer Protocols**

  * Application-layer protocols define the **types of messages** exchanged (e.g., request, response), their **syntax** (fields and delineation), **semantics** (meaning of information), and the **rules** for sending and responding to messages.

  * Protocols can be **open** (defined in RFCs, allowing interoperability, e.g., HTTP, SMTP) or **proprietary** (e.g., Skype).

* **Transport Service Requirements for Applications** Applications have varying needs from the underlying transport layer:

  * **Data Integrity**: Some apps (e.g., file transfer, web transactions) require 100% reliable data transfer, while others (e.g., audio) can tolerate some loss.

  * **Timing**: Some apps (e.g., Internet telephony, interactive games) need low delay to be effective.

  * **Throughput**: Some apps (e.g., multimedia) require a minimum amount of throughput, while "elastic apps" can use whatever throughput is available.

  * **Security**: An important consideration.

* **The Telnet Protocol**

  * **TELetype NETwork (Telnet)**, defined in RFC 15 (1969), was developed to address the problem of having one local terminal per computer.

  * It builds a software stack divided into application and network layers.

  * Telnet uses a **Network Virtual Terminal (NVT)**, which implements a client/server model and requires a common message format.

  * It operates in **full duplex** mode and listens on port 23\.

  * **Security Problems**: Telnet messages are **not encrypted**, meaning data (including passwords) is sent in **plain text**, making it vulnerable to packet sniffing and **Man-in-the-Middle (M-I-T-M) attacks**. It also lacks a robust authentication system. Many exploitable vulnerabilities have been discovered in Telnet servers. Other protocols like FTP, HTTP, and SMTP are based on Telnet's concepts and can suffer from similar issues.

* **Hypertext Transfer Protocol (HTTP)**

  * **HTTP** is the web's application layer protocol, following a **client/server model**.

  * The client (browser) requests and receives web objects, and the server (web server) sends objects in response.

  * HTTP **uses TCP** and the server listens on **port 80**.

  * It is **stateless**, meaning the server does not maintain information about past client requests.

  * **HTTP Versions**: 

    * **1.0 (non-persistent connections)**: At most one object is sent per TCP connection, which then closes.

    * **1.1 (persistent connections)**: Allows multiple objects to be sent over a single TCP connection, supporting pipelining.

    * **2.0**: Introduces push technology.

    * **3.0 (QUIC technology)**: Runs over UDP.

  * **HTTP Messages**: There are two types: **request** and **response**. They use human-readable character sets like UTF-8. 

    * **Request messages** include a request line (method, URL, version), header lines (e.g., Host, User-Agent), and an optional body.

    * **Response messages** include a status line (protocol, status code, status phrase), header lines, and the requested data.

  * **HTTP Response Status Codes**: Categorized by their first digit (e.g., 2xx for success, 4xx for client error, 5xx for server error).

  * **HTTP Request Methods**: Include OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, CONNECT. 

    * **Safe methods** (GET, HEAD, OPTIONS, TRACE) only retrieve data and are considered to have no unwanted side effects.

    * **'Unsafe' methods** (POST, PUT, DELETE, CONNECT) modify data on the server.

    * **Idempotent methods** (OPTIONS, GET, HEAD, PUT, DELETE, TRACE) ensure that a multiple request has the same result as a single request, with no (unwanted) side effects. Browsers typically only use GET and POST.

## The Transport Layer

The "Transport Layer" lecture covers the principles of data transfer, the services provided by this layer, and the two main transport protocols: UDP and TCP, along with ICMP.

* **Transport Layer Services**

  * The transport layer provides **logical communication between application processes**.

  * Packets at this layer are known as **segments**.

  * **Protocol Port Numbers**: These are 16-bit numbers (0-65535) that identify target processes at the application layer and are allocated by IANA. 

    * **Well-known port numbers** (0-1023) are for standard services (e.g., HTTP 80, FTP 21, SMTP 25).

    * **Registered ports** (1024-4095) are for specific applications (e.g., MySQL/MariaDB 3306).

    * Ports **greater than or equal to 4096** are available to the operating system.

  * **Network Sockets**: These are the **endpoints of a Transport Layer communication link**, defined by a **combination of an IP address and a port number**. A transport layer connection is defined by a pair of sockets (client IP/port and server IP/port). Client port numbers are typically supplied by the operating system (between 4096 and 65535).

* **Main Transport Protocols** The Internet primarily uses two transport-layer services:

  * **User Datagram Protocol (UDP)**: Provides an **unreliable, connectionless service** to the application layer. It does not guarantee that data will arrive intact or at all. 

    * **Advantages**: Offers better application-level control over data, no need to establish a connection, no connection state, smaller packets (8-byte UDP header vs. 20-byte TCP header), and speed.

    * Packet loss, reordering, errors, or duplication are common, and remediation is achieved at the application layer if needed (e.g., TFTP), or may not be necessary (e.g., VOIP).

    * Many key Internet applications use UDP, including **Domain Name System (DNS)**, Simple Network Management Protocol (SNMP), Routing Information Protocol (RIP), and Dynamic Host Configuration Protocol (DHCP).

    * UDP segment structure is defined in RFC 768; source port and checksum are optional.

  * **Transmission Control Protocol (TCP)**: Creates **reliable data transfer** on top of IP's unreliable service. 

    * It is a **connection-oriented service**, **full duplex** (data flows both ways), and **point-to-point** (single sender and receiver).

    * Connection setup occurs during a **three-way handshake**, establishing connection state and buffers.

    * TCP provides **flow control**, ensuring the sender does not overwhelm the receiver by maintaining a **receive window (rwnd)**.

    * **TCP Segments**: Headers include fields for header length, ACK, RST, SYN, FIN (for connection setup/teardown), URG, PSH, options (e.g., Maximum Segment Size), and the Receive Window for flow control.

    * **TCP Sequence Numbers**: Count bytes in the data stream, not segments. The sequence number of a segment refers to the first byte in its data field, and an ACK acknowledges that all bytes up to a certain point have been received.

    * **Connection Setup (Three-Way Handshake)**: 

      1. Client sends a **SYN segment** with a random sequence number.

      2. Server replies with a **SYN/ACK** segment, also with a random sequence number.

      3. Client sends an **ACK** (SYN=0), establishing the connection.

    * **Connection Teardown**: Initiated by a **FIN** segment, which is mutual and acknowledged, allowing both parties to free allocated resources.

    * TCP handles **lost ACKs** by retransmitting segments after a timeout, and the receiver discards duplicate segments but retransmits the ACK. TCP also includes mechanisms like **Cumulative ACK** and **Fast Retransmit** (retransmitting without waiting for a timeout).

* **Internet Control Message Protocol (ICMP)**

  * ICMP (RFC 792\) is used by hosts and routers to communicate **network layer information**.

  * An ICMP packet is encapsulated in an IPv4 datagram.

  * **Ping**: Uses ICMP (type 8 code 0 for request, type 0 code 0 for reply) to test connectivity to a specified host.

  * **Traceroute**: Implemented using ICMP (type 11 code 0 for TTL expiration, type 3 code 3 for destination unreachable) and UDP. Each packet is sent with an incremented TTL (Time-To-Live) value, and routers discard packets when TTL reaches zero, sending an ICMP message back to the sender, allowing the sender to resolve the router's address.

* **Attacking TCP: SYN Floods**

  * A **SYN flood** is a Denial-of-Service (DoS) attack that exhausts a server's connections. The attacker sends SYN segments but does not complete the three-way handshake, leaving half-open connections that consume server resources until a timeout.

  * **Mitigation**: **SYN cookies** allow the server to craft a special sequence number without allocating resources for its SYN/ACK. When a valid ACK is received, the server verifies it and establishes the connection; otherwise, no resources are allocated.

# Quiz

## Overview of Networking

1. Which of the following components are used to connect "hosts" or "end systems" on the Internet?

   a) Only communication links

   b) Only packet switches

   c) **Communication links and packet switches** 

   d) Global ISPs only

2. How is information sent over the Internet? 

   a) Information is sent as a continuous stream directly from source to destination. 

   b) Information is encrypted and then sent as a single block. 

   c) The system segments data into packets, including header information for each packet. 

   d) **The system segments data into packets, and these packets are directed through the network using routers and link-layer switches.**

3. What is the primary purpose of organizing Internet protocols in layers? 

   a) To increase the complexity of the system. 

   b) To make it harder to identify relationships between system pieces. 

   c) **To make dealing with complex systems easier, allow for modularization, and ease maintenance and updating.** 

   d) To allow for proprietary protocol development only.

4. In the Internet protocol stack, which layer is responsible for transporting messages between end points and includes protocols like TCP and UDP?

   a) Application Layer

   b) Network Layer

   c) Link Layer 

   d) **Transport Layer**

5. What are packets called at the Network Layer of the Internet protocol stack, and what is their primary function at this layer? 

   a) Messages; to transfer files. 

   b) Segments; to guarantee delivery and flow control.

   c) Frames; to deliver packets from node to node. 

   d) **Datagrams; to provide delivery service and determine the path using IP.**

6. Which of the following is an example of "guided media" for physical data transmission? 

   a) Radio 

   b) Microwave 

   c) **Fibre** 

   d) Satellite

## The Application Layer

1. In a client-server architecture, which of the following is a characteristic of the server? 

   a) It may be intermittently connected. 

   b) It may have dynamic IP addresses. 

   c) It communicates directly with other clients. 

   d) **It is an always-on host with a permanent IP address.**

2. To identify a specific process running on a host and allow it to receive messages, what identifier is required? 

   a) Only the host's globally unique 32-bit IP address. 

   b) Only the process name. 

   c) **A combination of the IP address and the port number associated with the process on the host.** 

   d) The MAC address of the host.

3. Which of the following aspects is *not* defined by an Application-layer protocol? 

   a) Types of messages exchanged (e.g., request, response). 

   b) Message syntax (what fields and how delineated). 

   c) Message semantics (meaning of information in fields). 

   d) **The physical characteristics that represent bits.**

4. What is a known security vulnerability of the Telnet protocol?

   a) It uses strong encryption by default. 

   b) It has a robust authentication system. 

   c) **Messages are not encrypted and are sent in plain text, making passwords easily detectable via packet sniffing.** 

   d) It is designed to resist Man-in-the-Middle (MITM) attacks.

5. Which of the following HTTP request methods is considered "safe" because it only retrieves data and does not cause any unwanted side effects on the server?

   a) POST

   b) PUT 

   c)DELETE 

   d) **GET**

   

   

   

6. What does it mean for an HTTP method to be "idempotent"? 

   a) It requires a secure, encrypted connection. 

   b) It can only be used by client browsers. 

   c) **A multiple request should have the same result as a single request, with no unwanted side effects.** 

   d) It always modifies server-side data.

## The Transport Layer

1. What are transport layer packets known as? 

   a) Datagrams 

   b) Frames c) 

   Messages 

   d) **Segments**

2. What is a "network socket" defined as in the Transport Layer? 

   a) A physical connection cable. 

   b) A dedicated server for storing data. 

   c) **A combination of an IP address and a port number, serving as an endpoint of a communication link.** 

   d) A router's interface.

3. Which protocol is described as providing an "unreliable, connectionless service to the application layer" and does not guarantee that data arrives intact or at all? 

   a) TCP 

   b) ICMP 

   c) **UDP** 

   d) HTTP

4. Why might an application choose to use UDP instead of TCP, despite TCP offering more features like reliability? 

   a) UDP guarantees reliable data transfer. 

   b) UDP requires more complex connection setup. 

   c) **UDP offers better application-level control over data, no need to establish a connection, no connection state, smaller packets, and higher speed.** 

   d) UDP inherently encrypts data, making it more secure.

5. What is the purpose of TCP's "three-way handshake"? 

   a) To retransmit lost segments. 

   b) To provide flow control. 

   c) **To set up a connection, establishing connection state and buffers.** 

   d) To close an existing connection.

   

   

   

6. A "SYN Flood" is a type of Denial of Service (DoS) attack against TCP. How does it primarily work?

   a) By sending encrypted data that the server cannot decrypt. 

   b) By completing many TCP connections rapidly.

   c) By exhausting the server's connections by initiating the handshake but not completing the third part, leaving resources open.

   d) **By sending excessive ACK segments to the server.**

7. What is a mitigation technique for SYN Flood attacks mentioned in the sources? 

   a) Blocking all incoming TCP connections. 

   b) **Using SYN cookies, where the server crafts a special sequence number without allocating resources until the final ACK is received.**

   c) Increasing the server's timeout value indefinitely.

   d) Requiring all clients to use UDP instead of TCP.

# Network – Week 5

Here is a summary of Week5 lectures:

Discuss several key aspects of computer networks, covering layers from the link layer to application-level services like file transfer and web clients/servers.

## The Link Layer

This lecture focuses on the **Link Layer** of networking.

* **Principles of Link Layer Services**: The link layer is typically implemented in the Network Adapter or Network Interface Card (NIC). It handles communication between adjacent nodes (devices like hosts, routers, switches, and hubs) over a communication channel called a link.

* **Link-Layer Frames**: Link-layer protocols encapsulate datagrams from the network layer into *frames* by adding a frame header before transmission.

* **Key Services**: 

  * **Link Access**: This involves Medium Access Protocols (MAC) that specify how a frame is transmitted onto the link. It can be simple for point-to-point links but more sophisticated when multiple access is required. Multiple Access Protocols help detect and avoid collision of transmitted frames on broadcast links (like Ethernet and Wireless LANs). Approaches include Channel Partitioning (e.g., Time Division Multiplexing (TDM) and Frequency Division Multiplexing (FDM), Code Division Multiple Access (CDMA)) and Random Access (e.g., Slotted ALOHA, Carrier Sense Multiple Access with Collision Detection (CSMA/CD)).

  * **Reliable Delivery**: This guarantees the delivery of each network-layer datagram across a link, typically used in high error-rate scenarios to avoid TCP overheads.

  * **Error Detection and Correction**: The link layer can detect and sometimes correct flipped bits (corrupted bits) in a frame, ensuring data integrity. Types of errors include single bit, multiple bits, and burst errors. Error detection methods include **Parity Bits** and **Cyclic Redundancy Check (CRC)**, with CRC being more powerful and able to detect multiple bit errors.

* **Link Layer Addressing**: This involves **MAC addresses** (also called LAN or physical addresses), which are 6 bytes long and typically written in hexadecimal. The first three bytes identify the manufacturer (managed by IEEE), and the last three are determined by the manufacturer to produce unique addresses. Adapters usually only accept frames for their own MAC address, though they can operate in "promiscuous mode" to read all frames. The broadcast address is FF-FF-FF-FF-FF-FF.

* **Address Resolution Protocol (ARP)**: ARP resolves an IP address (Network Layer) to a MAC address (Link Layer) within the same subnet. Each host and router maintains an **ARP table** that stores IP-to-MAC mappings with an expiry time. If a MAC address is not in the ARP table, an ARP query packet is sent as a broadcast (to FF-FF-FF-FF-FF-FF) to discover it. Routers use ARP to discover MAC addresses for devices on different subnets through their interfaces.

* **Ethernet Protocol**: Ethernet is the dominant wired LAN technology, known for being inexpensive and keeping pace with speed advancements (from 10 Mbps to Terabit Ethernet). 

  * **Ethernet Frames**: An Ethernet frame includes a **Preamble** (8 bytes for synchronization), **Destination Address** (6 bytes, MAC of destination adapter), **Source Address** (6 bytes, MAC of transmitting adapter), **Type** (2 bytes, indicating encapsulated protocol or payload size), **Data** (46-1500 bytes, containing the IP datagram), and **CRC** (4 bytes for error detection).

  * **Ethernet Services**: Ethernet provides a **connectionless service** to the network layer and is **unreliable**; frames failing the CRC check are simply discarded without acknowledgment. Gaps in the stream of datagrams are handled by the transport layer (TCP) or not at all (UDP). Ethernet's MAC protocol is unslotted CSMA/CD with binary backoff.

  * **Physical Topology**: The prevailing Ethernet physical topology is the **star topology**, with an active switch in the center, where each "spoke" runs a separate Ethernet protocol, preventing node collisions.

* **Switches and Hubs**: 

  * **Link Layer Switches**: Switches connect networks and operate on link-layer addresses (MAC addresses), not IP addresses. They are **transparent** and do not have their own link-layer addresses. Switches perform **filtering** (dropping frames) and **forwarding** (directing frames to the correct interface). They **self-learn** by observing source MAC addresses of incoming frames and storing them with the arrival interface in a switch table. Switches are "plug and play".

  * **Switches vs. Hubs**: A switch learns which MAC is connected to which socket and forwards the frame only to that socket. A hub, in contrast, broadcasts a frame to all other ports.

  * **Switches vs. Routers**: Both are store-and-forward devices and have forwarding tables. Routers are network-layer devices that compute tables using routing algorithms and IP addresses, while switches are link-layer devices that learn forwarding tables using flooding, learning, and MAC addresses.

## The Network Layer

This lecture focuses on the **Network Layer**, which is responsible for determining the path taken by packets through the network (forwarding/routing).

* **Network Layer Functions**: It involves both a **Data Plane** (local logic) and a **Control Plane** (network-wide logic).

* **Services the Network Layer can Provide**: These include Guaranteed Delivery (packet will eventually arrive), Guaranteed Delivery with bounded delay (within a certain time), In-order packet delivery, Guaranteed minimal bandwidth, Guaranteed maximal jitter, and Security Services (integrity, confidentiality, authentication).

* **Network Service Types**: The network layer can offer **Virtual Circuits** (connection-oriented service) or **Datagram Networks** (connection-less services). In a datagram network, each packet (datagram) is forwarded independently based on its destination address in the header field and a forwarding table, often using **longest prefix matching**.

* **IP Addresses**: An IP address is a numerical label assigned to each device on a network that uses the Internet Protocol. Its two main functions are **location addressing** and **host number (NIC identification)**. 

  * **Management**: IP address space is managed globally by the Internet Assigned Numbers Authority (IANA) and regionally by 5 Regional Internet Registries (RIRs).

  * **IPv4**: IPv4 addresses are **32 bits long** (4 bytes), offering approximately 4 billion possible addresses. They are typically written in **dotted decimal notation**. IPv4 addresses were originally split into 5 classes (A to E).

  * **Subnet Masking**: A subnet mask "masks" the subnet bits, defining the network and host portions of an IP address (e.g., 255.255.255.0/24 for a Class C network). The **local loopback** address is 127.0.0.1 (localhost), used for testing.

  * **IP Address Exhaustion**: IPv4 address space was exhausted in 2011\. Solutions include **Classless Interdomain Routing (CIDR)**, Network Address Translation (NAT), and **IPv6**.

  * **CIDR**: CIDR divides the 32-bit IP address into two parts: a network prefix (first 'x' bits) and a host identifier. It allows for **variable length subnet masks**, offering more flexible and efficient allocation of IP addresses.

  * **IPv6**: IPv6 increased the address space to **128 bits**. It uses a streamlined 40-byte fixed-length header and includes fields like Traffic Class (for priorities) and Flow Label (for QoS). Unlike IPv4, IPv6 **does not allow fragmentation** (routers return an ICMP error if a packet is too large) and **does not do a header checksum** (relies on link-layer and transport-layer checks).

  * **Getting an IP Address**: Hosts can get an IP address through static assignment by an administrator or dynamically through **Dynamic Host Configuration Protocol (DHCP)**, which leases IP addresses to hosts.

* **IPv4 Datagrams**: Key fields in an IPv4 datagram include Version, Header length, Type of service, Datagram length (max 65,535 bytes), Identifier, Flags, Fragmentation offset, **Time-to-Live (TTL)** (decremented at each router to prevent infinite circulation), Protocol (glue to transport layer, e.g., TCP=6, UDP=17), Header checksum (recomputed at every router), Source and Destination IP addresses, Options (rarely used, not in IPv6), and Data (typically a transport layer segment).

* **Routers**: A router is a device that connects two or more packet-switched networks or subnetworks. Its primary functions are managing traffic by **forwarding data packets** to their intended IP addresses and allowing multiple devices to use the same Internet connection. Routing decisions are made using a **routing table**.

* **Routing Protocols**: Examples include **Routing Information Protocol (RIP)**, **Open Shortest Path First (OSPF)**, and **Border Gateway Protocol (BGP)**.

## Transferring Files

This lecture focuses on protocols for transferring files, primarily **FTP** and **SSH-related protocols**.

* **File Transfer Protocol (FTP)**: 

  * **Function**: Shares files and directories between remote systems, providing reliable and efficient data transfer.

  * **Architecture**: Uses TCP/IP protocols and a client-server architecture. Can be secured with SSL/TLS and may implement simple authentication.

  * **Ports**: Uses two TCP ports: **21 for command** and **20 for data**.

  * **Modes**: Operates in **Active** or **Passive mode**, which determines how the data connection is established. Clients behind firewalls often use Passive mode.

  * **Data Representation**: Supports ASCII (text), Image (byte-by-byte), EBCDIC (IBM text), and Local modes (proprietary format for identical machines).

  * **Data Transfer Modes**: Includes Stream mode (continuous stream), Block mode (data in blocks), and Compressed mode (data compressed).

  * **Authentication**: Supports normal username/password (USER, PASS commands) and anonymous login (often for software updates).

  * **Vulnerabilities**: FTP has several known vulnerabilities, including brute force attacks, bounce attacks, packet capture (sniffing), port stealing, spoof attacks, and username protection issues.

* **Secure FTP**: 

  * **FTPS (FTP Secure)**: Secures FTP using **SSL/TLS**. It encrypts username, password, and content. There are **Explicit FTPS** (client requests encryption) and **Implicit FTPS** (deprecated, required SSL/TLS from start).

  * **SFTP (SSH File Transfer Protocol)**: **Not related to FTP**. It uses **Secure Shell (SSH)** to transfer files and encrypts both commands and data using an SSL tunnel. Standard FTP clients cannot communicate with an SFTP server, and vice versa.

* **Alternative FTP Protocols**: 

  * **Trivial File Transfer Protocol (TFTP)**: Uses **UDP on port 69**. It is small and easy to implement, but has no user authentication, a fixed block size, and is a stop-and-wait protocol. Often used for PXE boot from LAN.

  * **FTP over SSH**: This is the practice of **tunneling a normal FTP session over an SSH connection**. It can be difficult because FTP uses multiple TCP connections, and most SSH clients protect the command channel but ignore the data channel.

* **Secure Shell (SSH)**: 

  * **Function**: A **cryptographic network protocol** for operating network services securely over an unsecured network. It uses public-key cryptography for authentication.

  * **Typical Applications**: Remote command-line login and remote command execution. Any network service can be secured with SSH.

  * **File Transfer Protocols over SSH**: Includes **Secure Copy (SCP)** (evolved from RCP), **rsync** (more efficient than SCP), **SSH File Transfer Protocol (SFTP)**, and Files transferred over shell protocol (FISH).

  * **Usage**: The default port for SSH is **22**.

## Web Clients & Servers

This lecture explores **Web Clients and Web Servers** and the underlying infrastructure that runs the Internet.

* **Who Runs the Internet?**: The Internet is run by various organizations, including the **Internet Society (ISOC)**, **Internet Architecture Board (IAB)**, **Internet Engineering Task Force (IETF)**, **Internet Corporation for Assigned Names and Numbers (ICANN)**, and **Regional Internet Registries (RIRs)**. Application layer standards are managed by the **W3C (World Wide Web Consortium)**, and physical layer standards by **IEEE 802**.

* **Web Clients**: 

  * **Primary Function**: Retrieving, presenting, and traversing information resources on the World Wide Web, identified by Uniform Resource Identifiers (URIs).

  * **Examples**: Google Chrome, Mozilla Firefox, Internet Edge (Explorer), Opera, and Safari.

  * **Protocols Supported**: HTTP, HTTPS, FTP, SFTP, file, mailto, news, etc.. They implement HTTP GET & POST methods and use extension plugins for known file types.

  * **Browser Components**: User Interface, Layout Engine, Rendering Engine, JavaScript interpreter, UI backend, Networking component, Data persistence component, and Resolver.

  * **HTML & DOM**: HTML (HyperText Markup Language) defines the structure of web content. The **Document Object Model (DOM)** is a cross-platform, language-independent convention for representing and interacting with objects in an HTML document as a tree structure. **JavaScript** is an object-based interpreted language primarily used for client-side scripting to interact with users, control the browser, communicate asynchronously, and alter displayed content by manipulating the DOM.

  * **MIME Types**: Two-part identifiers for file formats (e.g., text/html; charset=UTF-8), originally for SMTP attachments, assist browsers in correctly displaying web objects.

* **Web Servers**: 

  * **Primary Function**: Deliver web pages using **HTTP & HTTPS** in a request-response cycle. They also receive content from clients and support server-side scripting languages for dynamic content.

  * **Deployment**: Web servers can be embedded in various devices, including printers, routers, and IoT devices.

  * **Common Features**: 

    * **Virtual Hosting**: Serve many websites using one IP address.

    * **Bandwidth Throttling**: Limit response speed to prevent network saturation and serve more clients.

    * **Server-side Scripting**: Generate dynamic web pages.

    * **Path Translation**: Map URL paths to local file system resources (static requests) or internal/external programs (dynamic requests).

  * **Load Limits**: Web servers can handle a limited number of concurrent client connections and maximum requests per second, influenced by configuration, request type, content type, and hardware/software.

  * **Overload Causes**: Too much legitimate traffic, Distributed Denial of Service (DDoS) attacks, computer worms, XSS viruses, Internet bots, and network slowdowns.

  * **Anti-Overload Techniques**: Managing network traffic with firewalls, HTTP traffic managers, bandwidth management, and traffic shaping; web caching; using different domain names/hosts for content; multiple web server programs per host; load balancers; adding hardware resources; tuning OS parameters; and using more efficient web server programs.

  * **Optimal Server Configuration**: Aims for sub-second response times.

  * **Server Bottlenecks**: Often related to **HD access** (disk latency, database requests), not typically CPU intensive.

  * **Caching**: Maximizing RAM and using cache software is crucial, as 80% of traffic often goes to 20% of web pages.

  * **Hardware Configuration**: Requires maximum RAM, RAID, fast HD/SSD, multiple NICs, and fast (64-bit, large multiple cores) processors.

  * **Web Server Daemons (Software)**: Common examples include **Apache HTTP Server** (open-source, multi-platform, services \~30% of websites), **Nginx** (open-source reverse proxy, load balancer, HTTP cache, web server, asynchronous event-driven), **Hiawatha Web Server** (open-source, security-focused, small size), and **IIS/Microsoft** (proprietary, modular architecture).

* **Hosting & Server Farms**: A **server farm** is a collection of computer servers that provide functionality beyond a single machine, potentially thousands of computers. They are expensive financially and environmentally.

# Quiz (Week 5\)

## Link Layer

1. Which of the following statements about **Link Layer Error Detection and Correction** is **true**?

   a) The Link Layer can detect only single-bit errors in a frame. 

   b) Error detection is typically implemented in software for flexibility. 

   c) Cyclic Redundancy Check (CRC) is a less powerful error-detection coding than the checksum in the transport layer. 

   d) The Link Layer is typically able to detect and correct errors, and it is usually implemented in hardware.

   **Answer: d)**

2. Regarding **MAC addresses (Link Layer Addresses)**, which statement is **false**? 

   a) A MAC address is 6 bytes long and is typically written in hexadecimal. 

   b) The first three bytes of a MAC address identify the manufacturer and are managed by IEEE. 

   c) Adapters in promiscuous mode will discard frames not addressed to their specific MAC address. 

   d) The broadcast address FF-FF-FF-FF-FF-FF is read by all adapters.

   **Answer: c)**

3. The **Ethernet Frame** structure includes several fields. Which of the following is **not** a standard field or a correct description of its purpose?

   a) **Preamble** (8 bytes) is used as a wakeup call and for clock synchronisation, with the last two bits (…11) serving as a marker. 

   b) **Type** (2 bytes) defines which protocol is encapsulated in the payload of the frame.

   c) **Data** (46 \- 1,500 bytes) normally contains the IP datagram, but if smaller than 46 bytes, it needs to be "fragmented".

   d) **CRC** (4 bytes) is used to detect errors in the frame.

   **Answer: c)**

   

   

   

   

   

4. How do **Link Layer Switches** learn about connected interfaces?

   a) Switches require manual configuration of their forwarding tables upon initial setup. 

   b) Initially, the switch table is empty, and it learns by storing the source MAC address and arrival interface for each incoming frame.

   c) Switches broadcast an ARP query to discover all MAC addresses on their connected interfaces.

   d) A switch learns by examining network-layer headers, similar to how routers compute their tables.

   **Answer: b)**

## Network Layer

5. Which of the following was **not** explicitly mentioned in the sources as a solution for **IPv4 address exhaustion**?

   a) Classless Interdomain Routing (CIDR). 

   b) Network Address Translation (NAT). 

   c) IPv6. 

   d) Static IP address assignment by an administrator.

   **Answer: d)**

6. In an **IPv4 Datagram**, what is the purpose of the **Time-to-Live (TTL)** field?

   a) It indicates the total length of the datagram in bytes, with a maximum of 65,535 bytes. 

   b) It identifies whether the datagram requires fragmentation. 

   c) It ensures that datagrams do not circulate forever by being decremented at each router. 

   d) It serves as a "glue" to the transport layer, specifying whether it's TCP (6) or UDP (17).

   **Answer: c)**

7. Which of the following is **not** one of the primary functions of a **router** as described in the sources? 

   a) Managing traffic between networks by forwarding data packets to their intended IP addresses. 

   b) Allowing multiple devices to use the same Internet connection. 

   c) Performing routing decisions by reference to a routing table. 

   d) Encapsulating network layer datagrams into link-layer frames for transmission across a hop.

   **Answer: d)**

## File Transfer

8. Regarding the **File Transfer Protocol (FTP)**, which statement is **true**?

   a) FTP uses UDP for its data connections for faster transfer. 

   b) In Active Mode, the client sends a PASV command to receive the server's IP address and port number. 

   c) FTP typically uses two TCP ports: port 21 for command and port 20 for data. 

   d) FTP was defined by RFC 114, which is the only RFC that fully defines the protocol.

   **Answer: c)**

9. What is a key characteristic of **SFTP (SSH File Transfer Protocol)**, according to the sources? 

   a) SFTP is an extension of the standard FTP protocol, enabling secure transmission via SSL/TLS. 

   b) SFTP is functionally similar to FTP but operates by using Secure Shell (SSH) to transfer files, encrypting both commands and data. 

   c) Standard FTP clients are fully compatible with SFTP servers, and vice versa. 

   d) SFTP is also known as "FTP over SSH," which tunnels a normal FTP session.

   **Answer: b)**

 


## Web Clients & Servers

10. Which organization is primarily responsible for the **Internet's Application Layer** standards, as mentioned in the sources? 

    a) The Internet Assigned Numbers Authority (IANA).

    b) The Internet Society (ISOC). 

    c) The World Wide Web Consortium (W3C). 

    d) The Institute of Electrical and Electronics Engineers (IEEE) 802 standards.

    **Answer: c)**

11. A web browser's **components** include various parts that work together. Which of the following is **not** listed as a component of a browser? 

    a) User Interface.

    b) JavaScript interpreter. 

    c) Middleware.

    d) Networking component.

    **Answer: c)**

    * c) The listed components are: User Interface, Layout Engine, Rendering Engine, JavaScript interpreter, UI backend, Networking component, Data persistence component, Resolver. Middleware is not listed.

12. Which of the following is a potential cause of **web server overload** mentioned in the sources? 

    a) Excessive use of server-side scripting languages. 

    b) Deployment of multiple web servers per host. 

    c) Distributed Denial of Service (DDoS) attacks. 

    d) Implementing web cache techniques.

    **Answer: c)**

    * c) "Overload Causes: Too much legitimate concurrent web traffic, Distributed Denial of Service attacks, Computer worms that sometimes cause abnormal traffic, XSS viruses can cause high traffic, Internet bots, Internet (network) slowdowns".

13. Regarding **web server software**, which statement is **false**? 

    a) **Apache HTTP Server** is open source, multi-platform, and services approximately 30% of web sites. 

    b) **Nginx** is known for being an asynchronous event-driven server, offering predictable performance under high loads, and can function as a reverse proxy. 

    c) **Hiawatha Web Server** is a proprietary web server with a focus on security, making it ideal for embedded systems. 

    d) **Microsoft IIS** is proprietary and has a modular architecture with security, content, compression, and caching modules.

    **Answer: c)**

    * c) "Hiawatha Web Server: Open source webserver. Focus on security. Small size – Good for embedded systems. Simple configuration". It is open source, not proprietary.

  


# List of Acronyms

* **ACK**: Acknowledgement (TCP flag/signal)  
* **ALOHA**: (Random Access protocol concept)  
* **Apache**: (Web Server Daemon)  
* **ARP**: Address Resolution Protocol  
* **AS**: Autonomous Systems  
* **ASCII**: American Standard Code for Information Interchange (text format)  
* **Aspera**: (Fast and Secure Protocol, FASP variant)  
* **AUTH**: (Command in Explicit FTPS to request encryption)  
* **BB**: Blackboard (course platform)  
* **BGP**: Border Gateway Protocol (Routing Protocol)  
* **brctl**: (Linux command for bridge control)  
* **CIDR**: Classless Interdomain Routing  
* **CRC**: Cyclic Redundancy Check (error detection)  
* **CSMA**: Carrier Sense Multiple Access  
* **CSMA-CD**: Carrier Sense Multiple Access \- Collision Detection  
* **CSS**: Cascading Style Sheet  
* **CPU**: Central Processing Unit  
* **CDMA**: Code Division Multiple Access  
* **DHCP**: Dynamic Host Configuration Protocol  
* **DNS**: Domain Name System  
* **DOM**: Document Object Model  
* **DoS**: Denial of Service  
* **EBCDIC**: Extended Binary Coded Decimal Interchange Code (IBM text format)  
* **ECMAScript**: (Language standard for JavaScript)  
* **ETag**: (HTTP Header field, Entity Tag)  
* **Ethernet**: (Link Layer protocol)  
* **FASP**: Fast and Secure Protocol  
* **FDM**: Frequency Division Multiplexing  
* **FIN**: (TCP flag, Finish)  
* **FISH**: (Files transferred over shell protocol)  
* **FQP**: Fully Qualified Path  
* **FTP**: File Transfer Protocol  
* **FTPS**: Secure FTP using SSL/TLS  
* **GET**: (HTTP method)  
* **GMT**: (HTTP Header field, Greenwich Mean Time/Coordinated Universal Time)  
* **HEAD**: (HTTP method)  
* **HD**: Hard Disk  
* **HEX**: Hexadecimal  
* **Hiawatha**: (Web Server Daemon)  
* **HTML**: Hypertext Markup Language  
* **HTTP**: Hypertext Transfer Protocol  
* **HTTPS**: Hypertext Transfer Protocol Secure  
* **IAB**: Internet Architecture Board  
* **IANA**: Internet Assigned Numbers Authority  
* **ICANN**: Internet Corporation for Assigned Names and Numbers  
* **ICMP**: Internet Control Message Protocol  
* **IEEE**: Institute of Electrical and Electronics Engineers (manages MAC addresses and standards)  
* **IESG**: Internet Engineering Steering Group  
* **IETF**: Internet Engineering Task Force (defines RFCs)  
* **ifconfig**: (Linux command for network interface configuration, often superseded by ip)  
* **ifup**: (Linux command to bring a network interface up)  
* **IIS**: Internet Information Services (Microsoft Web Server)  
* **IMAP**: Internet Message Access Protocol  
* **IP**: Internet Protocol  
* **IRTF**: Internet Research Task Force  
* **ISP**: Internet Service Provider  
* **ISOC**: Internet Society  
* **ISO**: (HTTP Header field, Character set standard)  
* **IoT**: Internet of Things  
* **IXP**: Internet Exchange Point  
* **JPEG**: (Image file format)  
* **JS**: JavaScript  
* **Jquery**: (JavaScript Library)  
* **LAN**: Local Area Network  
* **LAMP**: (Linux, Apache, MySQL, PHP/Perl/Python \- common web server stack, implied by context)  
* **lcrash**: (Netkit command to forcefully stop labs)  
* **lstart**: (Netkit command to start labs)  
* **LSB**: (Linux Standard Base, implied from command lsb\_release)  
* **LTS**: Long Term Support (Linux distribution versioning)  
* **lynx**: (Text-based web browser)  
* **MAC**: Media Access Control address  
* **man**: (Linux command for manual pages)  
* **MariaDb**: (Database, used as an example for registered ports)  
* **MIME**: Multipurpose Internet Mail Extensions (Media types)  
* **MITM**: Man-in-the-Middle (attack)  
* **MSS**: Maximum Segment Size (TCP Option)  
* **MTU**: Maximum Transmission Unit  
* **MySQL**: (Database, used as an example for registered ports)  
* **NAT**: Network Address Translation  
* **nc**: (netcat, networking utility)  
* **netcat**: (Networking utility, see nc)  
* **Nginx**: (Web Server Daemon, reverse proxy)  
* **NIC**: Network Interface Card  
* **NNTP**: Network News Transfer Protocol  
* **NSA**: National Security Agency (referenced regarding SSH decryption)  
* **NVT**: Network Virtual Terminal (Telnet concept)  
* **ODF**: Open Document Format (spreadsheet format)  
* **OS**: Operating System  
* **OSPF**: Open Shortest Path First (Routing Protocol)  
* **pcap**: (Packet Capture file format)  
* **PASV**: (Passive command in FTP)  
* **PASS**: (Command in FTP authentication)  
* **PID**: Process Identifier  
* **ping**: (Network utility to test reachability using ICMP)  
* **POP**: Post Office Protocol (mail server example)  
* **POP3**: Post Office Protocol version 3 (mail server protocol)  
* **PORT**: (FTP command, can be altered by NAT)  
* **POST**: (HTTP method)  
* **PPP**: Point-to-Point Protocol (Link Layer protocol)  
* **PSH**: (TCP flag, Push)  
* **PuTTY**: (SSH/Telnet client software)  
* **PXE**: Preboot Execution Environment (uses TFTP)  
* **QoS**: Quality of Service  
* **RAID**: Redundant Array of Independent Disks  
* **RAM**: Random Access Memory  
* **RFC**: Request for Comments (document series for Internet standards)  
* **RIP**: Routing Information Protocol (Routing Protocol)  
* **RIR**: Regional Internet Registry  
* **rsync**: (File synchronization tool, runs over SSH)  
* **RST**: (TCP flag, Reset)  
* **rwnd**: Receive Window (TCP flow control)  
* **SCP**: Secure copy (file transfer over SSH)  
* **screen**: (GNU Screen, terminal multiplexer)  
* **SFTP**: SSH File Transfer Protocol  
* **SHA**: Secure Hash Algorithm (likely implied for certificate hashing)  
* **SMTP**: Simple Mail Transfer Protocol  
* **SNMP**: Simple Network Management Protocol  
* **SSD**: Solid State Drive  
* **SSL**: Secure Sockets Layer (predecessor to TLS)  
* **startup**: (Netkit file defining machine startup commands)  
* **STP**: Spanning Tree Protocol  
* **SYN**: (TCP flag, Synchronize)  
* **SYN/ACK**: (TCP flag combination, Synchronize-Acknowledgement)  
* **SYNACK**: (Combined SYN and ACK in Three-way handshake)  
* **tcpdump**: (Network sniffer tool)  
* **TCP**: Transmission Control Protocol  
* **TDM**: Time Division Multiplexing  
* **Telnet**: (TELetype NETwork protocol)  
* **TFTP**: Trivial File Transfer Protocol  
* **TLS**: Transport Layer Security (successor to SSL)  
* **TOR**: The Onion Router (privacy network/browser)  
* **TRACE**: (HTTP method)  
* **TTL**: Time-To-Live (IP header field)  
* **UDP**: User Datagram Protocol  
* **UI**: User Interface  
* **URG**: (TCP flag, Urgent)  
* **URI**: Uniform Resource Identifier  
* **URL**: Uniform Resource Locator  
* **USER**: (Command in FTP authentication)  
* **UTF-8**: (Character encoding standard)  
* **VM**: Virtual Machine  
* **VLSM**: Variable Length Subnet Mask  
* **VOIP**: Voice over IP (uses UDP)  
* **vstart**: (Netkit command to start a single VM)  
* **vhalt**: (Netkit command to stop a single VM)  
* **vlist**: (Netkit command to list running VMs)  
* **W3C**: World Wide Web Consortium  
* **watch**: (Linux command to execute a command periodically and display output)  
* **Wireshark**: (Graphical network traffic analyser)  
* **WWW**: World Wide Web  
* **XSS**: Cross-Site Scripting (security vulnerability)

# Port Numbers

Port numbers are used to identify the target processes at the application layer. They are 16-bit numbers ranging from 0 to 65535 and are allocated by IANA (Internet Assigned Numbers Authority).

Port numbers are categorized into ranges:

* **Ports 0 \- 1023** are considered **well-known port numbers**, used for common services like **HTTP (80)**, **FTP (21)**, and **SMTP (25)**.  
* **Ports 1024 – 4095** are **registered ports**, such as **MySQL/MariaDb (3306)**.  
* **Ports \>= 4096** are typically **available to the operating system** for assignment.

Here is a list of specific port numbers and their associated protocols or services mentioned in the sources:

* **Port 20**: Used for **FTP data** connections.  
* **Port 21**: Used for **FTP command** connections. Mentioned as a well-known port.  
* **Port 22**: The **default port for SSH** (Secure Shell).  
* **Port 25**: Used for **SMTP** (Simple Mail Transfer Protocol). Mentioned as a well-known port. IIS also supports SMTP.  
* **Port 69**: Used by **TFTP** (Trivial File Transfer Protocol), which utilizes **UDP**.  
* **Port 80**: Used for **HTTP** (Hypertext Transfer Protocol). A web server using HTTP listens for client connections on port 80\. It is mentioned in the context of filtering Wireshark traffic, accessing a web server with Telnet, and as a well-known port.  
* **Port 110**: Used for the **POP mail server**.  
* **Port 443**: Used for the **HTTPS server**. IIS also supports HTTPS.  
* **Port 11111**: Used as a client port in a lab exercise connecting via **netcat** using **UDP**.  
* **Port 22222**: Used as a client port in a lab exercise connecting via **netcat** using **UDP**.  
* **Port 2222**: SFTP can be accessed on this port when specified with the \-p switch.  
* **Port 3306**: Used for **MySQL/MariaDb**. Mentioned as a registered port.  
* **Port 51966**: Used in lab exercises with **netcat** for both **TCP** and **UDP** messages. A UDP listener was also started on this port. The operating system could choose this port for a client connection in a lab exercise.  
* **Port 57005**: Used as a **UDP listener** port with **netcat** in a lab exercise.  
* **Port 64206**: Used as a **UDP listener** port with **netcat** in a lab exercise.

The operating system supplies client port numbers, typically from the range of ports greater than or equal to 4096\.

# Understanding Network Security

In today's session, we will explore the essential concepts and tools used to secure computer networks. We'll begin by examining the core principles of **network security**—including **confidentiality**, **authentication**, and **integrity**—and the threats posed by various types of **intruders**, such as **eavesdropping** and **denial-of-service attacks**.

We'll then take a closer look at key security protocols like **Secure Socket Layer (SSL)** and **Transport Layer Security (TLS)**, focusing on how they work, particularly in securing web traffic through **HTTPS**. You'll also learn about the role of **Certificate Authorities (CAs)** in establishing trust online.

To defend networks more broadly, we’ll cover different types of **firewalls**—from **stateless and stateful packet filters** to **application gateways**—alongside a brief overview of **Intrusion Detection Systems (IDS)** and **Demilitarised Zones (DMZs)**.

By the end of this lesson, you’ll have a solid understanding of the strategies and technologies that protect modern networks from cyber threats.

Timeline of Main Events

* **Early Development (Pre-SSL 1.0):** The fundamental principles of network security are established, including the need for confidentiality, authentication, message integrity, and access/availability. The concept of secure communication between parties like "Alice and Bob" facing potential threats from an "intruder" like "Trudy" is a core consideration.

* **Creation of SSL (SSL 1.0):** Netscape develops the Secure Socket Layer (SSL) protocol. Initially, SSL is designed specifically for securing HTTP, LDAP, and POP3 connections.

* **Evolution of SSL Protocols (SSL 1.0 \- SSL 3.0):** SSL undergoes several iterations, leading to versions 2.0 and 3.0, with advancements in cryptographic software and establishing encrypted tunnels between clients and servers. The core functionalities of SSL, including server authentication, cipher suite negotiation, optional client authentication, shared secret generation using public-key techniques, and establishing encrypted connections, are refined.

* **Development of SSL Architecture:** The architecture of SSL is defined, comprising two main layers: the Data Security layer (SSL Record Protocol) and the connection establishment layer (SSL Handshake Protocol, SSL ChangeCipher Spec Protocol, and SSL Alert Protocol).

* **Introduction of TLS (TLS 1.0):** Transport Layer Security (TLS) is introduced as a replacement and update to SSL. TLS builds upon the foundation of SSL, aiming to improve security and address vulnerabilities.

* **Continued Development of TLS (TLS 1.0 \- TLS 1.3):** TLS evolves through subsequent versions, up to TLS 1.3, incorporating improved cryptographic algorithms and key exchange mechanisms, potentially based on Diffie-Hellman or similar algorithms. SSL becomes largely deprecated in favor of TLS.

* **Emergence of SSL/TLS Vulnerabilities:** Various security flaws are discovered in implementations of SSL and TLS. Notable examples mentioned include the Heartbleed Bug (an OpenSSL implementation error, CVE-2014-0160), Poodle, Beast, and Crime. These vulnerabilities highlight the ongoing need for secure implementations and updates.

* **Development of Certificate Authorities (CAs):** The concept and role of Certificate Authorities in the process of authenticating servers and clients through digital certificates (specifically X509 certificates) are established and become crucial components of SSL/TLS.

* **Implementation of Operational Security Measures:** Techniques and technologies for operational network security are developed and utilised. These include Firewalls (stateless packet filters, stateful packet filters, application gateways) to control network traffic, Intrusion Detection Systems (IDS) to monitor for malicious activity, and Demilitarised Zones (DMZ) to protect internal networks while allowing external access to specific services.

Cast of Characters

* **Alice:** Represents a secure sender or a party wishing to communicate securely over a network.

* **Bob:** Represents a secure receiver or the intended recipient of secure communication.

* **Trudy:** Represents an intruder or malicious entity that may attempt to intercept, delete, add, or edit messages, posing a threat to network security.

* **Netscape:** The company credited with creating the initial Secure Socket Layer (SSL) protocol.

* **Kurose & Ross:** Authors of the textbook "Computer Networking," referenced as a source of information related to network security concepts, specifically Chapter 8\.

* **Certificate Authorities (CAs):** Trusted third-party entities responsible for issuing and managing digital certificates, which are used to authenticate the identity of servers and potentially clients in secure communication protocols like SSL/TLS.

* **OpenSSL:** A widely used open-source implementation of the SSL/TLS protocols. Mentioned in the context of the Heartbleed Bug, a significant vulnerability found in OpenSSL.

# Network Security Study Guide

## Quiz

1. What are the four main goals of network security as discussed in the lecture?

2. Briefly describe what "Trudy" represents in the context of secure communication between Alice and Bob.

3. What are the two main layers of the SSL architecture?

4. What is the primary purpose of the SSL/TLS Handshake Protocol?

5. How does the SSL Change Cipher Spec Protocol function?

6. What happens when a fatal alert message is transmitted or received in an SSL session?

7. What is the main difference between SSL and TLS?

8. In the context of HTTPS, what does the browser do with the web server's public key after receiving the certificate?

9. Name two well-known SSL vulnerabilities mentioned in the lecture.

10. What is a Demilitarised Zone (DMZ) in network security?

## Quiz Answer Key

1. The four main goals of network security are Confidentiality, Authentication, Message Integrity, and Access and Availability.

2. Trudy represents an intruder or "bad guy" who can intercept, delete, add, or edit messages during communication.

3. The two main layers of the SSL architecture are the Data security layer (SSL Record Protocol) and the connection establishment layers (SSL Handshake Protocol, SSL ChangeCipher Spec Protocol, SSL Alert Protocol).

4. The primary purpose of the SSL/TLS Handshake Protocol is to establish security capabilities, authenticate the server (and optionally the client), and exchange key parameters.

5. The SSL Change Cipher Spec Protocol is a single message used to signal to the peer that the sender is changing to a new set of keys, usually as part of the handshake to switch to symmetric encryption.

6. Upon transmission or receipt of a fatal alert message, both parties involved in the SSL session immediately close the connection.

7. TLS is an update or replacement for SSL, which is now largely deprecated.

8. The browser uses the web server's public key to encrypt a random symmetric encryption key, which is then sent to the server along with other encrypted data.

9. Two well-known SSL vulnerabilities mentioned are the Heartbleed Bug, Poodle, Beast, and Crime. (Any two of these are acceptable).

10. A Demilitarised Zone (DMZ) is a part of a network that exposes external-facing services (like mail or web servers) to an untrusted network, such as the internet.

## Essay Format Questions

1. Discuss the core principles of network security (Confidentiality, Authentication, Message Integrity, and Access and Availability) and explain how they are addressed by common security protocols like SSL/TLS.

2. Describe the multi-phased process of the SSL/TLS Handshake Protocol in detail, explaining the purpose of each phase and the information exchanged between the client and server.

3. Explain the role of Certificate Authorities (CAs) in establishing trust within secure network communications. Discuss how a digital certificate is used to authenticate clients and servers.

4. Compare and contrast the different types of firewalls discussed in the lecture (stateless packet filters, stateful packet filters, and application gateways), outlining their mechanisms and limitations.

5. Analyse the potential actions a "bad guy" can take to compromise network security (eavesdropping, impersonation, hijacking, Denial of Service) and discuss how network security measures aim to mitigate these threats.

## Glossary of Key Terms

* **Network Security:** The practice of preventing and protecting against unauthorised intrusion into enterprise networks.

* **Confidentiality:** Ensuring that only the sender and intended receiver can understand the message contents.

* **Authentication:** The process of confirming the identity of the sender and receiver.

* **Message Integrity:** Ensuring that the message has not been altered during or after transit.

* **Access and Availability:** Ensuring that services are accessible and available to authorised users.

* **Trudy:** A common representation of an intruder or attacker in network security discussions.

* **SSL (Secure Socket Layer):** A deprecated cryptographic protocol designed to provide communication security over a computer network.

* **TLS (Transport Layer Security):** The successor protocol to SSL, providing encrypted communications over a network.

* **SSL Record Protocol:** Defines the format for transmitting application data securely within an SSL session.

* **SSL Handshake Protocol:** Establishes the secure connection by negotiating parameters and authenticating parties.

* **SSL Change Cipher Spec Protocol:** A protocol used to signal a change in the cryptographic parameters being used.

* **SSL Alert Protocol:** Used to signal problems or the closing of an SSL session.

* **Diffie-Hellman key exchange:** An algorithm that allows two parties to establish a shared secret over an insecure communication channel.

* **HTTPS (Hypertext Transfer Protocol Secure):** The secure version of HTTP, which uses SSL/TLS to encrypt communication between a web browser and a web server.

* **Public Key:** In asymmetric encryption, one of a pair of keys that is made public and used to encrypt messages that can only be decrypted by the corresponding private key.

* **Private Key:** In asymmetric encryption, one of a pair of keys that is kept secret and used to decrypt messages encrypted by the corresponding public key.

* **Symmetric Encryption:** An encryption method where the same secret key is used for both encrypting and decrypting the message.

* **Certificate Authority (CA):** A trusted entity that issues digital certificates to verify the identity of websites and other entities.

* **Digital Certificate:** An electronic document used to prove ownership of a public key, containing information about the key's owner and the CA that issued it.

* **X.509:** A standard defining the format of public-key certificates.

* **Firewall:** A network security device that monitors and controls incoming and outgoing network traffic based on predetermined security rules.

* **Stateless Packet Filter:** A type of firewall that filters packets based on information in the packet headers (e.g., source/destination IP address, port numbers) without considering the state of the connection.

* **Stateful Packet Filter:** A type of firewall that tracks the state of active network connections and uses this information to make filtering decisions.

* **Application Gateway (Proxy Firewall):** A type of firewall that filters network traffic at the application layer, examining the content of packets.

* **Access Control List (ACL):** A list of rules used by routers and firewalls to determine whether to permit or deny network traffic.

* **Intrusion Detection System (IDS):** A system that monitors network or system activities for malicious activities or policy violations and produces reports to a management station.

* **Deep Packet Inspection:** The process of examining the data part of a packet in addition to the header.

* **Demilitarised Zone (DMZ):** A physical or logical subnetwork that contains an organisation's external-facing services to an untrusted network, usually the Internet.

* **Heartbleed Bug:** A major security vulnerability in the OpenSSL cryptographic software library.

**Denial of Service (DoS):** An attack intended to make a machine or network resource unavailable to its intended users by temporarily or indefinitely disrupting services of a host connected to the Internet.

The domain name tree is divided into zones, starting from the root zone.

✅ True

The domain name system is organized like a tree with branches of names.

✅ True

A DNS zone can include several domains and sub-domains.

✅ True

A DNS zone can only have one authoritative server.

❌ False – A DNS zone can have more than one authoritative server for redundancy and reliability.

A DNS zone might contain only one domain.

✅ True

# Network Security Fundamentals: Protocols and Protection

The provided sources offer an overview of fundamental networking concepts, focusing on **Dynamic Host Configuration Protocol (DHCP)**, the **Domain Name System (DNS)**, and **Network Security**. The DHCP material explains how IP addresses are dynamically assigned, detailing the **DORA cycle** (Discovery, Offer, Request, Acknowledgement) and associated issues like reliability and security. The DNS content describes how domain names are mapped to IP addresses through a **hierarchical and distributed system** of name servers, covering its mechanisms, message formats, and security concerns. Finally, the network security text introduces core principles like **confidentiality, authentication, and message integrity**, then examines **SSL/TLS protocols**, their handshake process, and the role of **Certificate Authorities (CAs)**, concluding with a discussion of various **firewall types** and **Intrusion Detection Systems (IDS)** for network protection.

Here's a summary from each source, focusing on acronyms and important points:

**From "ctec1704\_dhcp.pdf"**

This source focuses on the Dynamic Host Configuration Protocol (DHCP) and its operations.

* **DHCP (Dynamic Host Configuration Protocol)**: 

  * A protocol that **dynamically configures IP addresses** for client machines.

  * It uses a **central DHCP server** that manages a pool of IP addresses.

  * An IP address is "leased" to a client machine for a specified duration.

  * The protocol was originally based on **BOOTP** (Bootstrap Protocol), which itself updated the **RARP** (Reverse Address Resolution Protocol).

  * A client machine requests an IP address at boot-up.

  * Clients and DHCP servers can be on the same subnet, typically one server per subnet. For remote subnets, a **DHCP Relay agent** manages requests.

  * DHCP uses **UDP** (User Datagram Protocol) ports: **port 67** for messages sent to the server and **port 68** for messages returned to the client. Communications are **connectionless and stateless**.

  * IP address allocation methods include **dynamic, automatic, and static allocation**.

  * **Reliability**: Clients request a new lease at 50% of the lease time via unicast. If the server is unavailable, the client broadcasts a new DHCP request. If the lease expires, the client broadcasts a DHCP discover message.

  * **Security**: There is **no authentication** in use with standard DHCP. Main attack categories include unauthorized DHCP servers providing false information, unauthorized clients gaining access to resources, and resource exhaustion attacks from malicious DHCP clients. The **Relay Agent Information Option (RFC 3046\)** can use a tag as an authentication token, but key management for a large number of clients poses problems.

* **DORA Cycle (Discovery, Offer, Request, Acknowledgement)**: 

  * This describes the **four basic phases** of IP address allocation: 

    * **DHCP Discover**: The client broadcasts messages to find available DHCP servers on the physical subnet, using a broadcast destination (e.g., 255.255.255.255). The client can also request its last-known IP address.

    * **DHCP Offer**: Upon receiving a discover message, a DHCP server reserves an IP and offers an IP lease to the client, using the **CHADDR** field to determine configuration details.

    * **DHCP Request**: The client broadcasts a request, selecting a single offer from the available servers, and other servers "back-off".

    * **DHCP Acknowledgement (DHCPACK)**: The server sends a DHCPACK message to the client, providing details like lease duration. The client then configures its **NIC** (Network Interface Card) with the received parameters and can use **ARP** (Address Resolution Protocol) to prevent IP conflicts.

  * Clients can optionally send a **release request** to the DHCP server, which releases the DHCP information and deactivates the client's IP address, though this is optional as client devices often don't know when they are unplugged.

* **Configuring a DHCP server**: Configuration typically involves editing files like /etc/dhcp/dhcpd.conf for server settings (e.g., domain-name, domain-name-servers, routers, default-lease-time, IP ranges) and /etc/network/interfaces for client settings.

**From "ctec1704\_dns.pdf"**

This source details the Domain Name System (DNS), its mechanisms, and related issues.

* **DNS (Domain Name System)**: 

  * A **hierarchical distributed naming system** and an essential component of the Internet.

  * Its primary function is to **map textual domain names to IP addresses** (both **IPv4** and **IPv6**), e.g., www.example.com to 192.0.43.10.

  * The Internet maintains two separate namespaces: IP Addresses and Domain Names.

  * **Name Servers**: Organize a hierarchy of domains, with each domain having an **authoritative name server** responsible for its domains and capable of delegating authority to subdomains. This design provides a distributed and fault-tolerant service without needing a single central database.

  * A name server stores **DNS resource records**, such as: 

    * **SOA (Start of Authority)**: Defines the beginning of the authority DNS zone and specifies global parameters like serial number, primary name server, DNS admin e-mail, refresh rate, retry rate, expire time, and default **TTL** (Time To Live).

    * **A or AAAA** (address) records.

    * **NS** (name server) records.

    * **MX** (mail exchanger) records.

    * **PTR** (reverse lookup pointer) records.

    * **CNAME** (domain name aliases or canonical name) records.

  * Other fields in DNS records can include **DNSSEC (Domain Name System Security Extensions)** for authentication (not encryption), **RP** (responsible person), and **DNSBL** (Domain Name System-based Blackhole List).

  * **Domain Name Space**: A tree of domain names where each node or leaf has resource records. The tree subdivides into zones starting at the **root zone**.

  * **TLD (Top-Level Domains)**: **IANA (Internet Assigned Numbers Authority)** distinguishes groups of TLDs, including **ccTLD** (country-code), **gTLD** (generic), **sTLD** (sponsored), unsponsored, and the infrastructure **.arpa** TLD. Domain name registrars are accredited by **ICANN (Internet Corporation for Assigned Names and Numbers)**. Registries maintain databases for their TLDs and publish information using the **WHOIS protocol**.

  * **Domain Name Syntax**: Comprises one or more labels delimited by dots, with a maximum of 127 labels (each up to 63 characters) and a total domain name maximum of 253 characters, using **LDH** (Letters, Digits, Hyphens) characters.

  * **Client Lookup**: **Recursive and caching name servers** are used to improve efficiency, reduce DNS traffic, and increase end-user performance.

  * **DNS Message Format**: Messages are client/server, stateless, and use **UDP segments**. They consist of a **Header**, **Question**, **Answer**, **Authority**, and **Additional** sections. Key fields in the header include: 

    * **ID (Identifier)**: 16-bit field to match queries to responses.

    * **QR (Query/Response Flag)**: 1-bit, 0 for query, 1 for response.

    * **Opcode**: 4 bits, specifies query type.

    * **AA (Authoritative Answer Flag)**: 1-bit, indicates if the server is authoritative.

    * **C (Truncation Flag)**: 1-bit, indicates if the message was truncated (e.g., due to UDP's 512-byte limit).

    * **RD (Recursion Desired)**: 1-bit, requests recursive resolution.

    * **RA (Recursion Available)**: 1-bit, indicates if the server supports recursive queries.

    * **Z (Zero)**: 3 reserved bits.

    * **RCode**: 4 bits, conveys query processing results or errors.

    * **QDCount, ANCount, NSCount, ARCount**: Count the number of entries in the Question, Answer, Authority, and Additional sections, respectively.

  * **Security Issues**: Include **DNS cache poisoning**, where false data is distributed to caching resolvers. DNS responses are traditionally not cryptographically signed, making them vulnerable to spoofing. Mitigation techniques like forward-confirmed reverse DNS can help validate results. **DDoS (Distributed Denial of Service)** attacks against DNS servers are a significant concern, exploiting protocol vulnerabilities.

**From "ctec1704\_network-security.pdf"**

This source discusses various aspects of network security, including core concepts, **SSL/TLS**, and **firewalls**.

* **Network Security Concepts**: 

  * **Confidentiality**: Ensuring only the sender and intended receiver "understand" message contents, typically achieved through encryption.

  * **Authentication**: Confirming the identity of communicating parties.

  * **Message Integrity**: Ensuring messages are not altered during or after transit; alterations should be detectable.

  * **Access and Availability**: Services must be accessible and available to users, often defined by Quality of Service agreements.

  * **Threats ("Bad Guys")**: Can Eavesdrop (intercept messages), Impersonate (spoof source addresses), Hijack (take over connections), and perform **Denial of Service (DoS)** attacks by overloading resources.

* **SSL/TLS (Secure Socket Layer / Transport Layer Security)**: 

  * **Cryptographic software** that creates an **encrypted tunnel** between a client and server, agreeing on an encryption algorithm.

  * Provides an **API** (Application Programming Interface) to applications (e.g., C, PHP, Java/Scala libraries).

  * Multiple **SSL** protocols (1.0 to 3.0) and **TLS** protocols (1.0 to 1.3) exist, with **TLS** being a replacement/update and **SSL** largely deprecated.

  * **Functions**: Authenticates the server to the client, allows selection of cryptographic algorithms (ciphers), optionally authenticates the client to the server, uses public-key encryption to generate shared secrets, and establishes an encrypted connection.

  * Netscape created SSL for **HTTP**, **LDAP**, and **POP3**.

  * **SSL Architecture**: Comprises two layers: the **SSL Record Protocol** (for data security) and protocols to establish the connection (**SSL Handshake Protocol**, **SSL ChangeCipher Spec Protocol**, **SSL Alert Protocol**).

  * **SSL Record Protocol**: Defines data format by chunking data, compressing it, adding a **MAC** (Message Authentication Code) calculated with an Integrity Key, encrypting packets, and adding an SSL header.

  * **SSL Handshake Protocol**: A four-phase process for establishing security capabilities, server authentication and key exchange, optional client authentication and key exchange, and a final confirmation that subsequent communication will be encrypted. Server sends **X509 certificates** to the client for authentication.

  * **SSL ChangeCipher Spec Protocol**: Used to change the encryption method, typically switching to symmetric key encryption during the handshake.

  * **SSL Alert Protocol**: Signals problems with an SSL session; fatal alerts cause immediate connection closure. A close\_notify message should be sent to prevent truncation attacks and ensure the session is resumable.

  * **HTTPS (Hypertext Transfer Protocol Secure)**: Illustrates the **TLS** process for web browsing: browser requests secure page, web server sends public key with certificate, browser checks certificate (issued by trusted **CA** \- Certificate Authority), browser encrypts symmetric key and sends it with data, server decrypts with private key and symmetric key, and all subsequent data is encrypted with the symmetric key.

  * **Vulnerabilities**: Famous examples include the **Heartbleed Bug** (an **OpenSSL** implementation error, **CVE-2014-0160**), **Poodle**, **Beast**, and **Crime**.

* **Firewalls**: 

  * Used to **isolate an organization's internal network** from the Internet, allowing or blocking packets.

  * Prevent **DoS** attacks (e.g., **SYN** flooding), illegal modification/access of internal data, and allow only authorized access.

  * **Types**: 

    * **Stateless packet filters**: Router filters packets based on source/destination **IP** address, **TCP/UDP** port numbers, **ICMP** message type, and **TCP SYN** and **ACK** bits. They are "heavy-handed" and may admit "senseless" packets. An **ACL (Access Control List)** defines rules for forwarding/dropping packets.

    * **Stateful packet filters**: Track the status of every **TCP** connection (setup via **SYN**, teardown via **FIN**) to determine if incoming/outgoing packets "make sense". They timeout inactive connections. ACLs are augmented to check connection state.

    * **Application gateways**: Filter packets based on **application data** in addition to **IP/TCP/UDP** fields. For example, they can require all **telnet** users to go through the gateway. Limitations include not verifying the claimed source of data (**IP spoofing**), needing separate gateways for different applications, and requiring client software to be configured to contact the gateway.

* **IDS (Intrusion Detection System)**: 

  * Performs **deep packet inspection** to look at packet contents for known virus or attack strings.

  * Examines correlations among multiple packets to detect activities like port scanning, network mapping, or **DoS** attacks.

  * Multiple IDSs can be deployed for different checks at various locations.

* **DMZ (Demilitarized Zone)**: 

  * A part of a network that exposes external-facing services (e.g., mail, web) to a wider untrusted network like the Internet, while keeping the internal network separate and more secure.

## Quiz: Network Security

**1\. Which of the following is NOT one of the four fundamental network security goals mentioned in the sources?** 

a) Confidentiality 

b) Message integrity 

c) **Resource availability** \[This is part of "Access and availability"

d) Authentication

*Correct Answer: c)*

**2\. The SSL/TLS Handshake Protocol involves four phases. What happens in Phase 2, "Server authentication and key exchange"?** 

a) The client offers TLS version and list of ciphers 

b) **The server sends its certificate and key exchange parameters**

c) The client sends its certificate (if optional) 

d) The confirmation of cipher suites occurs 

*Correct Answer: b)*

**3\. What is the primary function of the SSL Record Protocol?** 

a) To establish the connection and perform key exchange 

b) To signal problems with an SSL session 

c) To change the encryption being used by the client and server 

d) **To define the data transmit format, including chunking, compression, adding MAC, and encrypting packets** 

*Correct Answer: d)*

**4\. Which type of firewall tracks the status of every TCP connection and determines whether incoming and outgoing packets "make sense"?** 

a) Stateless packet filter 

b) **Stateful packet filter** 

c) Application gateway 

d) Demilitarized Zone (DMZ) 

*Correct Answer: b)*

**5\. According to the sources, what is a key limitation of firewalls and gateways related to IP spoofing?** 

a) They cannot prevent Denial of Service (DoS) attacks 

b) **The router can't know if data "really" comes from the claimed source** 

c) They always require client software to know how to contact the gateway 

d) They operate only on application data, not IP/TCP/UDP fields 

*Correct Answer: b)*

**6\. What is the purpose of a Demilitarized Zone (DMZ) in a network?** 

a) To isolate internal networks from all external services 

b) To act as a primary firewall, blocking all incoming traffic 

c) **To expose external facing services (like mail, web) to a wider untrusted network (e.g., the internet) while isolating the internal network** 

d) To store encrypted data only, without any network access  

*Correct Answer: c)*

## Quiz: Networks (DHCP)

**1\. What is the primary function of DHCP?**

a) To provide secure encryption for network communication

b) To resolve domain names to IP addresses 

c) **To dynamically configure IP addresses for client machines**

d) To manage network firewalls and security policies

*Correct Answer: c)*

**2\. Which of the following accurately represents the four basic phases of the DHCP DORA cycle?**

a) Discover, Open, Reserve, Acknowledge 

b) Decline, Offer, Request, Allocate 

c) **Discovery, Offer, Request, Acknowledgement**

d) Diagnose, Order, Report, Activate

*Correct Answer: c)*

**3\. When a client broadcasts a DHCP Discover message, what is the broadcast destination IP address typically used?**

a) 127.0.0.1 

b) **255.255.255.255**

c) The DHCP server's specific IP address 

d) The client's own IP address

*Correct Answer: b)*

**4\. What UDP port number is used by clients for sending messages to a DHCP server?**

a) Port 68

b) Port 53

c) Port 80

d) **Port 67**

*Correct Answer: d)*

**5\. Which of the following is NOT one of the three main categories by which a DHCP server may be attacked?**

a) Unauthorized DHCP servers providing false information to clients 

b) Unauthorized clients gaining access to resources

c) **Denial of Service (DoS) attacks specifically targeting the DORA cycle's offer phase** \[This is too specific; DoS is a general attack type mentioned in the context of security issues, but not as a *main category* of DHCP server attack\]

d) Resource exhaustion attacks from malicious DHCP clients

*Correct Answer: c)*

**6\. If a DHCP client's lease expires and the server is unavailable, what action does the client take?**

a) It unicasts a new lease request 

b) It immediately deactivates its IP address and shuts down

c) **It broadcasts a new DHCP discover as before**

d) It attempts to reconfigure its NIC with a static IP

*Correct Answer: c)*

## Quiz: Networks (DNS)

**1\. DNS is described as a hierarchical distributed naming system. What essential component of the Internet does it provide?**

a) Secure communication protocols

b) **Mapping textural domain names to IP addresses**

c) Dynamic IP address assignment  

d) Network firewall services  

*Correct Answer: b)*

**2\. Which of the following is NOT listed as an organization involved in running the Internet?**

a) Internet Society (ISOC) 

b) Internet Engineering Task Force (IETF) 

c) **World Wide Web Consortium (W3C), in terms of the Physical layer** (W3C is mentioned for Application layer, not Physical layer) 

d) Internet Corporation for Assigned Names and Numbers (ICANN) 

*Correct Answer: c)*

**3\. What is the purpose of an 'A' or 'AAAA' record in a DNS name server?**

a) To define the beginning of the authority DNS zone b) To specify the mail exchanger for a domain c) To provide a canonical name (alias) for a domain 

d)**To store address records, mapping domain names to IPv4 or IPv6 addresses respectively** 

*Correct Answer: d)*

**4\. Which section of a DNS message carries one or more resource records that answer the question(s) indicated in the Question section?**

a) Header 

b) Question 

c) Authority 

d) **Answer** *Correct Answer: d)*

**5\. What does the 'QR' flag in a DNS message header differentiate between?** 

a) Authorized and Unauthorized answers  

b) **Queries and Responses** 

c) Recursive and Iterative queries  

d) Signed and Unsigned messages  

*Correct Answer: b)*

**6\. What is a "canonical name" (CNAME) record used for in DNS?** 

a) To set the Time To Live for a record 

b) To define the primary name server 

c) **To provide domain name aliases** 

d) To indicate the serial number of a zone 

*Correct Answer: c)*