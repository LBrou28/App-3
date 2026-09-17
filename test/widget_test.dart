import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reel_match/main.dart';

void main() {
  testWidgets('shows ReelMatch navigation and preferences', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ReelMatchApp());
    await tester.pumpAndSettle();
    expect(find.text('Tastes'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Vote'), findsOneWidget);
    expect(find.text('Meet the movie crew'), findsOneWidget);
  });

  testWidgets('adds a discovered movie to the vote', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ReelMatchApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Add to the vote').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to the vote').first);
    await tester.pumpAndSettle();

    expect(find.text('Shortlisted · Remove'), findsOneWidget);
  });
}
