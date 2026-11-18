---
name: note
description: Publish a learning/note to dmechas.github.io/notes from any project. Use when the user says "/note", "add a note", "save this as a note", or wants to record what was learned in the current session.
---

# note

Publishes a note to https://dmechas.github.io/notes/ (repo `dmechas/dmechas.github.io`), no matter which repo you're currently in.

## Steps

1. Decide the title and content. If the user gave a topic/args, use it; otherwise summarize the key learnings from the current session. Write a concise, useful note (what, why, a code snippet if relevant). Never include secrets, private repo names/code, or employer-confidential details — this site is public. If unsure, show the draft and ask first.
2. Write the body as an HTML fragment (no `<html>`/`<body>`): use `<h2>`, `<p>`, `<ul>`, `<code>`, `<pre><code>`. Escape `<`, `>`, `&` in code.
3. Clone and run the script (use a temp dir, never the current project):
   ```bash
   d=$(mktemp -d) && git clone -q https://github.com/dmechas/dmechas.github.io.git "$d" && cd "$d"
   cat <<'BODY' | scripts/new-note.sh "<Title>"
   <h2>...</h2>
   <p>...</p>
   BODY
   git add -A && git commit -q -m "Add note: <Title>" && GIT_TERMINAL_PROMPT=0 git push origin main
   ```
   Add the attribution line required by the session to the commit message if one is specified.
4. Report the URL: `https://dmechas.github.io/notes/<slug>.html` (slug is printed by the script; live in ~1–2 min).

If the push fails with auth errors, tell the user to run `sbx secret set github --sandbox $SANDBOX_NAME -t "$(gh auth token)"` on their host.
