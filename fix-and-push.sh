#!/bin/bash
# Verwijdert lock-bestanden zodat GitHub Desktop weer werkt
cd "/Users/stijnverstraete/Documents/Claude/Projects/Roadmap Tool"
rm -f .git/HEAD.lock .git/index.lock
echo "✅ Lock-bestanden verwijderd. Commit en push nu via GitHub Desktop."
