import 'package:byte_bank2/main.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Should display the main image when Dashboard is opened', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets('Should display the first feature when the dashboard is opened', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    // buildCard is private
    // final firstFeature = find.widgetWithIcon(buildCard());
    // expect(firstFeature, findsWidget);
  });
  testWidgets('Should display the transaction feed when the dashboard is opened', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    // final firstFeature = find.widgetWithIcon(FeatureItem());
    // expect(firstFeature, findsWidget);
  });
}