# ReelMatch

ReelMatch is a local movie-night web app built for groups of three. Each viewer enters their name, favorite genres, and preferred maximum runtime. The app compares those preferences against a built-in movie catalog and ranks the best matches for the whole group.

## Features

- Three editable viewer profiles
- Genre and runtime preferences
- Group movie recommendations with individual match scores
- Runtime filtering
- A shared movie shortlist
- One vote per viewer
- Live vote totals with winner and tie states
- JSON export of the movie-night results
- Responsive layouts for desktop and mobile
- Browser storage that preserves preferences, shortlists, and votes after a refresh

## How recommendations work

Each viewer receives a score for every movie based on how many of that movie's genres match their selected genres. ReelMatch averages the three viewer scores to produce the group match score.

Movies that meet all three runtime limits appear first. The Discover page shows why each movie matched by displaying the group score and each viewer's score. ReelMatch uses a transparent, rule-based recommendation system rather than an external AI service.

## Running the app

Open `index.html` in a web browser. ReelMatch does not require installation, an account, an API key, or a build process.

For a stable local address, you can optionally start a simple server from the project folder:

```sh
python -m http.server 8000
```

Then open `http://localhost:8000`.

## Data and limitations

ReelMatch stores data in the current browser using local storage. It is designed as a pass-the-device experience, so it does not synchronize between devices. Clearing browser data removes saved preferences and votes.

The app includes a curated catalog of 12 movies. It does not check streaming availability or download external posters. Movie artwork is generated with CSS.

