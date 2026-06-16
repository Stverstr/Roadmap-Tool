#!/bin/bash
cd "/Users/stijnverstraete/Documents/Claude/Projects/Roadmap Tool"

echo "🔓 Lock-bestanden verwijderen..."
rm -f .git/HEAD.lock .git/index.lock

echo "📦 Wijzigingen committen..."
git add roadmap-studio.html project-hub.html
git commit -m "Fix storyboard scroll + backlog filter" 2>/dev/null || echo "(niets te committen)"

echo "🚀 Pushen naar GitHub..."
git push

echo "✅ Klaar! Refresh je browser met Cmd+Shift+R"
