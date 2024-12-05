import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:logging/logging.dart';

// Global key to access the scaffold messenger
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

final Logger _logger = Logger('LoginPageLogger');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFECE5DD),
      ),
      home: const MyHomePage(title: 'Agora Chat API Examples'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const String appKey = "61717166#1069763";
  static const String userId = "demo_user_1";
  String token = "007eJxTYFga+qE9WWPZ+syqGWZaKa7ZlTGZEyKOcmu0+O159iD8k5QCQ0qycUqyeWqigVmKhYmFabJlspFZqnlSYoqBiYV5krHJBu/A9IZARgazGT4sjAysDIxACOKrMBilpBiYm6Ua6FqmGJrrGhqmpulamlmk6SaZG1qmmKYlmqSmmAEAOTMm0w==";
  
  late ChatClient agoraChatClient;
  bool isJoined = false;

  ScrollController scrollController = ScrollController();
  TextEditingController messageBoxController = TextEditingController();
  String messageContent = "", recipientId = "";
  final List<Widget> messageList = [];
  
  showLog(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

@override
void initState() {
  super.initState();
  setupChatClient();
  setupListeners();
}

void setupChatClient() async {
  ChatOptions options = ChatOptions(
    appKey: appKey,
    autoLogin: false,
    debugModel: true
  );
  agoraChatClient = ChatClient.getInstance;
  await agoraChatClient.init(options);
// Notify the SDK that the Ul is ready. After the following method is executed, callbacks within ChatRoomEventHandler and ChatGroupEventHandler can be triggered.
  await agoraChatClient.startCallback();
}

void setupListeners() {

  agoraChatClient.addConnectionEventHandler(
    "CONNECTION_HANDLER",
    ConnectionEventHandler(
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onTokenWillExpire: onTokenWillExpire,
      onTokenDidExpire: onTokenDidExpire
    ),
  );

  agoraChatClient.chatManager.addEventHandler(
    "MESSAGE_HANDLER",
    ChatEventHandler(onMessagesReceived: onMessagesReceived),
  );

    /// Add a group event listener.
  agoraChatClient.groupManager.addEventHandler(
    'GROUP_EVENT_HANDLER',
    ChatGroupEventHandler(
      /// Occurs when a member is added to the chat group admin list.
      onAdminAddedFromGroup: (groupId, admin) {

      },

      /// Occurs when an admin is removed from the chat group admin list.
      onAdminRemovedFromGroup: (groupId, admin) {},

      /// Occurs when all chat group members are muted or unmuted.
      onAllGroupMemberMuteStateChanged: (groupId, isAllMuted) {},

      /// Occurs when a member is added to the chat group allow list.
      onAllowListAddedFromGroup: (groupId, members) {},

      /// Occurs when a member is removed from the chat group allow list.
      onAllowListRemovedFromGroup: (groupId, members) {},

      /// Occurs when a member updates the chat group announcement.
      onAnnouncementChangedFromGroup: (groupId, announcement) {},

      /// Occurs when custom attributes of a group member are updated.
      onAttributesChangedOfGroupMember: (groupId, userId, attributes, operatorId) {},

      /// Occurs when an invitee accepts a group invitation automatically.
      onAutoAcceptInvitationFromGroup: (groupId, inviter, inviteMessage) {},

      /// Occurs when the group function is disabled or enabled.
      onDisableChanged: (groupId, isDisable) {},

      /// Occurs when the chat group owner disbands a chat group.
      onGroupDestroyed: (groupId, groupName) {},

      /// Occurs when an invitee accepts a group invitation.
      onInvitationAcceptedFromGroup: (groupId, invitee, reason) {},

      /// Occurs when an invitee declines a group invitation.
      onInvitationDeclinedFromGroup: (groupId, invitee, reason) {},

      /// Occurs when an invitee receives a group invitation.
      onInvitationReceivedFromGroup: (groupId, groupName, inviter, reason) {},

      /// Occurs when a member leaves a chat group.
      onMemberExitedFromGroup: (groupId, member) {},

      /// Occurs when a user joins a chat group.
      onMemberJoinedFromGroup: (groupId, member) {
        _logger.info("Group: $groupId, Member: $member");
      },

      /// Occurs when a member is added to the chat group mute list.
      onMuteListAddedFromGroup: (groupId, mutes, muteExpire) {},

      /// Occurs when a member is removed from the chat group mute list.
      onMuteListRemovedFromGroup: (groupId, mutes) {},

      /// Occurs when the chat group owner is changed.
      onOwnerChangedFromGroup: (groupId, newOwner, oldOwner) {},

      /// Occurs when a join request is accepted.
      onRequestToJoinAcceptedFromGroup: (groupId, groupName, accepter) {},

      /// Occurs when a join request is received.
      onRequestToJoinReceivedFromGroup: (groupId, groupName, applicant, reason) {},

      /// Occurs when a member uploads a chat group shared file.
      onSharedFileAddedFromGroup: (groupId, sharedFile) {},

      /// Occurs when a member deletes a chat group shared file.
      onSharedFileDeletedFromGroup: (groupId, fileId) {},

      /// Occurs when the specifications of a chat group is changed.
      onSpecificationDidUpdate: (group) {},

      /// Occurs when a member is removed from a chat group.
      onUserRemovedFromGroup: (groupId, groupName) {},
    ),
  );

}

void onMessagesReceived(List<ChatMessage> messages) {
  for (var msg in messages) {
    if (msg.body.type == MessageType.TXT) {
      ChatTextMessageBody body = msg.body as ChatTextMessageBody;
      displayMessage(body.content, false);
      showLog("Message from ${msg.from}");
    } else {
      String msgType = msg.body.type.name;
      showLog("Received $msgType message, from ${msg.from}");
    }
  }
}

void onTokenWillExpire() {
  // The token is about to expire. Get a new token
  // from the token server and renew the token.
}
void onTokenDidExpire() {
  // The token has expired
}
void onDisconnected () {
  // Disconnected from the Chat server
}
void onConnected() {
  showLog("Connected");
}

void joinLeave() async {
  if (!isJoined) { // Log in
    try {
      await agoraChatClient.loginWithAgoraToken(userId, token);
      _logger.info("Logged in successfully as $userId");
      setState(() {
        isJoined = true;
      });
    } on ChatError catch (e) {
      if (e.code == 200) { // Already logged in
        setState(() {
          isJoined = true;
        });
      } else {
        _logger.info("Login failed, code: ${e.code}, desc: ${e.description}");
      }
    }
  } else { // Log out
    try {
      await agoraChatClient.logout(true);
      showLog("Logged out successfully");
      setState(() {
        isJoined = false;
      });
    } on ChatError catch (e) {
      showLog("Logout failed, code: ${e.code}, desc: ${e.description}");
    }
  }
}

void sendMessage() async {
  if (recipientId.isEmpty || messageContent.isEmpty) {
    showLog("Enter recipient user ID and type a message");
    return;
  }

  var msg = ChatMessage.createTxtSendMessage(
    targetId: recipientId,
    content: messageContent,
  );
  ChatClient.getInstance.chatManager.addMessageEvent(
  "UNIQUE_HANDLER_ID",
  ChatMessageEvent(
  onSuccess: (msgId, msg) {
    _logger.info("on message succeed");
  },
  onProgress: (msgId, progress) {
  _logger.info("on message progress");
  },
  onError: (msgId, msg, error) {
  _logger.info(
  "on message failed, code: ${error.code}, desc: ${error.description}",
  );
  },
  ),
  );
  ChatClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
  agoraChatClient.chatManager.sendMessage(msg);
}

void displayMessage(String text, bool isSentMessage) {
  messageList.add(Row(children: [
    Expanded(
      child: Align(
        alignment:
        isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(
              (isSentMessage ? 50 : 0), 5, (isSentMessage ? 0 : 50), 5),
          decoration: BoxDecoration(
            color: isSentMessage
                ? const Color(0xFFDCF8C6)
                : const Color(0xFFFFFFFF),
          ),
          child: Text(text),
        ),
      ),
    ),
  ]));

  setState(() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent + 50);
  });
}

@override
void dispose() {
  agoraChatClient.chatManager.removeEventHandler("MESSAGE_HANDLER");
  agoraChatClient.removeConnectionEventHandler("CONNECTION_HANDLER");
  agoraChatClient.groupManager.removeEventHandler('GROUP_EVENT_HANDLER');
  super.dispose();
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter recipient's userId",
                      ),
                      onChanged: (chatUserId) => recipientId = chatUserId,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: joinLeave,
                    child: Text(isJoined ? "Leave" : "Join"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return messageList[index];
                },
                itemCount: messageList.length,
              ),
            ),
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: messageBoxController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Message",
                    ),
                    onChanged: (msg) => messageContent = msg,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 50,
                height: 40,
                child: ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text(">>"),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

}
