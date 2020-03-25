import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'Should display the main image when the Dashboard is opended',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));
      final mainImage = find.byType(Image);

      expect(mainImage, findsOneWidget);
    },
  );

  testWidgets(
    'Should display the transfer feature when the Dashboard is opened',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));
      final transferFeature = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Transferência', Icons.monetization_on));

      expect(transferFeature, findsOneWidget);
    },
  );

  testWidgets(
    'Should display the transaction feed feature when the Dashboard is opened',
    (tester) async {
      await tester.pumpWidget(MaterialApp(home: Dashboard()));
      final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
          featureItemMatcher(widget, 'Extrato', Icons.description));

      expect(transactionFeedFeatureItem, findsOneWidget);
    },
  );
}

bool featureItemMatcher(Widget widget, String name, IconData icon) {
  if (widget is FeatureItem) {
    return widget.name == name && widget.icon == icon;
  }
  return false;
}
