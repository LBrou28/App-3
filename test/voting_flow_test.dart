import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reel_match/main.dart';
import 'package:reel_match/app_state.dart';
import 'package:reel_match/features/voting.dart';

void main() {
  testWidgets(
    'shortlisting makes movies available to every voter and removal clears votes',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(const ReelMatchApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();
      final add = find.text('Add to the vote').first;
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pumpAndSettle();
      expect(find.text('Shortlisted · Remove'), findsOneWidget);

      await tester.tap(find.text('Vote'));
      await tester.pumpAndSettle();
      final state = ReelScope.of(tester.element(find.byType(VotingScreen)));
      final selectedId = state.shortlist.single;
      final title = state.movieById(selectedId)!.title;
      final ballots = find.byType(DropdownButtonFormField<String?>);
      expect(ballots, findsNWidgets(state.viewers.length));
      for (var i = 0; i < state.viewers.length; i++) {
        await tester.ensureVisible(ballots.at(i));
        await tester.pumpAndSettle();
        await tester.tap(ballots.at(i));
        await tester.pumpAndSettle();
        await tester.tap(find.text(title).last);
        await tester.pumpAndSettle();
      }
      expect(state.votes, everyElement(selectedId));
      await tester.ensureVisible(find.text('Tonight’s pick: $title'));
      expect(find.text('Tonight’s pick: $title'), findsOneWidget);

      // Keep another candidate so existing ballot controls must reset correctly.
      state.toggleShortlist(
        state
            .rankedMovies()
            .firstWhere((m) => m.movie.id != selectedId)
            .movie
            .id,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();
      final selectedCard = find
          .ancestor(of: find.text(title), matching: find.byType(Card))
          .first;
      final remove = find.descendant(
        of: selectedCard,
        matching: find.text('Shortlisted · Remove'),
      );
      await tester.ensureVisible(remove);
      await tester.pumpAndSettle();
      await tester.tap(remove);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vote'));
      await tester.pumpAndSettle();
      expect(state.votes, everyElement(isNull));
      expect(tester.takeException(), isNull);
      expect(find.text('Not voted yet'), findsNWidgets(state.viewers.length));
    },
  );
}
