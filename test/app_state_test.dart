import 'package:flutter_test/flutter_test.dart';
import 'package:reel_match/app_state.dart';
import 'package:reel_match/models.dart';

void main() {
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
}
