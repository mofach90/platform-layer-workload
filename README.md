# platform-layer-workload

Workload layer of the [`platform-live`](https://github.com/mofach90/platform-live) demo platform:
the VM groups a team asked for in its `workload.yaml`, built with the `vm-group` module in `modules/vm-group`.

This repo holds only Terraform code. It has no cloud access and is never planned or applied here.
`platform-live` pins a released tag of this repo in `platform/<env>.yaml`:

```yaml
layers:
  workload:
    source: mofach90/platform-layer-workload
    version: v1.0.0
```

Its pipeline fetches that tag and runs it once per registered project, with one state per project.

## Rollout of a change
1. Pull request here, merged with a Conventional Commit (`fix:`, `feat:`, `feat!:`).
2. semantic-release creates the tag and a GitHub Release.
3. Renovate opens a pull request in `platform-live` that bumps `version:` for one environment.
4. The plan comment on that pull request shows the effect on every project. A human merges; the apply rolls it out.

A change is **breaking** (major) when Terraform would destroy and recreate existing resources
or when `platform-live` must change how it calls the layer.

## Module
`modules/vm-group` creates a group of identical private VMs with the platform defaults: no external IP,
OS Login, Shielded VM, own service account, daily snapshots, labels. It is part of this repo on purpose:
a module change is a layer release, so it reaches an environment through exactly one pull request in
`platform-live`. No version pin and no branch reference inside the layer.

## Inputs
| Variable | Meaning |
|----------|---------|
| `registry_file` | absolute path to `platform/<env>.yaml` |
| `project_key` | key of the team project in the registry |
| `identity` | `planner` (read) or `deployer` (write) service account of the team project |
| `workloads_dir` | absolute path to the `workloads/` folder |

## Develop
`make check` runs fmt, validate, tflint, trivy and gitleaks.
To try unreleased code against a real project (read-only plan), from `platform-live`:
```bash
LAYER_DIR=../platform-layer-workload make plan LAYER=workload PROJECT=shop-dev
```

