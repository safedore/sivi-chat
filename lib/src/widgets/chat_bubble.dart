import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final DateTime timeStamp;
  final String avatarLetter;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.timeStamp,
    required this.avatarLetter,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isSender ? Colors.deepPurple[200] : Colors.grey[200];

    String timeStamp = DateFormat('yyyy-MM-dd hh:mm:ss').format(this.timeStamp);
    if (this.timeStamp.isBefore(DateTime.now().subtract(Duration(hours: 24)))) {
      timeStamp = 'Yesterday';
    } else if (this.timeStamp.isBefore(
      DateTime.now().subtract(Duration(days: 2)),
    )) {
      timeStamp = DateFormat('dd/MM/yy').format(this.timeStamp);
    } else {
      timeStamp = DateFormat('hh:mm a').format(this.timeStamp);
    }

    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;

    final radius = BorderRadius.only(
      bottomRight: const Radius.circular(16),
      bottomLeft: const Radius.circular(16),
      topLeft: isSender ? const Radius.circular(16) : const Radius.circular(4),
      topRight: isSender ? const Radius.circular(4) : const Radius.circular(16),
    );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSender) CircleAvatar(radius: 14, child: Text(avatarLetter)),

            if (!isSender) const SizedBox(width: 8),

            Column(
              crossAxisAlignment: isSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: radius,
                  ),
                  child: Text(text),
                ),
                Text(timeStamp, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),

            if (isSender) const SizedBox(width: 8),

            if (isSender)
              const CircleAvatar(
                radius: 14,
                backgroundColor: Colors.blueAccent,
                child: Text('Y', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }
}
