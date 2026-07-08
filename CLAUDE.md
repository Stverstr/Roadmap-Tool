# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Roadmap Studio: a project-roadmap/storyboard tool built as **self-contained static HTML files** (inline CSS + JS, no build step, no framework, no package.json, no tests). Data lives in **Supabase** (project `uvodxrrxsxnjlinqrjlw`), accessed directly from the browser via the `@supabase/supabase-js@2` CDN script with the anon key hardcoded in each page.

All UI text, comments, and user communication are in **Dutch** — keep new code/UI Dutch too.

## Running & deploying

- No build/lint/test commands. Open a page directly in the browser (`open index.html`) — Supabase calls work from `file://`.
- Deployed on Netlify; `netlify.toml` redirects everything to `/index.html`. Git remote: `github.com/Stverstr/Roadmap-Tool`.
- The user commits/pushes via GitHub Desktop. `fix-and-push.sh` only removes stale `.git/*.lock` files.
- `Prompts.txt` is auto-appended by a UserPromptSubmit hook — never edit it manually.
- To verify layout changes headlessly: `"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --window-size=1200,800 --virtual-time-budget=2000 --dump-dom "file://…"`.

## Pages and how they relate

- **index.html** — the live app ("Roadmap Studio", ~9k lines). Tabs: Setup (projects, streams/tracks, subcategories, phases, milestones, strategic goals), **Storyboard** (the grid the user calls "storymap"), Timeline, and governance meetings. Everything (auth, state, rendering) is in this one file.
- **activity-detail.html** — detail page for one roadmap item, opened as `activity-detail.html?id=<item>` from the storyboard. After saving it posts `BroadcastChannel('roadmap_refresh')` → `{type:'item_updated'}`; index.html listens and reloads `roadmap_items` so the storyboard refreshes automatically.
- **meeting-view.html** — read-only meeting/agenda view, opened as `meeting-view.html?date_id=<id>` from the governance section.
- **roadmap-studio.html** — an *older predecessor* of index.html. Don't add features here unless asked; index.html is the live app.
- **project-hub.html**, **health-cg-hub.html**, **governance-slide11.html** — standalone one-off pages, not linked from the main app.

## Auth

No Supabase Auth. index.html uses a master password: SHA-256 hash compared against `MASTER_HASH`, success stores `rs_auth=1` in `sessionStorage` and uses the hardcoded `FIXED_USER`. Other pages have their own lightweight gates.

## Data model (Supabase tables)

`projects` → `tracks` (streams, colored columns) → `subcategories` (sub-columns); `phases` (storyboard rows, with dates); `roadmap_items` (cards; FK to track/subcategory/phase — items missing any valid link land in the Backlog row); `item_status_history`; `milestones` + `milestone_types`; `strategic_changes`; activity detail tables (`activity_tasks`, `activity_stakeholders`, `activity_documents`); governance (`gov_rm_meetings`, `gov_rm_meeting_dates`, `gov_rm_agenda_items`); strategy tables (`hefbomen`, `roadmap_item_hefbomen`, `lt_doelstellingen`, `kt_targets`, `inspanningsverbintenissen`).

## Storyboard rendering (index.html)

`renderStoryboard()` builds one CSS grid (`.sb-inner-grid`) as an HTML string: column 1 is a sticky 140px label column, then one column per track/subcategory. Column widths use CSS container-query units — `.sb-wrap` is `container-type:inline-size` and each column is `minmax(max(90px,(100cqw - 142px)/7), 1fr)` so **at least 7 columns fit on screen** (extra columns scroll horizontally); keep this invariant when touching storyboard layout. Rows are phases plus a spanning Backlog row. After nearly every mutation the code calls `renderStoryboard(); renderTimeline();` — follow that pattern.
