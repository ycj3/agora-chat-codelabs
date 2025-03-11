import { useEffect, useState, useRef } from "react";
import "./App.css";
import AC from "agora-chat";

import MiniCore from "agora-chat/miniCore/miniCore";
import * as contactPlugin from "agora-chat/contact/contact";
import * as localCachePlugin from "agora-chat/localCache/localCache";


const APP_KEY = "61717166#1069763";
const CONNECTION_MESSAGE_EVENT = "connection&message";
const CHATROOM_EVENT = "ChatroomEvent";

const miniCore = new MiniCore({
  appKey: "61717166#1069763",
});

function App() {
  const [userId, setUserId] = useState("");
  const [token, setToken] = useState("");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [peerId, setPeerId] = useState("");
  const [message, setMessage] = useState("");
  const [logs, setLogs] = useState([]);
  const [conversationId, setConversationId] = useState("");
  const [conversationType, setConversationType] = useState("");

  const handleLogin = () => {
    if (userId && token) {
      miniCore.open({ username: userId, accessToken: token }).then(() => {
        addLog("Login successful");
      }).catch((error) => {
        addLog(`Login failed: ${error.message}`);
      });
    } else {
      addLog("Please enter userId and token");
    }
  };

  const handleLogout = () => {
    miniCore.close().then(() => {
      setIsLoggedIn(false);
      setUserId("");
      setToken("");
      setPeerId("");
      addLog("Logout successful");
    }).catch((error) => {
      addLog(`Logout failed: ${error.message}`);
    });
  };

  const handleSendMessage = async () => {
    if (message.trim()) {
      try {
        const option = {
          chatType: conversationType || "singleChat",
          type: "txt",
          to: conversationId || peerId,
          msg: message,
          ext: {
            em_apns_ext: {
              em_push_mutable_content: true,
              em_push_content_available: 1,
              em_push_type: "voip",
              em_push_sound: "default",
            },
            em_push_ext: {
              type: "call",
              custom: { key1: "value1", key2: "value2" },
            }
          },
        };

        const msg = AC.message.create(option);
        await miniCore.send(msg);
        addLog(`Message sent to ${conversationId || peerId}`);
        setMessage("");
      } catch (error) {
        addLog(`Message send failed: ${error.message}`);
      }
    } else {
      addLog("Please enter message content");
    }
  };

  const getLocalConversations = async () => {
    try {
      const res = await miniCore.localCache.getLocalConversations();
      console.log(res);
    } catch (error) {
      addLog(`Failed to get local conversations: ${error.message}`);
    }
  };

  const fetchConversationFromServer = async () => {
    try {
      const res = await miniCore.getServerConversations({ pageSize: 50, cursor: '' });
      console.log(res);
    } catch (error) {
      addLog(`Failed to fetch conversations: ${error.message}`);
    }
  };

  const getServerPinnedMessages = async () => {
    const options = {
      conversationId: '261322593861633',
      conversationType: 'groupChat',
      pageSize: 50,
      cursor: '',
    };
    try {
      const res = await miniCore.getServerPinnedMessages(options);
      console.log(res);
    } catch (error) {
      addLog(`Failed to get pinned messages: ${error.message}`);
    }
  };

  const checkIfUserInChatroomMuteList = async () => {
    const res = await miniCore.isInChatRoomMutelist({
      chatRoomId: '274471627849729',
    })
    console.log(res);
  };
  const addLog = (log) => {
    setLogs((prevLogs) => [...prevLogs, log]);
  };

  useEffect(() => {

    // Use the contact plugin, "contact" is a fixed value.
    miniCore.usePlugin(contactPlugin, "contact");
    // Use the local storage plugin, "localCache" is a fixed value.
    miniCore.usePlugin(localCachePlugin, "localCache");

    miniCore.addEventHandler(CONNECTION_MESSAGE_EVENT, {
      onConnected: () => {
        setIsLoggedIn(true);
        addLog(`User ${userId} connected successfully!`);
      },
      onDisconnected: () => {
        setIsLoggedIn(false);
        addLog("User logged out!");
      },
      onTextMessage: (message) => {
        addLog(`${message.from}: ${message.msg}`);
        const option = {
          chatType: "singleChat",
          type: "channel",
          to: message.from,
        };
        const msg = AC.message.create(option);
        miniCore.send(msg);
      },
      onTokenWillExpire: () => addLog("Token is about to expire"),
      onTokenExpired: () => addLog("Token has expired"),
      onError: (error) => addLog(`Error: ${error.message}`),
    });

    miniCore.addEventHandler(CHATROOM_EVENT, {
      onChatroomEvent: (msg) => {
        switch (msg.operation) {
          case 'memberAbsence':
            addLog("Member absence");
            break;
          case 'memberPresence':
            addLog("Member presence");
            break;
          default:
            break;
        }
      },
    });
  }, []);

  return (
    <div style={{ width: "500px", display: "flex", gap: "10px", flexDirection: "column" }}>
      <h2>Agora Chat Examples</h2>
      {!isLoggedIn ? (
        <>
          <InputField label="UserID" value={userId} onChange={setUserId} placeholder="Enter the user ID" />
          <InputField label="Token" value={token} onChange={setToken} placeholder="Enter the token" />
          <Button onClick={handleLogin} text="Login" />
        </>
      ) : (
        <>
          <h3>Welcome, {userId}</h3>
          <Button onClick={handleLogout} text="Logout" />
          <InputField label="Peer userID" value={peerId} onChange={setPeerId} placeholder="Enter the peer user ID" />
          <InputField label="Peer message" value={message} onChange={setMessage} placeholder="Input message" />
          <InputField label="Conversation ID" value={conversationId} onChange={setConversationId} placeholder="Enter the conversation ID" />
          <InputField label="Conversation Type" value={conversationType} onChange={setConversationType} placeholder="Enter the conversation type" />
          <Button onClick={handleSendMessage} text="Send" />
        </>
      )}
      <Button onClick={getLocalConversations} text="Get Local Conversations" />
      <Button onClick={fetchConversationFromServer} text="Fetch Conversations" />
      <Button onClick={getServerPinnedMessages} text="Get Pinned Messages" />
      <Button onClick={checkIfUserInChatroomMuteList} text="Check if the member in Chatroom Mute List" />
      <h3>Operation log</h3>
      <LogDisplay logs={logs} />
    </div>
  );
}

const InputField = ({ label, value, onChange, placeholder }) => (
  <div>
    <label>{label}: </label>
    <input type="text" value={value} onChange={(e) => onChange(e.target.value)} placeholder={placeholder} />
  </div>
);

const Button = ({ onClick, text }) => (
  <button onClick={onClick}>{text}</button>
);

const LogDisplay = ({ logs }) => (
  <div style={{ height: "300px", overflowY: "auto", border: "1px solid #ccc", padding: "10px", textAlign: "left" }}>
    {logs.map((log, index) => (
      <div key={index}>{log}</div>
    ))}
  </div>
);

export default App;
