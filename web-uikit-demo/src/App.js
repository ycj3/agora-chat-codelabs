// App.js
import React, { Component, useEffect } from "react";
import {
  UIKitProvider,
  Chat,
  ConversationList,
  useClient,
  rootStore,
} from "agora-chat-uikit";

import "agora-chat-uikit/style.css";
import "./styles/chatApp.css"

const appKey = "61717166#1069763"; // your appKey
const user = "demo_user_1"; // your user ID
const agoraToken = "007eJxTYCjzOr2T4edljvLwVKPfJyO+i+Xe17K8fVxp3hHfnMAnRxYoMKQkG6ckm6cmGpilWJhYmCZbJhuZpZonJaYYmFiYJxmb2Cl6pjcEMjLcFDJgYmRgZWAEQhBfhcEoJcXA3CzVQNcyxdBc19AwNU3X0swiTTfJ3NAyxTQt0SQ1xQwAzh4n5g=="; // agora chat token

const conversation = {
  chatType: "groupChat", // 'singleChat' || 'groupChat'
  conversationId: "251315614711817", // target user id or group id
  name: "Test Group", // target user nickname or group name
  lastMessage: {},
};

const ChatApp = () => {
  const client = useClient();
  useEffect(() => {
    client &&
      client
        .open({
          user,
          agoraToken,
        })
        .then((res) => {
          console.log("get token success", res);
          // create a conversation
          rootStore.conversationStore.addConversation(conversation);
        });
  }, [client]);

  client.addEventHandler("chatdemo", {
    onConnected: () => {
      rootStore.conversationStore.setCurrentCvs(conversation)
    }}) 

  return (
    <div className="agora-chat-app-wrap">
      <div className="agora-chat-conversation-list-wrap">
        <ConversationList />
      </div>
      <div className="agora-chat-message-list-wrap">
        <Chat />
      </div>
    </div>
  );
};

class App extends Component {
  render() {
    return (
      <UIKitProvider
        initConfig={{
          appKey,
          useUserInfo: true
        }}
      >
        <ChatApp />
      </UIKitProvider>
    );
  }
}

export default App;
