import 'dart:io';

import 'package:flutter/material.dart';
import 'package:push_demo/notifications/local_notifications_manager.dart';
import 'notifications/push_manager.dart';
import 'page/login_page.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart';

final Logger _logger = Logger('LoginPageLogger');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await PushManager.initialize();
  await LocalNotificationsManager.initialize();
  
  runApp(const PushDemo());
}

class PushDemo extends StatefulWidget {
  const PushDemo({super.key});

  @override
  State<PushDemo> createState() => _PushDemoState();
}

class _PushDemoState extends State<PushDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Push Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Application(),
      },
    );
  }
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<String> members = ["demo_user_2", "demo_user_3"];
  int expiry = 1000;

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
            try {
              await ChatClient.getInstance.presenceManager.subscribe(
                members: members,
                expiry: expiry,
              );
            } on ChatError catch (e) {
              _logger.warning("Failed to subscribe to presence: $e");
            }

            ChatClient.getInstance.presenceManager.addEventHandler(
            "UNIQUE_HANDLER_ID",
            ChatPresenceEventHandler(
              onPresenceStatusChanged: (list) {
                _logger.info("onPresenceStatusChanged: $list[0]");
              },
            ),
          );
        }
        break;
      case 'unsubscribe':
        {
          try {
            await ChatClient.getInstance.presenceManager.unsubscribe(
              members: members,
            );
          } on ChatError catch (e) {
            _logger.warning("Failed to unsubscribe to presence: $e");
          }
        }
        break;
      default:
        break;
    }
  }

  Future<void> _sendTextMessage() async {
    // Send message to a use 
    // const String targetId = "<INPUT_YOUR_USER_ID>";
    // const ChatType chatType = ChatType.Chat;
    
    // Uncomment to send message to a group
    String targetId = "251315614711817";
    ChatType chatType = ChatType.GroupChat;

    final ChatMessage msg = ChatMessage.createTxtSendMessage(
        targetId: targetId,
        content: "This is a text message",
        chatType: chatType,
    );
    try {
      await ChatClient.getInstance.chatManager.sendMessage(msg);
    } catch (e) {
      _logger.warning("Failed to send text message: $e");
    }

    ChatClient.getInstance.chatManager.addMessageEvent(
      "Login_Send_Message_Event_Handler",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          _logger.warning("onSuccess");
        },
        onError: (msgId, msg, error) {
          _logger.warning("onError: $error");
        },
        onProgress: (msgId, progress) {
          _logger.warning("onProgress: $progress");
        },
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Push Example'),
      actions: <Widget>[
          PopupMenuButton(
            onSelected: onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'subscribe',
                  child: Text('Subscribe to presence'),
                ),
                const PopupMenuItem(
                  value: 'Busy',
                  child: Text('Unsubscribe to presence'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: _sendTextMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
      body: const LoginPage(),
    );
  }

@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        _logger.info("App is inactive");
        break;
      case AppLifecycleState.paused:
        _logger.info("App is paused");
        // Save state, release resources
        break;
      case AppLifecycleState.resumed:
        _logger.info("App is resumed");
        if (Platform.isIOS) {
          NativeCodeInvoker.invokeNativeCodeAppWillEnterForeground();
        }
        // Reinitialize resources
        break;
      case AppLifecycleState.detached:
        _logger.info("App is detached");
        // Clean up before termination
        break;
      case AppLifecycleState.hidden:
        _logger.info("App is Hidden");
        if (Platform.isIOS) {
          NativeCodeInvoker.invokeNativeCodeAppDidEnterBackground();
        }
        // Clean up before termination
        break;
    }
  }
}

class NativeCodeInvoker {
  static const MethodChannel _channel = MethodChannel('com.example/native');

  static Future<String> invokeNativeCodeAppWillEnterForeground() async {
    try {
      final String result = await _channel.invokeMethod('applicationWillEnterForeground');
      return result;
    } catch (e) {
      return 'Error: $e';
    }
  }

  static Future<String> invokeNativeCodeAppDidEnterBackground() async {
    try {
      final String result = await _channel.invokeMethod('applicationDidEnterBackground');
      return result;
    } catch (e) {
      return 'Error: $e';
    }
  }
}
