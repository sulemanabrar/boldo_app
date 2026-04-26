import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boldo/app/boldo_app.dart';

void main() {
  Future<void> _enterFeed(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BolDoApp(
          firebaseReady: false,
          requireAuth: false,
        ),
      ),
    );
    await tester.tap(find.text('Just listen for now'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders feed and record action', (WidgetTester tester) async {
    await _enterFeed(tester);

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('opens confession recorder sheet', (WidgetTester tester) async {
    await _enterFeed(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Confess anonymously'), findsOneWidget);
  });

  testWidgets('supports vertical swipe through confessions', (WidgetTester tester) async {
    await _enterFeed(tester);

    expect(find.text('3 replies'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('5 replies'), findsOneWidget);
  });
}
