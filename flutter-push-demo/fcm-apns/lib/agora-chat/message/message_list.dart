import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


/// Listens for incoming foreground messages and displays them in a list.
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<StatefulWidget> createState() => _MessageList();
}

class _MessageList extends State<MessageList> {
  List<ChatMessage> _messages = [];

  // Create a logger instance
  final Logger _logger = Logger('LoginPageLogger');

  @override
  void initState() {
    super.initState();

    // Add Chat Event Handlers
    ChatClient.getInstance.chatManager.addEventHandler("Message_List_Chat_Event_Handler", 
      ChatEventHandler(onMessagesReceived: _onMessageReceivedHandler)
    );

  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return const Text('No messages received');
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          ChatMessage message = _messages[index];
          var messageBody = message.body;

          DateTime date = DateTime.fromMillisecondsSinceEpoch(message.serverTime);
          String formattedDate = DateFormat('HH:mm').format(date);

          if (messageBody is ChatTextMessageBody){
            return ListTile(
              title: 
              Text("From:${message.from}", style: const TextStyle(color: Colors.blue)),
              subtitle: Text(messageBody.content),
              trailing:
                  Text(formattedDate),
            );
          }
          return ListTile(
            title: 
              Text("From:${message.from}", style: const TextStyle(color: Colors.blue)),
            subtitle: 
            Text(message.msgId),
            trailing:
                Text(formattedDate),
          );
        });
  }

  Future<void> _onMessageReceivedHandler(List<ChatMessage> messages) async {
    for (var message in messages) {
      _logger.warning("Message received: ${message.body.toString()}");
      if (message.body is ChatTextMessageBody) {
        setState(() {
          _messages = [..._messages, message];
        });
      } else {
        _logger.warning("TODO");
      }
    }
  }

}

