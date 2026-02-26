import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jvcss/main.dart';

void main() {
  testWidgets('Portfolio app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PortfolioApp()),
    );
    await tester.pump();
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
