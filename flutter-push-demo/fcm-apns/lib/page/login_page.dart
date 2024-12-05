import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:push_demo/agora-chat/message/message_list.dart';
import 'package:push_demo/agora-chat/connection.dart';
import 'package:push_demo/consts.dart';
import 'package:push_demo/notifications/push_manager.dart';
import 'package:logging/logging.dart';
import 'package:push_demo/notifications/local_notifications_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController =
      TextEditingController(text: AgoraChatConfig.userId);
  final TextEditingController _tokenController =
      TextEditingController(text: AgoraChatConfig.userToken);

  bool _isLoggedIn = false;
  // Create a logger instance
  final Logger _logger = Logger('LoginPageLogger');

  @override
  void initState() {
    super.initState();

    // Configure logger to log to the console
    Logger.root.level = Level.ALL;
    _logger.onRecord.listen((LogRecord record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  void _login() async {
    String userId = _userIdController.text;
    String token = _tokenController.text;

    final isGranted = await PushManager.requestPermission();
    if (isGranted) {
      /// initialize Chat SDK
      ChatOptions options = ChatOptions(
          appKey: AgoraChatConfig.appKey, autoLogin: false, debugModel: true);
      if (Platform.isIOS) {
        options.enableAPNs(AgoraChatConfig.apnsCertName);
      } else if (Platform.isAndroid) {
        options.enableFCM(AgoraChatConfig.fcmSenderID);
      } else {
        _logger.warning("Unsupported platform");
      }
      await ChatClient.getInstance.init(options);

      ConnectionManager();

      // Add Chat Event Handlers
      ChatClient.getInstance.chatManager.addEventHandler("Login_Chat_Event_Handler", 
        ChatEventHandler(onMessagesReceived: _onMessageReceivedHandler)
      );

      /// connect to Chat Server
      try {
        await ChatClient.getInstance.loginWithAgoraToken(
          userId,
          token,
        );
        setState(() {
          _isLoggedIn = true;
        });
        _logger.info('User logged in successfully.');
        await PushManager.registerPushToken();
      } catch (e) {
        _logger.warning('Failed login : $e');
      }
    } else {
      Fluttertoast.showToast(
        msg: 'The permission was not granted regarding push notifications.',
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _logout() async {
      /// disconnect to Chat Server
      bool isUnBindDeviceToken = true;
      try {
        await ChatClient.getInstance.logout(isUnBindDeviceToken);
        setState(() {
          _isLoggedIn = false;
        });
        _logger.info('User logged out. Unregisterd device token status is: $isUnBindDeviceToken');
      } catch (e) {
        _logger.warning('Failed logout : $e');
      }
  }

  Future<void> _onMessageReceivedHandler(List<ChatMessage> messages) async {
    for (var message in messages) {
      _logger.warning("Message received: ${message.body.toString()}");
      
      if (message.body is ChatTextMessageBody) {
        ChatTextMessageBody body = message.body as ChatTextMessageBody;
        await LocalNotificationsManager.showNotification(
          title: message.from,
          body: body.content,
          payload: '',
        );
      } else {
        await LocalNotificationsManager.showNotification(
          title: message.from,
          body: 'Other message types content',
          payload: '',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Token',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Align buttons to left and right
              children: <Widget>[
                if (!_isLoggedIn)
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                if (_isLoggedIn)
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
              ],
            ),
            const MetaCard('Message Stream', MessageList()),
          ],
        ),
      ),
    );
  }
}
/// UI Widget for displaying metadata.
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  const MetaCard(this._title, this._children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(_title, style: const TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 350,
                child: _children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}