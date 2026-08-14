#!/bin/bash
# PreToolUse hook: raw/ sources are immutable once saved.
# Blocks Edit/Write on files that already exist under raw/. Creating new
# files is allowed (that's how /research archives sources). Deletion is
# not covered here: /retract_source removes sources deliberately via rm.
input=$(cat)
file_path=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)
[ -z "$file_path" ] && exit 0
case "$file_path" in
  "$CLAUDE_PROJECT_DIR/raw/"*)
    if [ -e "$file_path" ]; then
      echo "Blocked: files under raw/ are immutable once saved. To remove a bad source, use /retract_source." >&2
      exit 2
    fi
    ;;
esac
exit 0
