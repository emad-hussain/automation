
# 📑 Kernel Tuning Parameters

This configuration file is designed to **optimize Linux networking performance** (especially TCP connections) and **harden system security** by tuning kernel parameters via `sysctl`.

It is organized into sections for easy understanding and maintainability.

---

## 📈 1. Speed Up TCP Connections

| Parameter | Description |
|:---|:---|
| `net.core.somaxconn=65535` | Maximum number of incoming connections the system can queue for acceptance. Increases server capacity under high load. |
| `net.ipv4.tcp_fastopen=3` | Enables TCP Fast Open for both clients and servers to speed up connection establishment. |
| `net.ipv4.tcp_syncookies=1` | Enables SYN cookies to protect against SYN flood attacks. |
| `net.ipv4.tcp_fin_timeout=10` | Reduces the time the socket stays in FIN-WAIT-2 state, releasing resources faster. |
| `net.ipv4.tcp_keepalive_time=300` | Time (in seconds) before sending keepalive probes on an idle TCP connection. |
| `net.ipv4.tcp_keepalive_intvl=60` | Interval (in seconds) between keepalive probes. |
| `net.ipv4.tcp_keepalive_probes=5` | Number of failed keepalive probes before declaring the connection dead. |
| `net.ipv4.tcp_max_syn_backlog=8192` | Maximum number of queued connection requests waiting for acceptance. |
| `net.ipv4.ip_local_port_range=1024 65000` | Defines the available range of local ports for outbound connections. |

---

## 🛡️ 2. SYN Flood and DoS Protection

| Parameter | Description |
|:---|:---|
| `net.ipv4.tcp_synack_retries=2` | Limits the number of SYN-ACK retransmissions. Speeds up failure detection. |
| `net.ipv4.tcp_retries1=3` | Number of retries before signaling network problems. |
| `net.ipv4.tcp_retries2=8` | Total retries before dropping a TCP connection (timeout behavior). |

---

## 🔍 3. Reverse Path Filtering (IP Spoofing Protection)

| Parameter | Description |
|:---|:---|
| `net.ipv4.conf.all.rp_filter=1` | Enables strict reverse path filtering to reject spoofed packets. |
| `net.ipv4.conf.default.rp_filter=1` | Applies strict reverse path filtering to newly created interfaces. |

---

## 📶 4. ICMP Protection

| Parameter | Description |
|:---|:---|
| `net.ipv4.icmp_echo_ignore_broadcasts=1` | Ignores ICMP echo requests sent to broadcast addresses. |
| `net.ipv4.icmp_ignore_bogus_error_responses=1` | Ignores bogus ICMP error messages. |
| `net.ipv4.icmp_ratelimit=100` | Limits ICMP packets per second to mitigate ICMP flood attacks. |
| `net.ipv4.icmp_ratemask=88089` | Specifies which ICMP message types are rate-limited. |

---

## 🧵 5. Buffer Size Tuning

| Parameter | Description |
|:---|:---|
| `net.core.rmem_max=33554432` | Maximum size of receive buffers (32 MB). |
| `net.core.wmem_max=33554432` | Maximum size of send buffers (32 MB). |
| `net.core.optmem_max=33554432` | Maximum auxiliary buffer size for sockets. |

---

## 🚀 6. Queue Size Optimizations

| Parameter | Description |
|:---|:---|
| `net.core.netdev_max_backlog=5000` | Maximum number of packets queued on the input side when the kernel processes packets faster than applications can receive. |
| `net.ipv4.tcp_mtu_probing=1` | Enables MTU probing to dynamically detect the correct MTU, avoiding fragmentation issues. |

---

## 🗂️ 7. TIME_WAIT and Orphans Handling

| Parameter | Description |
|:---|:---|
| `net.ipv4.tcp_max_orphans=65536` | Maximum number of orphaned sockets allowed (sockets not attached to any user file descriptor). |
| `net.ipv4.tcp_max_tw_buckets=20000` | Maximum number of TCP sockets in TIME_WAIT state. |

---

## 📏 8. TCP Window Scaling

| Parameter | Description |
|:---|:---|
| `net.ipv4.tcp_window_scaling=1` | Enables TCP Window Scaling as per RFC 1323, improving throughput over high-latency links. |

---

## 🛡️ 9. Filesystem Hardening

| Parameter | Description |
|:---|:---|
| `fs.protected_fifos=2` | Protects named pipes (FIFOs) from being written by unauthorized users. |
| `fs.protected_hardlinks=1` | Prevents users from creating hard links to files they don't own. |
| `fs.protected_regular=2` | Protects regular files in world-writable directories. |
| `fs.protected_symlinks=1` | Prevents symlink attacks by blocking links to files the user doesn't own. |
| `fs.suid_dumpable=0` | Disables core dumps for SUID programs, preventing leaking sensitive information. |

---

## 🛡️ 10. Kernel Security Settings

| Parameter | Description |
|:---|:---|
| `kernel.core_uses_pid=1` | Appends PID to core dump filenames for easier debugging. |
| `kernel.ctrl-alt-del=0` | Disables the Ctrl+Alt+Del reboot sequence. |
| `kernel.dmesg_restrict=1` | Restricts access to `dmesg` output, protecting kernel memory information. |
| `kernel.kptr_restrict=2` | Restricts kernel pointer addresses exposure via `/proc` and `dmesg`. |
| `kernel.perf_event_paranoid=3` | Restricts usage of `perf` performance monitoring tools to root only. |
| `kernel.randomize_va_space=2` | Enables full Address Space Layout Randomization (ASLR) for process memory. |
| `kernel.sysrq=0` | Disables magic SysRq key commands for extra security. |
| `kernel.unprivileged_bpf_disabled=1` | Blocks unprivileged users from loading eBPF programs. |
| `kernel.yama.ptrace_scope=1` | Restricts `ptrace` usage to parent processes only (safer debugging). |

---

## 🛡️ 11. Networking Hardening

| Parameter | Description |
|:---|:---|
| `net.core.bpf_jit_harden=2` | Hardens eBPF JIT compiler to make kernel exploitation harder. |
| `net.ipv4.conf.all.accept_redirects=0` | Disables ICMP redirects (prevents MITM attacks). |
| `net.ipv4.conf.all.accept_source_route=0` | Disables source routed packets. |
| `net.ipv4.conf.all.bootp_relay=0` | Disables BOOTP relay agent functionality. |
| `net.ipv4.conf.all.forwarding=0` | Disables packet forwarding (unless explicitly needed for routing). |
| `net.ipv4.conf.all.log_martians=1` | Logs suspicious (martian) packets. |
| `net.ipv4.conf.all.proxy_arp=0` | Disables proxy ARP to prevent ARP spoofing. |
| `net.ipv4.conf.all.send_redirects=0` | Disables sending ICMP redirects. |
| `net.ipv4.conf.default.accept_redirects=0` | Same as above but applies to new interfaces by default. |
| `net.ipv4.conf.default.accept_source_route=0` | Same as above for new interfaces. |
| `net.ipv4.conf.default.log_martians=1` | Same as above for new interfaces. |
| `net.ipv4.tcp_timestamps=1` | Enables TCP timestamps to improve TCP performance (useful for PAWS). |

---

## 🛡️ 12. IPv6 Hardening

| Parameter | Description |
|:---|:---|
| `net.ipv6.conf.all.accept_redirects=0` | Disables IPv6 ICMP redirects. |
| `net.ipv6.conf.all.accept_source_route=0` | Disables IPv6 source routing. |
| `net.ipv6.conf.default.accept_redirects=0` | Same as above for new interfaces. |
| `net.ipv6.conf.default.accept_source_route=0` | Same as above for new interfaces. |

---

## 📟 13. TTY Device Hardening

| Parameter | Description |
|:---|:---|
| `dev.tty.ldisc_autoload=0` | Prevents automatic loading of line disciplines for TTY devices, reducing attack surface. |

---

# ⚙️ How to Apply These Settings

1. **Copy these settings** into a file like `/etc/sysctl.d/99-custom-tuning.conf`.

2. **Apply the settings immediately** using:
   ```bash
   sudo sysctl --system
   ```

3. **Verify**:
   ```bash
   sudo sysctl -a
   ```

---

# 📢 Important Notes

- Some parameters can **impact legitimate traffic** if set too aggressively (e.g., `tcp_synack_retries`, `icmp_ratelimit`). Test carefully in production.
- If the server acts as a **router**, **forwarding** should remain enabled (`net.ipv4.conf.all.forwarding=1`).
- Certain **NAT-heavy environments** may need to revisit `tcp_tw_reuse` if enabled.
- **Kernel version** differences might affect availability of some options.

---

## 📜 License
This config is free to use and modify under your own terms.

---

## 🏷️ Badges

![OS Linux](https://img.shields.io/badge/os-linux-green.svg)
![Kernel Tuning](https://img.shields.io/badge/kernel-tuning-blue.svg)

---

## ✍️ Author
Crafted with ❤️ by Emad Hussain @ Mecarvi Technologies  
Feel free to improve and contribute!