import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/screens/chat_screen.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:provider/provider.dart';

class ChatHistoryTab extends StatefulWidget {
  const ChatHistoryTab({super.key});

  @override
  State<ChatHistoryTab> createState() => _ChatHistoryTabState();
}

class _ChatHistoryTabState extends State<ChatHistoryTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Required for AutomaticKeepAliveClientMixin: PS: you asked for it in the doc
    final history = context.watch<AppState>().chatHistory;
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final session = history[index];
        return ListTile(
          leading: CircleAvatar(child: Text(session.userName[0])),
          title: Text(session.userName),
          subtitle: Text(session.lastMessage),
          trailing: Text(session.time),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    ChatScreen(userName: session.userName, index: index),
              ),
            );
          },
        );
      },
    );
  }
}
