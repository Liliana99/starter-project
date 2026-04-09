import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';

void main() {
  testWidgets('KineticNavigationBar should render all menu items',
      (WidgetTester tester) async {
    // build the widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: KineticNavigationBar(currentRoute: '/'),
        ),
      ),
    );

    expect(find.text('FEED'), findsOneWidget);
    expect(find.text('MANAGE'), findsOneWidget);
    expect(find.text('PROFILE'), findsOneWidget);

    expect(find.byType(Icon), findsAtLeast(2));
  });
}
