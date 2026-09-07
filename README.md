# w11 home-ops

Personal home Kubernetes cluster — networking, home automation, and media for
the household. Successor to the old `k3-infrastructure` repo, rebuilt from
scratch on [Talos Linux](https://github.com/siderolabs/talos) and
[`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).

## Stack

- **OS**: Talos Linux (immutable, API-managed)
- **GitOps**: Flux, syncing from this repo
- **Networking**: Cilium (CNI + LoadBalancer IPAM/L2), Envoy Gateway (Gateway
  API ingress), k8s_gateway (internal split-DNS), external-dns
- **External access**: Cloudflare Tunnel, no inbound ports forwarded
- **Secrets**: SOPS + age
- **Image mirroring**: Spegel (peer-to-peer between nodes)
- **Storage**: Longhorn, dedicated disk per node, tuned CPU reservations and
  bounded volume sizes after learning the hard way on the old cluster
- **Observability**: VictoriaMetrics k8s stack (metrics + Grafana + alerting)

## Apps

Home Assistant, ESPHome, Mosquitto, MariaDB, Frigate (GPU-accelerated via
NVIDIA passthrough), UniFi Controller, AirConnect, and a couple of
personal/utility services.

## Maintenance

```sh
just talos apply-node <node>     # apply updated machine config
just talos upgrade-node <node>   # upgrade Talos on a node
just talos upgrade-k8s           # upgrade Kubernetes version
just kube reconcile               # force Flux to sync
```

## Credit

Built from [`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).
