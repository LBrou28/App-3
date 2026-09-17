# Student 3 — Voting and results

Own voting.js, voting.css, and this README: exactly three files.

Three proposed commits for your own development:
1. One editable ballot per viewer and live tallies.
2. Winner/tie states, JSON export, and responsive styling.
3. Add a clear-votes control, keyboard review, and documentation.

Check no shortlist, incomplete voting, unanimous winner, two-vote majority, three-way tie, removed candidates, and export.

Shared API: Reel.state, Reel.save(), Reel.escape(), Reel.movies, Reel.genres, and Reel.rank(). Listen indirectly through the shared render flow. Call Reel.save() after changes. Do not edit other feature folders without coordinating.

Supports 2–5 viewers: one ballot per person, dynamic progress and vote totals, and results after everyone has voted. The ballot grid wraps to fit available space. Edit viewers returns to preferences. Check incomplete ballots, winners, ties, and changing group size across all supported counts.
