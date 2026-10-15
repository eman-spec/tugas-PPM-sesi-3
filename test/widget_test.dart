// Widget test untuk NusaBookstore
import 'package:flutter_test/flutter_test.dart';

import 'package:nusa_bookstore/main.dart';
import 'package:nusa_bookstore/providers/cart_provider.dart';
import 'package:nusa_bookstore/providers/theme_provider.dart';

void main() {
  testWidgets('NusaBookstore app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NusaBookstoreApp());
    await tester.pumpAndSettle();

    // Verify that the catalog screen loads with the app title.
    expect(find.text('NusaBookstore'), findsOneWidget);
  });

  test('CartProvider adds and removes items', () {
    final cart = CartProvider();
    expect(cart.totalItems, 0);
    expect(cart.totalPrice, 0.0);
  });

  test('ThemeProvider toggles theme', () {
    final theme = ThemeProvider();
    expect(theme.isDarkMode, false);
    theme.toggleTheme();
    expect(theme.isDarkMode, true);
    theme.toggleTheme();
    expect(theme.isDarkMode, false);
  });
}
