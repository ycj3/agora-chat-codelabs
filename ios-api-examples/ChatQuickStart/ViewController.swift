//
//  ViewController.swift
//  ChatQuickStart
//
//  Created by li xiaoming on 2022/10/2.
//

import UIKit
import AgoraChat

class ViewController: UIViewController {
    // Defines UIViews
    var userIdField, tokenField, groupIdIdField, textField: UITextField!
    var loginButton, logoutButton, sendButton, fetchCvsButton, fetchCvsWithTimerButton, deleteCvButton: UIButton!
    var logView: UITextView!

    func createField(placeholder: String?) -> UITextField {
        let field = UITextField()
        field.layer.borderWidth = 0.5
        field.placeholder = placeholder
        return field
    }

    func createButton(title: String?, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }

    func createLogView() -> UITextView {
        let logTextView = UITextView()
        logTextView.isEditable = false
        return logTextView
    }

    func initViews() {
        // creates UI controls
        userIdField = createField(placeholder: "User Id")
        self.view.addSubview(userIdField)
        tokenField = createField(placeholder: "Token")
        self.view.addSubview(tokenField)
        groupIdIdField = createField(placeholder: "Group Id")
        self.view.addSubview(groupIdIdField)
        textField = createField(placeholder: "Input text message")
        self.view.addSubview(textField)
        loginButton = createButton(title: "Login", action: #selector(loginAction))
        self.view.addSubview(loginButton)
        logoutButton = createButton(title: "Logout", action: #selector(logoutAction))
        self.view.addSubview(logoutButton)
        
        sendButton = createButton(title: "Send", action: #selector(sendAction) )
        self.view.addSubview(sendButton)
        
        fetchCvsButton = createButton(title: "Fetch Conversations From Server", action: #selector(fetchCvsFromServerAction) )
        self.view.addSubview(fetchCvsButton)
        
        fetchCvsWithTimerButton = createButton(title: "Fetch Conversations From Server With Timer", action: #selector(fetchCvsFromServerWithTimerAction) )
        self.view.addSubview(fetchCvsWithTimerButton)
        
        deleteCvButton = createButton(title: "Delete Conversation From Server", action: #selector(deleteCvFromServerAction) )
        self.view.addSubview(deleteCvButton)
        
        logView = createLogView()
        self.view.addSubview(logView)
        // Input userId and token which generated on console
        self.userIdField.text = "demo_user_1"
        self.tokenField.text = "007eJxTYOCsP9GxNclH2GHDTnmzkn1XsqbkK7ZcXaZwQ7ln8+yc3EcKDCnJxinJ5qmJBmYpFiYWpsmWyUZmqeZJiSkGJhbmScYmq2R80xsCGRnkHzgzMDKwAjEjA4ivwmCUkmJgbpZqoGuZYmiua2iYmqZraWaRpptkbmiZYpqWaJKaYgYAW98nOA=="
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Defines layout UI controls
        let fullWidth = self.view.frame.width
        userIdField.frame = CGRect(x: 30, y: 50, width: fullWidth - 60, height: 30)
        tokenField.frame = CGRect(x: 30, y: 100, width: fullWidth - 60, height: 30)
        loginButton.frame = CGRect(x: 30, y: 150, width: 80, height: 30)
        logoutButton.frame = CGRect(x: 230, y: 150, width: 80, height: 30)
        groupIdIdField.frame = CGRect(x: 30, y: 200, width: fullWidth - 60, height: 30)
        textField.frame = CGRect(x: 30, y: 250, width: fullWidth - 60, height: 30)
        sendButton.frame = CGRect(x: 30, y: 300, width: 80, height: 30)
        fetchCvsButton.frame = CGRect(x: 30, y: sendButton.frame.maxY + 10, width: 240, height: 30)
        fetchCvsWithTimerButton.frame = CGRect(x: 30, y: fetchCvsButton.frame.maxY + 10, width: fullWidth, height: 30)
        deleteCvButton.frame = CGRect(x: 30, y: fetchCvsWithTimerButton.frame.maxY + 10, width: fullWidth, height: 30)
        logView.frame = CGRect(x: 30, y: deleteCvButton.frame.maxY, width: fullWidth - 60, height: self.view.frame.height - 350 - 50)
    }
    
    func initChatSDK() {
            // Initializes the Agora Chat SDK
            let options = AgoraChatOptions(appkey: "61717166#1069763")
            options.isAutoLogin = false // disable auto login
            options.enableConsoleLog = true
            AgoraChatClient.shared.initializeSDK(with: options)
            // Adds the chat delegate to receive messages
            AgoraChatClient.shared.chatManager?.add(self, delegateQueue: nil)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initChatSDK()
    }

    // Outputs running log
    func printLog(_ log: Any...) {
        DispatchQueue.main.async {
            self.logView.text.append(
                DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
                + ":  " + String(reflecting: log) + "\r\n"
            )
            self.logView.scrollRangeToVisible(NSRange(location: self.logView.text.count, length: 1))
        }
    }
}

// Button action
extension ViewController {

    // login with the token.
    @objc func loginAction() {
        guard let userId = self.userIdField.text,
              let token = self.tokenField.text else {
            self.printLog("userId or token is empty")
            return;
        }
        let err = AgoraChatClient.shared.login(withUsername: userId, agoraToken: token)
        if err == nil {
            self.printLog("login success")
        } else {
            self.printLog("login failed:\(err?.errorDescription ?? "")")
        }
    }

    // Logs out.
    @objc func logoutAction() {
        AgoraChatClient.shared.logout(false) { err in
            if err == nil {
                self.printLog("logout success")
            }
        }
    }
}

var timer: Timer?
extension ViewController: AgoraChatManagerDelegate  {
    // Sends a text message.
    @objc func sendAction() {
        guard let groupId = groupIdIdField.text,
              let text = textField.text,
              let currentUserName = AgoraChatClient.shared.currentUsername else {
            self.printLog("Not login or groupId/text is empty")
            return
        }
        let msg = AgoraChatMessage(
            conversationId: groupId,
            from: currentUserName,
            to: groupId,
            body: .text(content: text), ext: nil
        )
        msg.chatType = .groupChat
        AgoraChatClient.shared.chatManager?.send(msg, progress: nil) { msg, err in
            if let err = err {
                self.printLog("send msg error.\(String(describing: err.errorDescription))")
            } else {
                self.printLog("send msg success")
            }
        }
    }
    
    @objc func fetchCvsFromServerAction() {
        AgoraChatClient.shared.chatManager?.getConversationsFromServer(withCursor: nil, pageSize: 20, completion: { result, error in
            if let err = error {
                self.printLog("fetch conversations error.\(String(describing: err.errorDescription))")
            } else {
                if let list = result?.list {
                    print("************************ conversation count=\(list.count)")
                    for conversation in list {
                        print("\(conversation.type)" + "\(String(describing: conversation.conversationId))")
                    }
                }
                self.printLog("fetch conversations success")
            }
        })
    }
    
    @objc func fetchCvsFromServerWithTimerAction() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            AgoraChatClient.shared.chatManager?.getConversationsFromServer(withCursor: nil, pageSize: 20, completion: { result, error in
                if let err = error {
                    self.printLog("fetch conversations error.\(String(describing: err.errorDescription))")
                } else {
                    if let list = result?.list {
                        print("************************ conversation count=\(list.count)")
                        for conversation in list {
                            print("\(conversation.type)" + "\(String(describing: conversation.conversationId))")
                            if conversation.conversationId == "265785401475073" {
                                timer?.invalidate()
                                timer = nil
                            }
                        }
                    }
                    self.printLog("fetch conversations success")
                }
            })
        }
    }
    
    @objc func deleteCvFromServerAction() {
        AgoraChatClient.shared.chatManager?.deleteServerConversation("265785401475073", conversationType: .groupChat, isDeleteServerMessages: true, completion: { id, error in
            if let err = error {
                self.printLog("delete conversations error.\(String(describing: err.errorDescription))")
            } else {
                self.printLog("delete conversation success")
            }
        })
    }
    
    func messagesDidReceive(_ aMessages: [AgoraChatMessage]) {
        for msg in aMessages {
            switch msg.swiftBody {
            case let .text(content):
                self.printLog("receive text msg,content: \(content)")
            default:
                break
            }
        }
    }
}
