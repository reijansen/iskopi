import 'package:flutter_test/flutter_test.dart';

import 'package:iskopi/app.dart';

void main() {
  testWidgets('app boots with home route', (WidgetTester tester) async {
    await tester.pumpWidget(const IskopiApp());

    expect(find.text('home page'), findsOneWidget);
  });
}
