import 'package:flutter_test/flutter_test.dart';
import 'package:doc_appoint_frontend/main.dart';

void main() {
  testWidgets('App smoke test renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('DocAppoint'), findsOneWidget);
  });
}
