#!/bin/bash
# Singularity App API wrapper
# Usage: singularity.sh <command> [args...]

TOKEN=$(cat ~/.openclaw/secrets/singularity-api-token)
BASE="https://api.singularity-app.com/v2"
AUTH="Authorization: Bearer $TOKEN"

case "$1" in
  projects)
    curl -s -H "$AUTH" "$BASE/project" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for p in data['projects']:
    emoji = chr(int(p.get('emoji',''), 16)) if p.get('emoji') else ' '
    print(f\"{emoji} {p['title']} | {p['id']}\")"
    ;;

  tasks)
    # tasks [project_id] [status: active|completed|deleted]
    STATUS="${3:-active}"
    URL="$BASE/task?status=$STATUS"
    [ -n "$2" ] && URL="$URL&projectId=$2"
    curl -s -H "$AUTH" "$URL" | python3 -c "
import json, sys
data = json.load(sys.stdin)
tasks = data.get('tasks', [])
print(f'Tasks ({len(tasks)}):')
for t in tasks:
    pri = '🔴' if t.get('priority') == 3 else '🟡' if t.get('priority') == 2 else '⚪'
    start = (t.get('start') or '')[:10]
    proj = t.get('projectId', '')[:12]
    print(f\"{pri} [{start}] {t['title'][:80]} | {t['id']}\")"
    ;;

  add)
    # add "title" [project_id] [date YYYY-MM-DD] [priority 0-3]
    TITLE="$2"
    PROJECT="$3"
    DATE="$4"
    PRIORITY="${5:-0}"
    BODY="{\"title\":\"$TITLE\""
    [ -n "$PROJECT" ] && BODY="$BODY,\"projectId\":\"$PROJECT\""
    [ -n "$DATE" ] && BODY="$BODY,\"start\":\"$DATE\""
    [ "$PRIORITY" != "0" ] && BODY="$BODY,\"priority\":$PRIORITY"
    BODY="$BODY}"
    curl -s -X POST -H "$AUTH" -H "Content-Type: application/json" -d "$BODY" "$BASE/task" | python3 -c "
import json, sys
t = json.load(sys.stdin)
print(f\"✅ Created: {t.get('title','')} | {t.get('id','')}\")"
    ;;

  complete)
    # complete <task_id>
    curl -s -X PATCH -H "$AUTH" -H "Content-Type: application/json" -d '{"completedDate":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' "$BASE/task/$2" | python3 -c "
import json, sys
t = json.load(sys.stdin)
print(f\"✅ Completed: {t.get('title','')}\")"
    ;;

  tags)
    curl -s -H "$AUTH" "$BASE/tag" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('tags', []):
    print(f\"{t['title']} | {t['id']}\")"
    ;;

  habits)
    curl -s -H "$AUTH" "$BASE/habit" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for h in data.get('habits', []):
    print(f\"{h['title']} | {h['id']}\")"
    ;;

  raw)
    # raw GET /endpoint or raw POST /endpoint '{"json":"body"}'
    METHOD="${2:-GET}"
    ENDPOINT="$3"
    if [ "$METHOD" = "POST" ] || [ "$METHOD" = "PATCH" ]; then
      curl -s -X "$METHOD" -H "$AUTH" -H "Content-Type: application/json" -d "$4" "$BASE$ENDPOINT"
    else
      curl -s -H "$AUTH" "$BASE$ENDPOINT"
    fi
    ;;

  *)
    echo "Usage: singularity.sh <command>"
    echo "  projects          - list projects"
    echo "  tasks [proj_id]   - list tasks"
    echo "  add \"title\" [proj] [date] [priority]"
    echo "  complete <task_id>"
    echo "  tags              - list tags"
    echo "  habits            - list habits"
    echo "  raw METHOD /path [body]"
    ;;
esac
