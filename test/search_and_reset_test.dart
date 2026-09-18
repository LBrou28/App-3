import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reel_match/app_state.dart';
import 'package:reel_match/features/preferences.dart';
import 'package:reel_match/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('search narrows Discover to matching movies', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ReelMatchApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();

    final search = find.widgetWithText(TextField, 'Search movies');
    expect(search, findsOneWidget);
    // Default viewers allow 150 minutes, which hides only Interstellar.
    expect(find.text('11 of 12 movies'), findsOneWidget);

    await tester.enterText(search, 'coco');
    await tester.pumpAndSettle();
    expect(find.text('1 of 12 movies'), findsOneWidget);
    expect(find.text('Coco'), findsOneWidget);
    expect(find.text('Arrival'), findsNothing);

    await tester.enterText(search, 'MYSTERY');
    await tester.pumpAndSettle();
    expect(find.text('4 of 12 movies'), findsOneWidget);

    await tester.enterText(search, 'interstellar');
    await tester.pumpAndSettle();
    expect(find.text('0 of 12 movies'), findsOneWidget);
    expect(
      find.textContaining('No movies match “interstellar”'),
      findsOneWidget,
    );

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('1 of 12 movies'), findsOneWidget);
    expect(find.text('Interstellar'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('12 of 12 movies'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('vote screen can clear votes or start a new night', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ReelMatchApp());
    await tester.pumpAndSettle();

    final state = ReelScope.of(tester.element(find.byType(PreferencesScreen)));
    final ranked = state.rankedMovies();
    final first = ranked[0].movie.id;
    final second = ranked[1].movie.id;
    state.toggleShortlist(first);
    state.toggleShortlist(second);
    state.castVote(0, first);
    state.castVote(1, first);
    await tester.tap(find.text('Vote'));
    await tester.pumpAndSettle();
    expect(find.text('2 of 3 votes are in.'), findsOneWidget);

    Future<void> press(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    // Clearing votes resets ballots but keeps the shortlist.
    await press('Clear votes');
    expect(state.votes, everyElement(isNull));
    expect(state.shortlist, {first, second});
    expect(find.text('The big decision awaits.'), findsOneWidget);
    expect(find.text('Not voted yet'), findsNWidgets(3));
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Clear votes'),
          )
          .onPressed,
      isNull,
    );

    // Cancelling the confirmation changes nothing.
    state.castVote(2, second);
    await tester.pumpAndSettle();
    await press('Start a new night');
    expect(find.text('Start a new movie night?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Start a new movie night?'), findsNothing);
    expect(state.shortlist, {first, second});
    expect(state.votes[2], second);

    // Confirming clears the shortlist and every vote.
    await press('Start a new night');
    await tester.tap(find.text('Start fresh'));
    await tester.pumpAndSettle();
    expect(state.shortlist, isEmpty);
    expect(state.votes, hasLength(state.viewers.length));
    expect(state.votes, everyElement(isNull));
    expect(find.textContaining('Your ballot is empty'), findsOneWidget);
    expect(find.text('Ready for a new movie night.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
