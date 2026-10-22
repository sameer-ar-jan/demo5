#!/usr/bin/env bash
# Builds the site on Node 12 (required by package.json "engines") with Yarn 1,
# even in environments where neither is the default on PATH.
set -euo pipefail

# Switch to an installed Node 12 when the active Node is a different major.
if [[ "$(node -p 'process.versions.node.split(".")[0]')" != "12" ]]; then
  for dir in "${NVM_DIR:-$HOME/.nvm}"/versions/node/v12.*/bin; do
    if [[ -x "$dir/node" ]]; then
      export PATH="$dir:$PATH"
      break
    fi
  done
fi

# Fall back to a pinned Yarn via npx when no global yarn is available.
if command -v yarn >/dev/null 2>&1; then
  YARN=(yarn)
else
  YARN=(npx -p yarn@1.22.22 yarn)
fi

if [[ ! -d node_modules ]]; then
  "${YARN[@]}" install --frozen-lockfile
fi

"${YARN[@]}" run build
