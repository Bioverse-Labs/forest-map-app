import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forest_map/core/screens/splash_screen.dart';

void main() {
  testWidgets(
    'should render an screen with logo',
    (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(SplashScreen());
        Element element = tester.element(find.byType(Image));
        Image widget = element.widget;
        await precacheImage(widget.image, element);
        await tester.pumpAndSettle();
      });

      await expectLater(
        find.byType(Container),
        matchesGoldenFile('sample_golden.png'),
      );
    },
  );
}
