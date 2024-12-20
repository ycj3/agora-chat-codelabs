import { useEffect, useState, useRef } from "react";
import "./App.css";
import AC from "agora-chat";

function App() {
  // Replaces <Your app key> with your app key.
  const appKey = "61717166#1069763";
  const [userId, setUserId] = useState("");
  const [token, setToken] = useState("");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [peerId, setPeerId] = useState("");
  const [message, setMessage] = useState("");
  const [logs, setLogs] = useState([]);
  const chatClient = useRef(null);

  // Logs into Agora Chat.
  const handleLogin = () => {
    if (userId && token) {
      chatClient.current.open({
        user: userId,
        accessToken: token,
      });
    } else {
      addLog("Please enter userId and token");
    }
  };

  // Logs out.
  const handleLogout = () => {
    chatClient.current.close();
    setIsLoggedIn(false);
    setUserId("");
    setToken("");
    setPeerId("");
  };

   // Sends a peer-to-peer message.
   const handleSendMessage = async () => {
    if (message.trim()) {
      try {
        const option = {
          chatType: "singleChat", // Sets the chat type as a one-to-one chat.
          type: "txt", // Sets the message type.
          to: peerId, // Sets the recipient of the message with user ID.
          msg: message, // Sets the message content.
        };
        let msg = AC.message.create(option);

        await chatClient.current.send(msg);
        addLog(`Message send to ${peerId}: ${message}`);
        setMessage("");
      } catch (error) {
        addLog(`Message send failed: ${error.message}`);
      }
    } else {
      addLog("Please enter message content");
    }
  };

  const fetchConversationFromServer = async () => {
    await chatClient.current.getServerConversations({pageSize:50, cursor: ''}).then((res)=>{
      console.log(res)
  })
  }
  
  // Add log.
  const addLog = (log) => {
    setLogs((prevLogs) => [...prevLogs, log]);
  };

  useEffect(() => {
    // Initializes the Web client.
    chatClient.current = new AC.connection({
      appKey: appKey,
    });

    // Adds the event handler.
    chatClient.current.addEventHandler("connection&message", {
      // Occurs when the app is connected to Agora Chat.
      onConnected: () => {
        setIsLoggedIn(true);
        addLog(`User ${userId} Connect success !`);
      },
      // Occurs when the app is disconnected from Agora Chat.
      onDisconnected: () => {
        setIsLoggedIn(false);
        addLog(`User Logout!`);
      },
      // Occurs when a text message is received.
      onTextMessage: (message) => {
        addLog(`${message.from}: ${message.msg}`);
        let option = {
          chatType: "singleChat", // The chat type: singleChat for one-to-one chat.
          type: "channel", // The type of read receipt: channel indicates the conversation read receipt.
          to: message.from, // The user ID of the message receipt.
        };
        let msg = AC.message.create(option);
        chatClient.current.send(msg);        
      },
      // Occurs when the token is about to expire.
      onTokenWillExpire: () => {
        addLog("Token is about to expire");
      },
      // Occurs when the token has expired.
      onTokenExpired: () => {
        addLog("Token has expired");
      },
      onError: (error) => {
        addLog(`on error: ${error.message}`);
      },
    });

    chatClient.current.addEventHandler("ChatroomEvent", {
      onChatroomEvent: function(msg){
        switch(msg.operation){
             // Occurs when all the chat room members are unmuted.
            case 'unmuteAllMembers':
                break;
            // Occurs when all the chat room members are muted.
            case 'muteAllMembers':
                break;
            // Occurs when a member is removed from the chat room allow list.
            case 'removeAllowlistMember':
                break;
            // Occurs when a member is added to the chat room allow list.
            case 'addUserToAllowlist':
                break;
            // Occurs when a member deletes a chat room announcement.
            case 'deleteAnnouncement':
                break;
            // Occurs when a member updates a chat room announcement.
            case 'updateAnnouncement':
                break;
            // Occurs when a member is removed from the chat room mute list.
            case 'unmuteMember':
                break;
            // Occurs when a member is added to the chat room mute list.
            case 'muteMember':
                break;
            // Occurs when a chat room admin is removed from the admin list.
            case 'removeAdmin':
                break;
            // Occurs when a chat room member is added to the admin list.
            case 'setAdmin':
                break;
            // Occurs when the chat room owner is changed.
            case 'changeOwner':
                break;
            // Occurs when a chat room member leaves a chat room.
            case 'memberAbsence':
              addLog("memberAbsence");
            // Occurs when a user joins a chat room.
            case 'memberPresence':
              addLog("memberPresence");
            // Occurs when custom chat room attributes are set or changed.
            case 'updateChatRoomAttributes':
                break;
            // Occurs when custom chat room attributes are removed.
            case 'removeChatRoomAttributes':
                break;
            default:
                break;
        }
      }
    })
    
  }, []);

  return (
    <>
      <div
        style={{
          width: "500px",
          display: "flex",
          gap: "10px",
          flexDirection: "column",
        }}
      >
        <h2>Agora Chat Examples</h2>
        {!isLoggedIn ? (
          <>
            <div>
              <label>UserID: </label>
              <input
                type="text"
                value={userId}
                onChange={(e) => setUserId(e.target.value)}
                placeholder="Enter the user ID"
              />
            </div>
            <div>
              <label>Token: </label>
              <input
                type="text"
                value={token}
                onChange={(e) => setToken(e.target.value)}
                placeholder="Enter the token"
              />
            </div>
            <button onClick={handleLogin}>Login</button>
          </>
        ) : (
          <>
            <h3>Welcome, {userId}</h3>
            <button onClick={handleLogout}>Logout</button>
            <div>
              <label>Peer userID: </label>
              <input
                type="text"
                value={peerId}
                onChange={(e) => setPeerId(e.target.value)}
                placeholder="Enter the peer user ID"
              />
            </div>
            <div>
              <label>Peer message: </label>
              <input
                type="text"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="Input message"
              />
              <button onClick={handleSendMessage}>Send</button>
            </div>
          </>
        )}
      <button onClick={fetchConversationFromServer}>fetchConversationFromServer</button>
        <h3>Operation log</h3>
        <div
          style={{
            height: "300px",
            overflowY: "auto",
            border: "1px solid #ccc",
            padding: "10px",
            textAlign: "left",
          }}
        >
          {logs.map((log, index) => (
            <div key={index}>{log}</div>
          ))}
        </div>
      </div>
    </>
  );
}

export default App;
