import 'package:flutter_test/flutter_test.dart';
import 'package:reel_match/app_state.dart';
import 'package:reel_match/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('recommendations rank matches and flag runtime limits', () {
    final state = AppState();
    state.viewers = List.generate(
      3,
      (_) => Viewer(name: 'Viewer', genres: {'Animation'}, maxMinutes: 110),
    );
    final matches = state.rankedMovies();
    expect(matches.length, 12);
    expect(matches.first.movie.title, 'Coco');
    expect(matches.first.groupScore, 50);
    expect(
      matches
          .where((match) => match.fitsEveryone)
          .every((match) => match.movie.minutes <= 110),
      isTrue,
    );
  });

  test('search matches title, genre, and year and ignores case', () {
    final state = AppState();
    List<String> titles(String query) =>
        state.searchMovies(query).map((match) => match.movie.title).toList();

    expect(state.searchMovies(''), hasLength(12));
    expect(state.searchMovies('   '), hasLength(12));
    expect(titles('COCO'), ['Coco']);
    expect(titles('  knives '), ['Knives Out']);
    expect(
      state
          .searchMovies('animation')
          .every((match) => match.movie.genres.contains('Animation')),
      isTrue,
    );
    expect(state.searchMovies('animation'), hasLength(4));
    expect(
      titles('2014'),
      unorderedEquals(['Interstellar', 'The Grand Budapest Hotel']),
    );
    expect(state.searchMovies('no such movie'), isEmpty);
  });

  test('search keeps the group ranking order', () {
    final state = AppState();
    final ranked = state.rankedMovies().map((match) => match.movie.id).toList();
    final found = state.searchMovies('e').map((match) => match.movie.id);
    expect(found, isNotEmpty);
    expect(found, ranked.where(found.contains));
  });

  test('clearing votes keeps the shortlist; a new night clears both', () {
    final state = AppState();
    final ranked = state.rankedMovies();
    final first = ranked[0].movie.id;
    final second = ranked[1].movie.id;
    state.toggleShortlist(first);
    state.toggleShortlist(second);
    state.castVote(0, first);
    state.castVote(1, second);

    state.clearVotes();
    expect(state.votes, hasLength(state.viewers.length));
    expect(state.votes, everyElement(isNull));
    expect(state.shortlist, {first, second});

    state.castVote(2, first);
    state.startNewNight();
    expect(state.shortlist, isEmpty);
    expect(state.votes, hasLength(state.viewers.length));
    expect(state.votes, everyElement(isNull));

    // Votes stay aligned with the viewer list after a reset.
    state.addViewer();
    expect(state.votes, hasLength(4));
  });
}
