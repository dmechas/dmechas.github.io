#!/usr/bin/env bash
# Usage: scripts/new-note.sh "Note title" < body.html
# Reads the note body (HTML fragment) from stdin, creates notes/<slug>.html
# and adds an entry at the top of notes/index.html.
set -euo pipefail

title="${1:?usage: new-note.sh \"Title\" < body.html}"
root="$(cd "$(dirname "$0")/.." && pwd)"
date_iso="$(date +%F)"
date_human="$(date +"%b %-d, %Y")"
slug="$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
[ -n "$slug" ] || { echo "title produced an empty slug" >&2; exit 1; }
file="$root/notes/$slug.html"
[ ! -e "$file" ] || { echo "notes/$slug.html already exists" >&2; exit 1; }

body="$(cat)"
esc_title="$(printf '%s' "$title" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')"

cat > "$file" <<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$esc_title · dmechas</title>
  <link rel="stylesheet" href="../style.css">
</head>
<body>
  <main class="wrap">
    <a class="back" href="./">← All notes</a>
    <article class="article">
      <h1>$esc_title</h1>
      <time datetime="$date_iso">$date_human</time>
$body
    </article>
  </main>
</body>
</html>
HTML

entry="      <li>
        <a href=\"$slug.html\">
          <span class=\"title\">$esc_title</span>
          <time datetime=\"$date_iso\">$date_human</time>
        </a>
      </li>"
tmp="$(mktemp)"
awk -v entry="$entry" '{print} /<ul class="notes">/ && !done {print entry; done=1}' "$root/notes/index.html" > "$tmp"
mv "$tmp" "$root/notes/index.html"
echo "notes/$slug.html"
