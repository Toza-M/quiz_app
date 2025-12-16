import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart'; // Ensure this matches your project name

void main() {
  testWidgets('App loads and shows Get Started text',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our "Get Started" text is present.
    expect(find.text('QuizApp'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
