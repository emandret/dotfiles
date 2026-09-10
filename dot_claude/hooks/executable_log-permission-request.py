#!/usr/bin/env python3
"""Log every PermissionRequest event to a JSONL file for later analysis."""

import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local" / "state"))
LOG_FILE = state_home / "claude" / "permissionrequests.jsonl"
LOG_FILE.parent.mkdir(parents=True, exist_ok=True)

data = json.load(sys.stdin)
data["timestamp"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

with LOG_FILE.open("a") as f:
    f.write(json.dumps(data, separators=(",", ":")) + "\n")

sys.exit(0)
