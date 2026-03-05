# Lab 5 — Virtualization & System Analysis
**Goal**: Learn virtualization fundamentals by deploying VMs and analyzing system specifications across different platforms.

## Task 1 — VirtualBox Installation

### 1.1 Host Operating System
- **OS:** Windows 11 Pro
- **Version:** 25H2 (сборка ОС 26200.7840)
- **How obtained:** Used the `winver` command

![alt text](image-2.png)

### 1.2 VirtualBox Version
- **Version:** 7.2.4r170995
- **How obtained:** Ran `.\VBoxManage --version`

## Task 2 — Ubuntu VM and System Analysis (5 pts)

- **CPU Details**
Processor model *197* model_neme *Intel(R) Core (TM) Ultra 9 285H*, architecture *x86_64*, cores *3*, frequency *3686.396 MHz*
- **How obtained:** `cat /proc/cpuinfo`

![alt text](image-6.png)
- **Memory Information**: Total RAM *6384096 kB*, available memory *4788912 kB*
- **How obtained:** `cat /proc/meminfo`,`free`

![alt text](image-3.png)
- **Network Configuration**:
- Network interfaces: `enp0s3` (physical), `lo` (loopback)
- IP addresses: 
  - `enp0s3`: 10.0.2.15 (IPv4), fe80::a00:27ff:fe78:3eaf (IPv6 link-local)
  - `lo`: 127.0.0.1 (IPv4), ::1 (IPv6)
- **How obtained:** `ip address` `cat /proc/net/dev`
![alt text](image-4.png)
- **Storage Information**: Disk usage, filesystem details
- **How obtained:** `df`
![alt text](image-5.png)
- **Operating System**: Ubuntu version, kernel information
- **How obtained:** `сat /proc/version`

- **Virtualization Detection**: Confirmation system is running in a VM *oracle*

- **How obtained:** `systemd-detect-virt`

`/proc` was very useful, this directory has information almast all i need


