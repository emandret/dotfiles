---
name: k8s-triage
description: Use when investigating a Kubernetes problem -- pod not starting, crash loops, node issues, "cluster is broken", or any request to check cluster state
---

# Kubernetes triage

## Establish context first

Never assume which cluster or namespace you're pointed at:

```bash
kubectl config current-context
pns                     # current namespace (alias)
```

State the context in your answer. A correct diagnosis of the wrong cluster is
worse than no diagnosis.

## Local helpers

These are defined in `~/.config/zsh/03-kubectl.zsh` -- prefer them:

| Helper       | Does                                                                                   |
| ------------ | -------------------------------------------------------------------------------------- |
| `kga`        | Every namespaced resource in the namespace (`--namespaced='false'` for cluster-scoped) |
| `kge [name]` | Events across all namespaces, sorted by timestamp; filtered to one object if given     |
| `k`          | `kubectl` (via `kubecolor`)                                                            |

`kubectl` is aliased to `kubecolor`, which colourizes output. When parsing output
programmatically, call the real binary to avoid escape codes.

## Sequence

1. **Events before logs.** `kge <pod>` usually names the problem outright
   (scheduling failure, image pull, volume mount, OOMKill).
2. **Describe the object.** `kubectl describe pod <name>` -- read Conditions,
   Events and the container `State`/`Last State` blocks.
3. **Logs, including the previous container.** `kubectl logs <pod> --previous`
   for crash loops; the current container's logs are often empty.
4. **Widen only if needed.** Node conditions (`kubectl describe node`), then
   metrics via Prometheus, if the cluster runs it:
   ```bash
   curl -fsSL --data-urlencode 'query=<promql>' "http://<prometheus-host>/api/v1/query" | jq
   ```
5. **Check desired state.** If the cluster is GitOps-managed, the source of truth
   is the ArgoCD/Flux application or the config repo, not the live object.
   Editing live state gets reverted.

## Rules

- Read-only by default. `kubectl get/describe/logs/events` freely; **ask before**
  `delete`, `apply`, `edit`, `scale`, `drain`, `cordon`, or anything touching a
  production context.
- Never fix a GitOps-managed resource by editing the cluster. Find the manifest.
- Report the context, namespace and the evidence line that led to the conclusion.
- If the mechanism isn't established, use the `systematic-debugging` skill rather
  than listing plausible causes.
