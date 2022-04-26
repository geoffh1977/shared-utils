## Metal LB - Bare Metal IP Load Balancer

### Notes
Current Version: 0.9.3

* Need To Patch Weave Network With NO_MASQ_LOCAL (Done With Script)
* Need To Add Config To Kube-Proxy And Set strictARP to 'true'

* On Multi Interface Servers - Set NoArp On Interfaces Not To Transmit Arp:
  * ifconfig eno1 -arp
