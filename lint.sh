#!/bin/bash
#
# Strips trailing whitespace, normalises every text file to exactly one
# newline at EOF, and (optionally) reformats shell scripts with shfmt --
# using a space before "()" in function definitions, e.g. "fn () {".
#
# Reports non-ASCII characters, empty files, and binary files without
# touching them.
#
# Usage: lint.sh [--check]
#   --check   report what would change and exit 1, modifying nothing

set -eu

cd "$(dirname "$0")"

check_only=0

while (($#)); do
  case "$1" in
    --check) check_only=1 ;;
    -h | --help)
      echo "Usage: $(basename "$0") [--check]"
      echo
      echo "  Strips trailing whitespace and normalises every file to exactly one"
      echo "  newline at EOF. Reformats shell scripts with shfmt. Reports non-ASCII"
      echo "  characters without changing them."
      echo
      echo "  --check  report what would change and exit 1, modifying nothing"
      exit 0
      ;;
    *)
      echo "Error: unknown argument '$1'" >&2
      exit 2
      ;;
  esac
  shift
done

have_shfmt=0
command -v shfmt >/dev/null && have_shfmt=1

if sed --version >/dev/null 2>&1; then
  sed_inplace=(-i)
else
  sed_inplace=(-i '')
fi

list_files () {
  if [[ -d .git ]] && command -v git >/dev/null; then
    git ls-files -z
  else
    find . -type f -not -path './.git/*' -print0
  fi
}

is_binary () {
  ! tr -d '\000' <"$1" | cmp -s - "$1"
}

is_shell_script () {
  local file="$1" first_line
  case "$file" in
    *.sh | *.bash | *.zsh) return 0 ;;
  esac
  IFS= read -r first_line <"$file" || return 1
  case "$first_line" in
    '#!'*/sh | '#!'*/bash | '#!'*/zsh | '#!'*env\ sh | '#!'*env\ bash | '#!'*env\ zsh)
      return 0
      ;;
    *) return 1 ;;
  esac
}

normalise () {
  LC_ALL=C awk '
{ sub(/[[:space:]]+$/, ""); line[NR] = $0 }
END {
last = NR
while (last > 0 && line[last] == "") last--
if (last == 0) { print ""; exit }
for (i = 1; i <= last; i++) print line[i]
}
' "$1"
}

format_shell () {
  local file="$1" tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/lint.XXXXXX")"
  cp "$file" "$tmp"

  shfmt -w -i 2 -ci "$tmp"
  sed "${sed_inplace[@]}" -E \
    's/^([[:space:]]*)([A-Za-z_][A-Za-z0-9_]*)\(\)/\1\2 ()/' "$tmp"

  if cmp -s "$tmp" "$file"; then
    rm -f "$tmp"
    return 1
  fi

  if ((check_only)); then
    rm -f "$tmp"
  else
    cat "$tmp" >"$file"
    rm -f "$tmp"
  fi
  return 0
}

describe_unicode () {
  local file="$1"

  if command -v perl >/dev/null; then
    perl -CSD -ne '
no warnings "utf8";
while (/([^\x00-\x7F])/g) { $seen{ord($1)}++; $lines{$.} = 1 }
END {
exit unless %seen;
printf "%d line(s), %d distinct:", scalar(keys %lines), scalar(keys %seen);
printf " U+%04X", $_ for sort { $a <=> $b } keys %seen;
print "";
}
' "$file"
  else
    local n
    n="$(LC_ALL=C grep -c $'[\x80-\xff]' "$file" || true)"
    ((n > 0)) && printf '%d line(s)\n' "$n"
  fi
}

empty=()
binary=()
unicode=()
changed=()
shell_files=()
shell_formatted=()

while IFS= read -r -d '' file; do
  [[ -f "$file" ]] || continue

  if [[ ! -s "$file" ]]; then
    empty+=("$file")
    continue
  fi

  if is_binary "$file"; then
    binary+=("$file")
    continue
  fi

  desc="$(describe_unicode "$file")"
  if [[ -n "$desc" ]]; then
    unicode+=("${file}|${desc}")
  fi

  tmp="$(mktemp "${TMPDIR:-/tmp}/lint.XXXXXX")"
  normalise "$file" >"$tmp"

  if cmp -s "$tmp" "$file"; then
    rm -f "$tmp"
  else
    changed+=("$file")
    if ((check_only)); then
      rm -f "$tmp"
    else
      cat "$tmp" >"$file"
      rm -f "$tmp"
    fi
  fi

  if ((have_shfmt)) && is_shell_script "$file"; then
    shell_files+=("$file")
  fi
done < <(list_files)

if ((${#unicode[@]})); then
  echo "Non-ASCII characters (reported only, not modified):"
  for entry in "${unicode[@]}"; do
    printf '  %-16s %s\n' "${entry%%|*}" "${entry#*|}"
  done
  echo
fi

if ((${#empty[@]})); then
  echo "Empty files (left alone -- no EOF line to normalise):"
  printf '  %s\n' "${empty[@]}"
  echo
fi

if ((${#binary[@]})); then
  echo "Binary files (skipped):"
  printf '  %s\n' "${binary[@]}"
  echo
fi

if ((have_shfmt)); then
  for file in "${shell_files[@]}"; do
    format_shell "$file" && shell_formatted+=("$file")
  done
else
  echo "shfmt not found -- skipping shell-script formatting."
  echo
fi

if ((${#shell_formatted[@]})); then
  if ((check_only)); then
    echo "Would reformat ${#shell_formatted[@]} shell script(s) with shfmt:"
  else
    echo "Reformatted ${#shell_formatted[@]} shell script(s) with shfmt:"
  fi
  printf '  %s\n' "${shell_formatted[@]}"
  echo
fi

if ((${#changed[@]} == 0 && ${#shell_formatted[@]} == 0)); then
  echo "All files clean: no trailing whitespace, exactly one newline at EOF."
  exit 0
fi

if ((check_only)); then
  if ((${#changed[@]})); then
    echo "Would fix ${#changed[@]} file(s) (whitespace/EOF):"
    printf '  %s\n' "${changed[@]}"
  fi
  exit 1
fi

if ((${#changed[@]})); then
  echo "Fixed ${#changed[@]} file(s) (whitespace/EOF):"
  printf '  %s\n' "${changed[@]}"
fi
