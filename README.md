# home-ops

Kubernetes cluster based on [`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).

## Stack

- **OS**: Talos Linux (immutable, API-managed)
- **GitOps**: Flux, syncing from this repo
- **Networking**: Cilium (CNI + LoadBalancer IPAM/L2), Envoy Gateway (Gateway
  API ingress), k8s_gateway (internal split-DNS), external-dns
- **External access**: Cloudflare Tunnel, no inbound ports forwarded
- **Secrets**: SOPS + age
- **Image mirroring**: Spegel (peer-to-peer between nodes)
- **Storage**: Longhorn, dedicated disk per node
- **Observability**: VictoriaMetrics k8s stack (metrics + Grafana + alerting)

## Apps

Home Assistant, ESPHome, Mosquitto, MariaDB, Frigate, UniFi Controller, AirConnect

## Maintenance

```sh
just talos apply-node <node>     # apply updated machine config
just talos upgrade-node <node>   # upgrade Talos on a node
just talos upgrade-k8s           # upgrade Kubernetes version
just talos shutdown-node <node>  # gracefully power off a node before physical work
just kube reconcile               # force Flux to sync
```

Before unplugging a node, use `shutdown-node`, not raw power-off — it stops
etcd/unmounts disks cleanly. Below 3 control-plane nodes this drops etcd
quorum until it's back (`kubectl`/Flux down, apps keep running). Run `just`
from inside the repo (mise version pins are directory-scoped).

## Upgrading

Renovate queues one PR per dependency (see the dashboard issue). Core infra
(Cilium, cert-manager, Envoy Gateway, flux-operator, CoreDNS) is safe to
merge on green CI — Flux applies their CRD changes automatically. Two
exceptions:

- **Talos**: merging only bumps `topf.yaml`; it doesn't touch the nodes.
  Run `just talos upgrade` (or `upgrade-node <name>` for one). `topf`
  sequences nodes safely on its own and already passes
  `--delete-if-eviction-fails`, required because Longhorn's
  `instance-manager` pod can never be gracefully evicted.

Core service replica counts (cilium-operator, cert-manager, coredns, echo,
envoy) should stay at 2+ so a node reboot never takes one fully down.

## Credit

Built from [`onedr0p/cluster-template`](https://github.com/onedr0p/cluster-template).
