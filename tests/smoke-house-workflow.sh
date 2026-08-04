#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
mode=${1:-all}
tmp=
trap '[[ -z "$tmp" ]] || rm -rf "$tmp"' EXIT

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
has() { grep -Fq -- "$2" "$1" || fail "$1 missing: $2"; }
lacks() { ! grep -Fq -- "$2" "$1" || fail "$1 contains stale text: $2"; }
exists() { [[ -e "$1" ]] || fail "missing: $1"; }
absent() { [[ ! -e "$1" ]] || fail "must be absent: $1"; }

generated() {
  local project=$1 name
  for name in opsx-apply opsx-archive opsx-explore opsx-propose opsx-sync; do
    exists "$project/.opencode/commands/$name.md"
  done
  for name in openspec-apply-change openspec-archive-change openspec-explore openspec-propose openspec-sync-specs; do
    exists "$project/.opencode/skills/$name/SKILL.md"
  done
}

bootstrap() {
  local fresh existing file real_config real_config_before real_config_after
  real_config=$(openspec config path)
  real_config_before=$(if [[ -e "$real_config" ]]; then cksum <"$real_config"; else printf 'absent'; fi)
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/house-workflow.XXXXXX")
  export HOME="$tmp/home" XDG_CONFIG_HOME="$tmp/config" XDG_DATA_HOME="$tmp/data"
  mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

  openspec config profile core >/dev/null
  openspec config set delivery both >/dev/null
  [[ $(openspec config get profile) == core ]] || fail "profile is not core"
  [[ $(openspec config get delivery) == both ]] || fail "delivery is not both"

  fresh="$tmp/fresh"
  mkdir -p "$fresh"
  openspec init "$fresh" --tools opencode --profile core >/dev/null
  generated "$fresh"

  existing="$tmp/existing"
  mkdir -p "$existing"
  openspec init "$existing" --tools opencode --profile core >/dev/null
  printf 'preserve\n' >"$existing/sentinel"
  rm -rf "$existing/.opencode"
  openspec init "$existing" --tools opencode --profile core >/dev/null
  has "$existing/sentinel" preserve
  generated "$existing"

  rm "$existing/.opencode/commands/opsx-propose.md"
  openspec update --force "$existing" >/dev/null
  generated "$existing"

  real_config_after=$(if [[ -e "$real_config" ]]; then cksum <"$real_config"; else printf 'absent'; fi)
  [[ $real_config_after == "$real_config_before" ]] || fail "isolated OpenSpec operations altered $real_config"

  has "$root/commands/house-new.md" '.opencode/commands/opsx-propose.md'
  has "$root/commands/house-new.md" 'openspec-propose'
  has "$root/commands/house-new.md" 'house-init'
  has "$root/commands/house-new.md" 'restart OpenCode'
  has "$root/commands/house-new.md" 'Override only its next-step handoff'
  has "$root/commands/house-new.md" '/house-apply'
  has "$root/commands/house-new.md" 'not `/opsx-apply`'
  lacks "$root/commands/house-new.md" 'openspec new change'
  lacks "$root/commands/house-new.md" 'openspec instructions'

  has "$root/AGENTS.md" 'When the active OpenSpec schema is `house-style`'
  has "$root/AGENTS.md" '`/opsx-explore` and `/opsx-propose`'
  has "$root/AGENTS.md" '`/house-apply` and `/house-archive`'
  has "$root/AGENTS.md" 'not generated `/opsx-apply` or `/opsx-archive` commands'
  has "$root/AGENTS.md" 'directly invokes `/opsx-propose`'
  has "$root/AGENTS.md" 'replace its generated `/opsx-apply` next-step suggestion with `/house-apply`'

  for file in "$root/commands/house-init.md" "$root/commands/house-adopt.md"; do
    has "$file" 'schema: house-style'
    has "$file" 'Save the current global `delivery` value'
    has "$file" 'Temporarily set `delivery` to `both` only if'
    has "$file" 'Restore the saved global `delivery` value before returning'
    has "$file" 'success or failure'
    has "$file" '`--profile core` is command-local'
  done

  for file in "$root/AGENTS.md" "$root/commands/house-new.md" "$root/skills/openspec-house-style/SKILL.md"; do
    has "$file" '/house-apply'
    has "$file" '/opsx-apply'
  done
  has "$root/AGENTS.md" '/house-archive'
  has "$root/AGENTS.md" '/opsx-archive'

  for skill in openspec-propose openspec-explore openspec-apply-change openspec-archive-change; do
    absent "$root/skills/$skill"
  done
  absent "$root/skills/trace-matrix"
  printf 'bootstrap: PASS\n'
}

runner() {
  local file="$root/agents/runner.md" text
  exists "$file"
  for text in 'mode: subagent' 'bash: ask' 'edit: deny' 'task: deny' 'unit tests' 'integration tests' 'builds' 'lint' \
    'TYPE:' 'COMMAND:' 'RESULT:' 'EXIT CODE:' 'FAILED' 'BLOCKED' 'Do not edit source' \
    'unit | integration | build | lint | validation | inspection | configuration' \
    'Do not run formatters' 'dependency installation' 'clean commands' 'migrations' 'database mutations' \
    'services, containers, devices, or emulators' 'design or apply fixes'; do
    has "$file" "$text"
  done
  lacks "$file" 'without explicit approval'
  lacks "$file" 'Explicit approval applies'
  printf 'runner: PASS\n'
}

apply() {
  local file="$root/commands/house-apply.md" targeted review final text
  for text in 'Delegate every planned targeted check to Runner after the slice' \
    'Treat Runner `FAILED` and `BLOCKED` results as non-passing' \
    'build or a narrowly scoped fixer, never to Runner' \
    'affected check to Runner again' \
    'After the last review loop is clean' \
    'Delegate every command under "Final verification intent" to Runner' \
    'type,' 'exact command' 'exit code' 'outcome'; do
    has "$file" "$text"
  done
  targeted=$(grep -nF 'Delegate every planned targeted check' "$file" | cut -d: -f1)
  review=$(grep -nF 'Run review at checkpoints' "$file" | cut -d: -f1)
  final=$(grep -nF 'Delegate every command under "Final verification intent"' "$file" | cut -d: -f1)
  (( targeted < review && review < final )) || fail "house-apply verification order is invalid"
  printf 'apply: PASS\n'
}

case "$mode" in
  bootstrap) bootstrap ;;
  runner) runner ;;
  apply) apply ;;
  all) bootstrap; runner; apply ;;
  *) fail "usage: $0 bootstrap|runner|apply|all" ;;
esac
