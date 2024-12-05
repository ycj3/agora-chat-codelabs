import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/foundation.dart';

class ConnectionManager {

  // Adding Connection event handlers
  // Handling Connection event

  ConnectionManager() {
    ChatClient.getInstance.addConnectionEventHandler(
      'CONNECTION_HANDLER',
      ConnectionEventHandler(
        onConnected: () async {
          debugPrint("Connected Agora Chat Server Successful");
        },
        onDisconnected: () {
          debugPrint("Disconnected Agora Chat Server");
        },
      )
    );
  }
  
}
