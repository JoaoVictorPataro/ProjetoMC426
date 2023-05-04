import 'package:flutter_test/flutter_test.dart';
import 'package:safe_neighborhood/map.dart';
import 'package:flutter/material.dart';

void main() {
  group('Map page Widget Tests', () {
    testWidgets("Map should be visible", (WidgetTester tester) async {
      const Widget mapWidget = MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: SimpleMap())
      );

      await tester.pumpWidget(mapWidget);
      expect(find.byType(SimpleMap), findsOneWidget);
    });
  });
}