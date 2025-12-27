import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/services/network_helper.dart';
import 'package:my_sivi_chat/src/screens/chat_screen.dart';
import 'package:my_sivi_chat/src/screens/home_screen.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:my_sivi_chat/src/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

void main() {
  const testUserName = 'Alex Smith';

  testWidgets('Add user and show in Users List', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(home: Scaffold(body: HomeScreen())),
      ),
    );

    // Default tab
    expect(find.text('Contacts'), findsOneWidget);

    // Tap fab
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify user appears
    expect(find.textContaining(' '), findsWidgets); // First + last name format

    // Snackbar appears
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Send message (user only)', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(
          home: ChatScreen(userName: testUserName, index: 0),
        ),
      ),
    );

    // Enter message
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump(); // trigger UI update

    // Verify only user message exists
    expect(find.text('Hello'), findsOneWidget);
    expect(find.byType(ChatBubble), findsOneWidget);

    // Cannot test reply because network is blocked. so a different for api has been created
  });

  testWidgets('Send message and receive fake reply', (
    WidgetTester tester,
  ) async {
    // Replace NetworkHelper with fake one bcoz mocking was the only option
    NetworkHelper.override = FakeNetworkHelper();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(
          home: ChatScreen(userName: testUserName, index: 0),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200)); // wait for reply
    await tester.pumpAndSettle();

    // Now both messages exist
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Hi there!'), findsOneWidget);
    expect(find.byType(ChatBubble), findsNWidgets(2));
  });
}

class FakeNetworkHelper extends NetworkHelper {
  @override
  Future<Map<String, dynamic>?> sendMessage() async {
    await Future.delayed(const Duration(milliseconds: 100)); // simulate network
    return {'content': 'Hi there!'}; // fake reply
  }
}
