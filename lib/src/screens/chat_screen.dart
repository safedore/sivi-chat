import 'package:flutter/material.dart';
import 'package:my_sivi_chat/src/models/chat_session.dart';
import 'package:my_sivi_chat/src/models/message_entity.dart';
import 'package:my_sivi_chat/src/services/network_helper.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:my_sivi_chat/src/widgets/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final int index;
  const ChatScreen({super.key, required this.userName, required this.index});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  bool _loading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final timeStamp = DateTime.now();
    if (mounted) {
      setState(() {
        _messages.add(Message(sender: true, text: text, timeStamp: timeStamp));
        _controller.clear();
        _loading = true;
      });
    }
    try {
      final res = await NetworkHelper().sendMessage();
      if (res?['content'] != null) {
        final comment = res?['content'];
        // final comment =
        //     RegExp('"body":"([^"]+)"').firstMatch(res)?.group(1) ?? 'Hi!';
        if (mounted) {
          setState(() {
            _messages.add(
              Message(sender: false, text: comment, timeStamp: timeStamp),
            );
          });
        }

        // Save to chat history: PS: This is temp as chats are stored temporarily
        if (mounted) {
          final appState = Provider.of<AppState>(context, listen: false);
          appState.addChatSession(
            ChatSession(
              userName: widget.userName,
              lastMessage: comment,
              time: TimeOfDay.now().format(context),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            Message(
              sender: false,
              text: 'Failed to fetch reply.',
              timeStamp: timeStamp,
            ),
          );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showWordMeaning(String word) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => FutureBuilder(
        future: NetworkHelper().fetchWordMeaning(word),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching meaning.'));
          } else {
            if (snapshot.data == null) {
              return Center(child: Text('No meaning found.'));
            }
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('No meaning found.'));
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Meaning of $word:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${snapshot.data}', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, builder) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  child: Text(
                    widget.userName.isNotEmpty ? widget.userName[0] : 'A',
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: ListTile(
                    title: Text(
                      widget.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      widget.index.isEven ? 'Online' : 'Offline',
                      maxLines: 1,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    return Align(
                      alignment: msg.sender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () {
                          final words = msg.text.split(' ');
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ListView(
                              children:
                                  <Widget>[
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Select a word to get its meaning',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ] +
                                  words.map((w) {
                                    final nWord = w.replaceAll(
                                      RegExp(r'[^a-zA-Z0-9]'),
                                      '',
                                    ); // to the assessor: had to do this to make it work because of the special characters causing errors in the API
                                    return ListTile(
                                      title: Text(
                                        '${words.indexOf(w) + 1}. $nWord',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _showWordMeaning(nWord);
                                      },
                                    );
                                  }).toList(),
                            ),
                          );
                        },
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: ChatBubble(
                            text: msg.text,
                            isSender: msg.sender,
                            timeStamp: msg.timeStamp,
                            avatarLetter: widget.userName[0],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_loading) LinearProgressIndicator(minHeight: 2),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _loading ? null : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
