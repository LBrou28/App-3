# ReelMatch

ReelMatch is a Flutter movie-night app for groups of two to five. Each viewer chooses favorite genres and a maximum runtime. The app ranks a built-in movie catalog using all viewer preference profiles, lets the group shortlist candidates, and provides one vote per viewer with live winner and tie results.

## Features

- Two to five editable viewer profiles
- Explainable group and individual match scores
- Runtime filtering
- Catalog search by title, genre, or release year
- Shared movie shortlist
- Group voting with live results
- One-tap reset: clear votes only, or start a new night that also clears the shortlist
- Local Android device persistence
- Responsive Material 3 interface

## Recommendation method

Each viewer's score is the percentage of a movie's genres that match their selected genres. ReelMatch averages all viewer scores into the group score. Movies that meet every runtime limit rank first. This is a transparent rule-based recommender and does not require an external AI service.

## Open in Android Studio

1. Install the Flutter and Dart plugins in Android Studio.
2. Select **Open** and choose this project folder.
3. Let Gradle and Flutter finish syncing.
4. Start an Android emulator or connect an Android phone with USB debugging enabled.
5. Select the device and run `lib/main.dart`.

## Command line

```sh
flutter pub get
flutter run
```

Run checks with:

```sh
flutter analyze
flutter test
```

## Project structure

- `lib/features/preferences.dart`: viewer profiles, genres, and runtime limits
- `lib/features/discover.dart`: ranked recommendations, search, and shortlist
- `lib/features/voting.dart`: ballots, live results, and reset controls
- `lib/app_state.dart`: shared state and device persistence
- `lib/catalog.dart`: built-in movie catalog

Preferences, shortlisted movies, and votes are stored on the device with `shared_preferences`. The catalog contains 12 movies and does not claim streaming availability.
