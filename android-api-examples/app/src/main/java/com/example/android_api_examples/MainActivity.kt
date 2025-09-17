package com.example.android_api_examples

import android.R.attr.button
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.example.android_api_examples.ui.theme.AndroidapiexamplesTheme
import io.agora.CallBack
import io.agora.ValueCallBack
import io.agora.chat.ChatClient
import io.agora.chat.ChatOptions
import io.agora.chat.Conversation
import io.agora.chat.ChatManager;
import io.agora.chat.CursorResult

class MainActivity : ComponentActivity() {
    private lateinit var usernameInput: EditText
    private lateinit var passwordInput: EditText
    private lateinit var messageInput: EditText
    private lateinit var chatLog: TextView
    private lateinit var loginButton: Button
    private lateinit var sendButton: Button

    private lateinit var asyncFetchConversationsFromServerButton: Button

    private fun showLog(text: String) {
        // Show a toast message
        runOnUiThread { Toast.makeText(applicationContext, text, Toast.LENGTH_SHORT).show() }


        // Write log
        Log.d("AgoraChatQuickStart", text)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        usernameInput = findViewById(R.id.usernameInput)
        passwordInput = findViewById(R.id.passwordInput)
        messageInput = findViewById(R.id.messageInput)
        chatLog = findViewById(R.id.chatLog)
        loginButton = findViewById(R.id.loginButton)
        sendButton = findViewById(R.id.sendButton)
        asyncFetchConversationsFromServerButton = findViewById(R.id.asyncFetchConversationsFromServer)

        var options = ChatOptions()
        options.appKey = "INPUT YOUR APPKEY HERE"
        ChatClient.getInstance().init(this, options)
        ChatClient.getInstance().setDebugMode(true)

        loginButton.setOnClickListener {
            val username = usernameInput.text.toString()
            val password = passwordInput.text.toString()
            ChatClient.getInstance().loginWithToken(username, password, object : CallBack {
                override fun onSuccess() {
                    showLog("Signed in");
                }

                override fun onError(code: Int, error: String) {
                    if (code == 200) {
                    } else {
                        showLog(error)
                    }
                }
            });
        }

        fun doAsyncFetchConversationsFromServer(
            limit: Int,
            cursor: String,
            conversations: MutableList<Conversation>
        ) {
            ChatClient.getInstance().chatManager().asyncFetchConversationsFromServer(
                limit,
                cursor,
                object : ValueCallBack<CursorResult<Conversation>> {
                    override fun onSuccess(value: CursorResult<Conversation>?) {
                        value?.data?.let { list ->
                            if (list.isNotEmpty()) {
                                list.forEach { item ->
                                    Log.d("DEBUG_TAG", "item ID = ${item.conversationId()}")
                                }
                                conversations.addAll(list)
                            }
                        }
                        value?.cursor?.takeIf { it.isNotEmpty() }?.let { newCursor ->
                            doAsyncFetchConversationsFromServer(limit, newCursor, conversations)
                        }
                    }

                    override fun onError(error: Int, errorMsg: String?) {
                        // 处理错误
                    }
                }
            )
        }

        sendButton.setOnClickListener {
            // TODO
        }

        asyncFetchConversationsFromServerButton.setOnClickListener {
            val limit = 40
            var cursor = ""
            val conversations = mutableListOf<Conversation>()
            doAsyncFetchConversationsFromServer(limit, cursor, conversations)
        }
    }

}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}

@Preview(showBackground = true)
@Composable
fun GreetingPreview() {
    AndroidapiexamplesTheme {
        Greeting("Android")
    }
}