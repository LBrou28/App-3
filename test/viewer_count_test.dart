import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reel_match/app_state.dart';
import 'package:reel_match/main.dart';
import 'package:reel_match/models.dart';
import 'package:reel_match/features/preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final count in [2, 3, 4, 5]) {
    test(
      'Saves $count viewers, aligned votes, and correct matching scores',
      () async {
        SharedPreferences.setMockInitialValues({});
        final s = AppState();
        while (s.viewers.length < count) {
          s.addViewer();
        }
        while (s.viewers.length > count) {
          s.removeLastViewer();
        }
        for (var i = 0; i < count; i++) {
          s.updateViewer(
            i,
            Viewer(name: 'Person $i', genres: {'Animation'}, maxMinutes: 110),
          );
        }
        expect(s.rankedMovies().first.groupScore, 50);
        final id = s.rankedMovies().first.movie.id;
        s.toggleShortlist(id);
        s.castVote(count - 1, id);
        await s.save();
        final restored = AppState();
        await restored.load();
        expect(restored.viewers.length, count);
        expect(restored.votes.length, count);
        expect(restored.votes.last, id);
        restored.removeLastViewer();
        expect(restored.viewers.length, count == 2 ? 2 : count - 1);
        expect(restored.votes.length, restored.viewers.length);
        if (count > 2) expect(restored.votes, everyElement(isNull));
      },
    );
  }
  testWidgets('Viewer controls enforce 2–5 and voting uses the group size', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ReelMatchApp());
    await tester.pumpAndSettle();
    Future<void> press(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    await tester.enterText(find.byType(TextField).first, 'My draft');
    await press('Add viewer');
    await press('Add viewer');
    expect(find.text('5 viewers'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Add viewer'))
          .onPressed,
      isNull,
    );
    expect(find.text('My draft'), findsOneWidget);
    final s = ReelScope.of(tester.element(find.byType(PreferencesScreen)));
    s.addViewer();
    expect(s.viewers.length, 5);
    s.toggleShortlist(s.rankedMovies().first.movie.id);
    await tester.tap(find.text('Vote'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButtonFormField<String?>), findsNWidgets(5));
    for (var i = 0; i < 4; i++) {
      s.castVote(i, s.shortlist.single);
    }
    await tester.pumpAndSettle();
    expect(find.text('4 of 5 votes are in.'), findsOneWidget);
    s.castVote(4, s.shortlist.single);
    await tester.pumpAndSettle();
    expect(
      find.text('Tonight’s pick: ${s.movieById(s.shortlist.single)!.title}'),
      findsOneWidget,
    );
    await tester.tap(find.text('Tastes'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 3; i++) {
      await press('Remove last viewer');
    }
    expect(find.text('2 viewers'), findsOneWidget);
    expect(
      tester
          .widget<OutlinedButton>(
            find.widgetWithText(OutlinedButton, 'Remove last viewer'),
          )
          .onPressed,
      isNull,
    );
    s.removeLastViewer();
    expect(s.viewers.length, 2);
    await tester.tap(find.text('Vote'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButtonFormField<String?>), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
