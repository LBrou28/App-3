# Student 1 — Viewer preferences

Own preferences.js, preferences.css, and this README: exactly three files.

Three proposed commits for your own development:
1. Two to five viewers with add/remove controls, editable names, genre controls, and runtime limits.
2. Validation, persistence integration, and responsive styling.
3. Keyboard accessibility, preference reset improvement, and documentation.

Check blank names, no genres, all genres, changed runtimes, reload, and narrow layouts.

Shared API: Reel.state, Reel.save(), Reel.escape(), Reel.movies, Reel.genres, and Reel.rank(). Listen indirectly through the shared render flow. Call Reel.save() after changes. Do not edit other feature folders without coordinating.

Add/remove preserves current form values and removes the last viewer and their vote. Save to persist the group and open Discover. Check both viewer limits and reload with two and five viewers.
