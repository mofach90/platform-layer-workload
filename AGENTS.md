# AGENTS.md — platform-layer-workload

Workload layer of the `platform-live` demo platform (DevFest Berlin 2026).
Project docs live in `../platform-live/docs/`. Read `../platform-live/AGENTS.md` first.

- Terraform root module at the repo root. `platform-live` fetches it at the tag pinned in
  `platform/<env>.yaml` and runs it once per project (`scripts/tf_layer.sh`).
- `modules/vm-group` is part of this repo (not pinned from elsewhere): a module change is a layer release.
- Released only from `main` by semantic-release (tag + GitHub Release, no commit back).
  Conventional Commits are mandatory. Breaking = resources would be destroyed/recreated,
  or platform-live must change how it calls the layer.
- Hard rules are the same as platform-live: no apply, no keys, pin everything (actions by SHA),
  stable for_each keys, `make check` before finishing.
