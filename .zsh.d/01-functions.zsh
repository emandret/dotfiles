jwt_decode() {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}

kubectl_get_all() {
  local namespaced='true'
  local resources
  local args=()

  for arg in "$@"; do
    case "$arg" in
      --namespaced | --namespaced='true') namespaced='true' ;;
      --namespaced='false') namespaced='false' ;;
      *) args+=("$arg") ;;
    esac
  done

  resources="$(kubectl api-resources --verbs=list --namespaced=$namespaced -oname | paste -sd, -)" || return 1
  kubectl get "$resources" --show-kind --ignore-not-found "${args[@]}"
}

kubectl_get_events() {
  local args=(
    --all-namespaces
    --sort-by=.lastTimestamp
  )

  if [[ $# -gt 0 ]]; then
    args+=(--field-selector=involvedObject.name="$1" "${@:2}")
  fi

  kubectl get events "${args[@]}"
}

git_worktree_clone() {
  local url="$1"
  local dir="${2:-}"

  if [[ -z "$url" ]]; then
    echo "Usage: $0 <repository> [<directory>]" >&2
    return 1
  fi

  if [[ -z "$dir" ]]; then
    dir="${url##*/}"
    dir="${dir%.git}"
  fi

  if [[ -e "$dir" ]]; then
    echo "Error: $dir already exists" >&2
    return 1
  fi

  mkdir -p "$dir" || return 1

  git clone --bare "$url" "$dir/repo.git" || {
    echo "Error: could not clone $url" >&2
    rm -rf "$dir"
    return 1
  }

  git --git-dir="$dir/repo.git" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

  git --git-dir="$dir/repo.git" fetch origin --prune >/dev/null 2>&1 || {
    echo "Error: failed to fetch with --prune" >&2
    return 1
  }

  local default_branch
  default_branch="$(git --git-dir="$dir/repo.git" symbolic-ref -q --short HEAD 2>/dev/null)"

  git --git-dir="$dir/repo.git" branch --set-upstream-to="origin/$default_branch" "$default_branch" || true

  local safe_branch="${default_branch//[^a-zA-Z0-9_-]/_}"
  local worktree="$dir/$safe_branch"

  git --git-dir="$dir/repo.git" worktree add "$worktree" "$default_branch" || {
    echo "Error: could not create worktree $worktree" >&2
    rm -rf "$dir"
    return 1
  }

  cd "$worktree"
}

git_worktree_checkout() {
  local branch="$1"

  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf not found" >&2
    return 1
  fi

  local repo
  if ! repo="$(git rev-parse --git-common-dir)"; then
    echo "Error: not a git repository" >&2
    return 1
  fi

  local project_root
  project_root="$(readlink -f "$repo/..")"

  local default_branch
  default_branch="$(git --git-dir="$repo" symbolic-ref -q --short HEAD 2>/dev/null)"

  git --git-dir="$repo" fetch origin --prune >/dev/null 2>&1 || {
    echo "Error: failed to fetch with --prune" >&2
    return 1
  }

  git --git-dir="$repo" worktree prune >/dev/null 2>&1 || {
    echo "Error: failed to prune stale worktree information" >&2
    return 1
  }

  if [[ -z "$branch" ]]; then
    local selected
    selected="$(
      git --git-dir="$repo" for-each-ref \
        --format='%(refname:short)' refs/heads |
        sort -u |
        fzf --prompt='branch> ' --height=40% --reverse
    )" || return 1
    branch="${selected#origin/}"
  fi

  local safe_branch="${branch//[^a-zA-Z0-9_-]/_}"
  local worktree="$project_root/$safe_branch"

  if [[ -d "$worktree" && -n "$(ls -A "$worktree" 2>/dev/null)" ]]; then
    if ! git -C "$worktree" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      echo "Error: $worktree is not empty and is not a worktree" >&2
      return 1
    fi

    local worktree_branch
    worktree_branch="$(git -C "$worktree" symbolic-ref -q --short HEAD 2>/dev/null)"

    if [[ "$branch" != "$worktree_branch" ]]; then
      echo "Error: $worktree must be a worktree associated with branch $branch" >&2
      return 1
    fi

    cd "$worktree"
    return
  fi

  if ! git --git-dir="$repo" show-ref --verify -q "refs/heads/$branch"; then
    local start_point="$default_branch"

    if git --git-dir="$repo" show-ref --verify -q "refs/remotes/origin/$branch"; then
      start_point="origin/$branch"
    elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      start_point="$(git symbolic-ref -q --short HEAD 2>/dev/null)"
    fi

    echo "Creating new branch $branch from $start_point"
    git --git-dir="$repo" branch "$branch" "$start_point" || return 1
  fi

  git --git-dir="$repo" worktree add "$worktree" "$branch" || return 1

  cd "$worktree"
}

git_worktree_remove() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: $0 <branch>" >&2
    return 1
  fi

  local repo
  if ! repo="$(git rev-parse --git-common-dir)"; then
    echo "Error: not a git repository" >&2
    return 1
  fi

  git --git-dir="$repo" worktree prune >/dev/null 2>&1 || {
    echo "Error: failed to prune stale worktree information" >&2
    return 1
  }

  local worktree
  worktree="$(
    git --git-dir="$repo" worktree list --porcelain |
      awk -v branch="refs/heads/$branch" \
        '/^worktree/ { wt=$2 }; /^branch/ && $2 == branch { print wt; exit }'
  )"

  if [[ -z "$worktree" ]]; then
    echo "No worktree found for branch $branch" >&2
    return 1
  fi

  if [[ "$PWD" == "$worktree" || "$PWD" == "${worktree%%/}/"* ]]; then
    echo "Refusing to remove current worktree on branch $branch"
    return 1
  fi

  echo "Removing worktree $worktree"
  git --git-dir="$repo" worktree remove "$worktree" || return 1

  if git --git-dir="$repo" show-ref --verify -q "refs/heads/$branch"; then
    git --git-dir="$repo" branch -D "$branch" || return 1
  fi
}

git_worktree_prune() {
  local repo
  if ! repo="$(git rev-parse --git-common-dir)"; then
    echo "Error: not a git repository" >&2
    return 1
  fi

  git --git-dir="$repo" fetch origin --prune >/dev/null 2>&1 || {
    echo "Error: failed to fetch with --prune" >&2
    return 1
  }

  while IFS='' read -r branch; do
    [[ -n "$branch" ]] && git_worktree_remove "$branch"
  done < <(
    git --git-dir="$repo" for-each-ref \
      --format='%(refname:short) %(upstream:track)' refs/heads |
      awk '$2 == "[gone]" { print $1 }'
  )
}
