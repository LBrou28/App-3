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
}
