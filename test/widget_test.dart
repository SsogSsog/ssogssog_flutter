import 'package:flutter_test/flutter_test.dart';
import 'package:ssogssog_flutter/app/app.dart';

void main() {
  testWidgets('App starts and shows initial text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app shows the initial text.
    expect(find.text('시작 페이지'), findsOneWidget);
  });
}
