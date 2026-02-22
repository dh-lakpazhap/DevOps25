# Lab 4 — Operating Systems & Networking

**Goal**: Analyze operating system fundamentals and conduct network diagnostics to develop core DevOps infrastructure skills.

## Task 1 — Operating System Analysis

### Boot Performance Analysis

> systemd-analyze
Startup finished in 1.292s (userspace) graphical.target reached after 1.272s in userspace.

> systemd-analyze blame
653ms landscape-client.service
301ms snapd.seeded.service
211ms snapd.service
210ms dev-sdd.device
140ms wsl-pro.service
118ms snapd.socket
108ms logrotate.service
99ms user@1000.service
88ms systemd-resolved.service
80ms systemd-journal-flush.service
69ms rsyslog.service
59ms systemd-udev-trigger.service
43ms systemd-timesyncd.service
38ms systemd-udevd.service
36ms systemd-logind.service
34ms user-runtime-dir@1000.service
33ms dpkg-db-backup.service
32ms e2scrub_reap.service
32ms dbus.service
31ms systemd-journald.service

`sysatem-analze` shows time wasted for system startup 
`sysatem-analze blame` output list of all running services and time each one took to start

### Check System Load

> uptime
10:18:21 up 12 min,  1 user,  load average: 0.00, 0.00, 0.00
> w
10:18:24 up 12 min,  1 user,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU  WHAT
dhehehe  pts/1    -                10:05   12:40   0.00s   ?    -bash

`uptime` outputs current time in device, system running time since boot, logged in users count, average CPU load over 1, 5, and 15 minutes

`w` shows who is logged in and what they are doing

#### Key Observations:
- **Boot time:** System boots very quickly 
- **Slowest service:** `landscape-client.service` takes **653ms**
- **Current uptime:** System has been running for **12 minutes** since 10:05 AM bu user dhehehe

### Process Forensics

> ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
    PID    PPID CMD                         %MEM %CPU
    207       1 /usr/bin/python3 /usr/share  0.1  0.0   
   1641       1 /usr/libexec/packagekitd     0.1  0.0   
     40       1 /usr/lib/systemd/systemd-jo  0.0  0.0   
    153       1 /usr/lib/systemd/systemd-re  0.0  0.0   
      1       0 /usr/lib/systemd/systemd --  0.0  0.0 

> ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
    PID    PPID CMD                         %MEM %CPU
      1       0 /usr/lib/systemd/systemd --  0.0  0.0   
     89       1 /usr/lib/systemd/systemd-ud  0.0  0.0   
   1641       1 /usr/libexec/packagekitd     0.1  0.0   
   1054       1 /usr/lib/polkit-1/polkitd -  0.0  0.0   
   1217       1 /usr/libexec/wsl-pro-servic  0.0  0.0 

`ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6` shows processes sorted by memory usage (highest first)

`ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6` shows processes sorted by CPU usage (highest first)

#### Key Observations:
- **Overall resource usage:** All processes show *0.0-0.1%* CPU and memory 
- **Memory leaders:** Python script (PID 207) and PackageKit (PID 1641) at 0.1% each
- **CPU leaders:** systemd (PID 1) shows 0.0% — no active CPU consumers

> The top memory-consuming process is `/usr/bin/python3` (PID 207) at 0.1% memory, tied with `packagekitd` (PID 1641).


### Service Dependencies

> systemctl list-dependencies
> systemctl list-dependencies multi-user.target
default.target
○ ├─display-manager.service
○ ├─systemd-update-utmp-runlevel.service
○ ├─wslg.service
● └─multi-user.target
○   ├─apport.service
●   ├─console-setup.service
●   ├─cron.service
●   ├─dbus.service
○   ├─dmesg.service
○   ├─e2scrub_reap.service
○   ├─landscape-client.service
○   ├─networkd-dispatcher.service
●   ├─rsyslog.service
○   ├─snapd.apparmor.service
○   ├─snapd.autoimport.service
○   ├─snapd.core-fixup.service
○   ├─snapd.recovery-chooser-trigger.service
●   ├─snapd.seeded.service
○   ├─snapd.service
multi-user.target
○ ├─apport.service
● ├─console-setup.service
● ├─cron.service
● ├─dbus.service
○ ├─dmesg.service
○ ├─e2scrub_reap.service
○ ├─landscape-client.service
○ ├─networkd-dispatcher.service
● ├─rsyslog.service
○ ├─snapd.apparmor.service
○ ├─snapd.autoimport.service
○ ├─snapd.core-fixup.service
○ ├─snapd.recovery-chooser-trigger.service
● ├─snapd.seeded.service
○ ├─snapd.service
● ├─systemd-ask-password-wall.path
● ├─systemd-logind.service
○ ├─systemd-update-utmp-runlevel.service
● ├─systemd-user-sessions.service

`systemctl list-dependencies`shows a tree of all units and their dependencies

`systemctl list-dependencies multi-user.target` shows everything that needs to start to reach multi-user mode

### User Sessions

> who -a
           system boot  2026-02-22 10:05
           run-level 5  2026-02-22 10:05
LOGIN      tty1         2026-02-22 10:05               209 id=tty1
LOGIN      console      2026-02-22 10:05               200 id=cons
dhehehe  - pts/1        2026-02-22 10:05 01:11         382

> last -n 5
reboot   system boot  6.6.87.2-microso Sun Feb 22 10:05   still running
reboot   system boot  6.6.87.2-microso Wed Feb 18 12:39 - 12:42  (00:02)
reboot   system boot  6.6.87.2-microso Wed Feb 11 14:29 - 15:37 (1+01:07)
reboot   system boot  6.6.87.2-microso Wed Feb  4 16:06 - 13:25 (3+21:19)
reboot   system boot  6.6.87.2-microso Wed Feb  4 15:50 - 16:06  (00:15)

wtmp begins Sat Dec 20 16:09:18 2025

#### Key Observations:
- **Runlevel:** 5 
- **Logged in user:** `dhehehe` on pts/1 since 10:05, idle for **1 hour 11 minutes**
- **Boot history:** Most sessions are very short (2 min, 15 min) except one 3-day session
- **Kernel version:** `6.6.87.2-microso`  Microsoft-optimized kernel for WSL
- **Longest session:** 3 days, 21 hours from Feb 4-8

### Memory Ananlysis

> free -h
               total        used        free      shared  buff/cache   available
Mem:            15Gi       587Mi        14Gi       3.6Mi       238Mi        14Gi
Swap:          4.0Gi          0B       4.0Gi

> cat /proc/meminfo | grep -e MemTotal -e SwapTotal -e MemAvailable
MemTotal:       16048316 kB
MemAvailable:   15448540 kB
SwapTotal:       4194304 kB

#### Key Observations:
- **Total RAM:** 15 GiB (approximately 16 GB)
- **Used memory:** 587 MiB (about 3.8% of total)
- **Available memory:** 14 GiB 
- **Swap usage:** 4 GB swap allocated but **completely unused (0B)**
- **Memory efficiency:** System is very lightweight with minimal memory consumption
- **Buffers/cache:** 238 MiB used for caching 

**Memory Usage Pattern:** Memory usage is extremely low, with the top processes using only 0.1% each. This suggests either a freshly booted system or one with very light workload

## Task 2 — Networking Analysis

### Network Path Tracing

> traceroute github.com
traceroute to github.com (140.82.121.3), 64 hops max    
  1   172.30.208.1  0.702ms  0.181ms  0.113ms
  2   10.91.48.1  7.046ms  3.109ms  2.702ms
  3   10.252.6.1  3.756ms  2.559ms  3.229ms
  4   188.170.164.34  6.608ms  7.139ms  11.476ms        
  5   *  *  *
  6   *  *  *
  7   *  *  *
  8   *  *  *
  9   83.169.204.82  58.098ms  47.133ms  41.556ms       
 10   194.68.123.180  44.541ms  73.244ms  45.322ms      
 11   *  *  *
 12   *  *  * 
 13   *  *  * 
 14   *  *  * 
 15   94.103.180.54  59.053ms  57.009ms  56.883ms 
 16   94.103.180.24  55.210ms  56.990ms  54.972ms 
 17   45.153.82.37  59.970ms  61.112ms  56.139ms 
 18   *  *  * 
 ......
 64   *  *  *

> dig github.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> github.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15449
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;github.com.                    IN      A

;; ANSWER SECTION:
github.com.             5       IN      A       140.82.121.4

;; Query time: 20 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)      
;; WHEN: Sun Feb 22 12:33:59 MSK 2026
;; MSG SIZE  rcvd: 55
#### Key Observations:
**IP Address Mismatch**: Traceroute shows destination IP 140.82.121.3, while dig returns 140.82.121.4 — GitHub uses multiple IPs for load balancing (both in the same /24 subnet).

**Geographical Latency Jump**: Latency jumps from ~11 ms (hop 4) to ~58 ms (hop 9) — a +47 ms increase indicating intercontinental transition (likely Europe → USA).

**Hidden Nodes**: Asterisks on hops 5-8, 11-14, and 18-64 -  routers configured not to respond to ICMP requests (standard security practice).

### Packet Capture
> sudo timeout 10 tcpdump -c 5 -i any 'port 53' -nn
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes

0 packets captured
0 packets received by filter
0 packets dropped by kernel

> dig -x 8.8.4.4
> dig -x 1.1.2.2

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 37050
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.          IN      PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.   5020    IN      PTR     dns.google.

;; Query time: 39 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)      
;; WHEN: Sun Feb 22 12:48:42 MSK 2026
;; MSG SIZE  rcvd: 73


; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> -x 1.1.2.2
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 20093
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;2.2.1.1.in-addr.arpa.          IN      PTR

;; AUTHORITY SECTION:
1.in-addr.arpa.         669     IN      SOA     ns.apnic.net. read-txt-record-of-zone-first-dns-admin.apnic.net. 23597 7200 1800 604800 3600

;; Query time: 306 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)      
;; WHEN: Sun Feb 22 12:48:42 MSK 2026
;; MSG SIZE  rcvd: 137

**DNS Server**: Local provider DNS at 10.255.255.254 handles all queries with good response times.
**Query Types:** Standard A record query for github.com, PTR queries for reverse lookups.
**Response Status:**
github.com: NOERROR with A record
8.8.4.4: NOERROR with PTR record  
1.1.2.2: NXDOMAIN
**Response Time Variation:**
github.com: 20 ms
8.8.4.4: 39 ms
1.1.2.2: 306 ms

### One example DNS query from packet capture
> sudo timeout 15 tcpdump -c 5 -i any 'port 53' -nn
tcpdump: data link type LINUX_SLL2
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
13:28:58.590048 lo    In  IP 10.255.255.254.35297 > 10.255.255.254.53: 52971+ [1au] A? yandex.ru. (50)
13:28:58.595934 lo    In  IP 10.255.255.254.53 > 10.255.255.254.35297: 52971 1/0/1 A 213.180.193.56 (54)
13:28:58.619182 lo    In  IP 10.255.255.254.42813 > 10.255.255.254.53: 64820+ [1au] A? github.com. (51)
5 packets captured
14 packets received by filter

