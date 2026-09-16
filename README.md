# ReelMatch
A local movie-night web app: three viewers set genre preferences and runtime limits, discover ranked movies, shortlist candidates, and vote on a winner.

## Run
Open index.html directly in a browser. No packages, API keys, or build required. For a stable storage origin, optionally run `python -m http.server 8000` and visit http://localhost:8000.

## Three-person class project
| Student | Feature | Files | Suggested commits |
| --- | --- | --- | --- |
| 1 | Preferences | src/preferences/preferences.js, preferences.css, README.md | 3 |
| 2 | Recommendation and discovery | src/discover/discover.js, discover.css, README.md | 3 |
| 3 | Voting and results | src/voting/voting.js, voting.css, README.md | 3 |

Each student owns exactly three files, with comparable feature scope. The folder READMEs provide three meaningful improvement commits each. Shared foundation: index.html, src/app.js, src/store.js, src/styles.css, and this guide. Agree before changing shared contracts. File and commit counts are a starting point for balancing effort.

## How recommendations work
For each movie, each viewer gets a score: number of movie genres they selected divided by the movie's genre count. The group score is the rounded average of the three scores. Movies meeting all runtime limits rank first; remaining ties sort alphabetically. Discover defaults to showing movies that meet everyone's limit.

The recommender is rule-based, not a trained AI or live LLM. This is a software project suitable for developing with AI tools; it does not pretend to call an AI service. A possible later class extension is a backend semantic recommender with explainable results. Never put an API key in browser JavaScript.

The 12-film catalog is built in. There are no streaming availability claims, external services, or poster downloads; artwork is abstract CSS.

## Local storage
Names, preferences, shortlist, and votes persist in this browser under reelmatch-v1. This is a pass-the-device demo, not multi-device synchronization. Clearing browser data removes the saved night. Export downloads a JSON summary; importing is not implemented. Votes can be changed, and removing a shortlisted movie clears votes for it.

## GitHub contributions
The app stays local; no repository, remote, or commits were created. When ready:
1. One member creates a GitHub repository and commits the starter app.
2. Each member clones it and creates codex/preferences, codex/discover, or codex/voting.
3. Each member works within their feature folder and commits their own real changes using the folder's three-step plan.
4. Open pull requests and rotate reviews. Coordinate shared-store changes in advance.

Do not fabricate authorship or split completed code into pretend contributions. Use the working starter for real improvements, or rebuild assigned features with your own implementation if your class requires it.

## Manual acceptance checks
- Save three names and genre selections; blank names or no genres show a validation message.
- Set runtime limits and verify Discover filters movies.
- Shortlist movies and cast three votes; verify both a majority winner and a three-way tie.
- Change votes and remove a voted-for movie; tally updates and affected votes clear.
- Reload and verify persistence; export and inspect the JSON.
- Check keyboard navigation and mobile-width layouts.
