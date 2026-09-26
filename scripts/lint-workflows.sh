#!/bin/bash
# Catch what `yaml.safe_load` silently tolerates and GitHub rejects outright.
# A duplicate key costs a whole run: GitHub reports only "this run likely failed
# because of a workflow file issue", creates no jobs, and gives no line number.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - "$@" <<'PY'
import sys, glob, yaml
bad = 0
class L(yaml.SafeLoader): pass
def m(loader, node, deep=False):
    global bad
    seen = set()
    for k, _ in node.value:
        key = loader.construct_object(k, deep=deep)
        if key in seen:
            print(f"  DUPLICATE KEY '{key}' line {k.start_mark.line+1}"); bad += 1
        seen.add(key)
    return yaml.SafeLoader.construct_mapping(loader, node, deep)
L.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, m)
for f in sorted(glob.glob(".github/workflows/*.yml")):
    print(f)
    try: yaml.load(open(f), L)
    except Exception as e: print(f"  PARSE ERROR: {e}"); bad += 1
sys.exit(1 if bad else 0)
PY
echo "workflows ok"
