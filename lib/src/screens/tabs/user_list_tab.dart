import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/chat_screen.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:provider/provider.dart';

class UsersListTab extends StatefulWidget {
  const UsersListTab({super.key});

  @override
  State<UsersListTab> createState() => _UsersListTabState();
}

class _UsersListTabState extends State<UsersListTab>
    with AutomaticKeepAliveClientMixin {
  final _random = Random();

  @override
  bool get wantKeepAlive => true;

  void _addUser() {
    final appState = Provider.of<AppState>(context, listen: false);
    final name = generateRandomName(); // 'User ${appState.users.length + 1}';
    appState.addUser(name);

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Contact added: $name'), showCloseIcon: true),
        );
    }
  }

  String generateRandomName() {
    const firstNames = [
      'Alex',

      /// TO testers: comment the below 2 lines for integration test to work
      'Sam', 'Chris', 'Jordan', 'Taylor',
      'Jamie', 'Morgan', 'Casey', 'Riley', 'Avery',
    ];

    const lastNames = [
      'Smith',

      /// TO testers: comment the below 2 lines for integration test to work
      'Johnson', 'Brown', 'Williams',
      'Jones', 'Miller', 'Davis', 'Wilson',
    ];

    final firstName = firstNames[_random.nextInt(firstNames.length)];
    final lastName = lastNames[_random.nextInt(lastNames.length)];

    return '$firstName $lastName';
  }

  void _openChat(String user, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(userName: user, index: index),
        maintainState: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Required for AutomaticKeepAliveClientMixin: PS: you asked for it in the doc
    final users = context.watch<AppState>().users;
    return Stack(
      children: [
        ListView.builder(
          itemCount: users.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final name = users[index];
            final randomMinutes = {'min': Random().nextInt(60)};
            final randomHours = {'hours': Random().nextInt(24)};
            final randomDays = {'days': Random().nextInt(7)};
            final randomTypes = [randomMinutes, randomHours, randomDays];
            final randomTypeString = randomTypes[Random().nextInt(3)];
            final randomType = randomTypeString.keys.first;
            final randomTypeValue = randomTypeString.values.first;

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              leading: Stack(
                children: [
                  CircleAvatar(child: Text(name[0])),
                  if (index.isEven) ...[
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 128, 0, 0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              title: Text(name),
              subtitle: Text(
                index.isEven ? 'Online' : '$randomTypeValue $randomType ago',
              ),
              onTap: () => _openChat(name, index),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _addUser,
            backgroundColor: Colors.blue,
            elevation: 5,
            shape: CircleBorder(),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
