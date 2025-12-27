import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/home_screen.dart';
import 'package:my_sivi_chat/src/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full chat flow: add user, send message, receive reply', (
    WidgetTester tester,
  ) async {
    ///
    /// TO testers:
    /// please refer file lib/src/screens/tabs/user_list_tab.dart
    /// lines 41 and 49 before running this test
    const testUserName = 'Alex Smith';

    // Launch the app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: MaterialApp(home: Scaffold(body: HomeScreen())),
      ),
    );

    // Tap the fab to add a newuser
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    // verify the new user appears (bytext)
    expect(find.textContaining(testUserName), findsWidgets);

    // Tap on the user to open ChatScreen
    final userTile = find.textContaining(testUserName).first;
    await tester.tap(userTile);
    await tester.pumpAndSettle();

    // message
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'Hello integration test');

    // send btn
    final sendButton = find.byIcon(Icons.send);
    await tester.ensureVisible(sendButton);
    await tester.pumpAndSettle();
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    // Wait for the real API reply (integration test allows network)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify user message appears
    expect(find.text('Hello integration test'), findsOneWidget);

    // Verify reply appears
    expect(find.byType(ChatBubble), findsAtLeastNWidgets(2));
  });
}
