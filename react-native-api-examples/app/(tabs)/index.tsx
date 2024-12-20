import { Image, StyleSheet, Platform, ScrollView, View, TextInput, Text, SafeAreaView } from 'react-native';

import { HelloWave } from '@/components/HelloWave';
import ParallaxScrollView from '@/components/ParallaxScrollView';
import { ThemedText } from '@/components/ThemedText';
import { ThemedView } from '@/components/ThemedView';
import {
  ChatClient,
  ChatOptions,
  ChatMessageChatType,
  ChatMessage,
} from 'react-native-agora-chat';
import { useEffect } from 'react';

export default function HomeScreen() {
  function login() {
    
  }
  function logout() {
    
  }
  function sendmsg() {
    
  }
  useEffect(() => {
    ChatClient.getInstance().init(new ChatOptions({autoLogin: false, appKey: "61717166#1069763", debugModel: true})).catch(error => {
      console.log(error)
    });

  }, [ChatClient]);

  return (
    <SafeAreaView>
      <View style={styles.titleContainer}>
        <Text style={styles.title}>Api Examples</Text>
      </View>
      <ScrollView>
          <View style={styles.inputCon}>
            <TextInput
              multiline
              style={styles.inputBox}
              placeholder="Enter username"
              // onChangeText={text => setUsername(text)}
              // value={username}
            />
          </View>
          <View style={styles.inputCon}>
            <TextInput
              multiline
              style={styles.inputBox}
              placeholder="Enter chatToken"
              // onChangeText={text => setChatToken(text)}
              // value={chatToken}
            />
          </View>
          <View style={styles.buttonCon}>
            <Text style={styles.eachBtn} onPress={login}>
              SIGN IN
            </Text>
            <Text style={styles.eachBtn} onPress={logout}>
              SIGN OUT
            </Text>
          </View>
          <View style={styles.inputCon}>
            <TextInput
              multiline
              style={styles.inputBox}
              placeholder="Enter the username you want to send"
              // onChangeText={text => setTargetId(text)}
              // value={targetId}
            />
          </View>
          <View style={styles.inputCon}>
            <TextInput
              multiline
              style={styles.inputBox}
              placeholder="Enter content"
              // onChangeText={text => setContent(text)}
              // value={content}
            />
          </View>
          <View style={styles.buttonCon}>
            <Text style={styles.btn2} onPress={sendmsg}>
              SEND TEXT
            </Text>
          </View>
          <View>
            {/* <Text style={styles.logText} multiline={true}>
              {logText}
            </Text> */}
          </View>
          <View>
            <Text style={styles.logText}>{}</Text>
          </View>
          <View>
            <Text style={styles.logText}>{}</Text>
          </View>
      </ScrollView>
    </SafeAreaView>
    // <ParallaxScrollView
    //   headerBackgroundColor={{ light: '#A1CEDC', dark: '#1D3D47' }}
    //   headerImage={
    //     <Image
    //       source={require('@/assets/images/partial-react-logo.png')}
    //       style={styles.reactLogo}
    //     />
    //   }>
    //   <ThemedView style={styles.titleContainer}>
    //     <ThemedText type="title">Welcome!</ThemedText>
    //     <HelloWave />
    //   </ThemedView>
    //   <ThemedView style={styles.stepContainer}>
    //     <ThemedText type="subtitle">Step 1: Try it</ThemedText>
    //     <ThemedText>
    //       Edit <ThemedText type="defaultSemiBold">app/(tabs)/index.tsx</ThemedText> to see changes.
    //       Press{' '}
    //       <ThemedText type="defaultSemiBold">
    //         {Platform.select({
    //           ios: 'cmd + d',
    //           android: 'cmd + m',
    //           web: 'F12'
    //         })}
    //       </ThemedText>{' '}
    //       to open developer tools.
    //     </ThemedText>
    //   </ThemedView>
    //   <ThemedView style={styles.stepContainer}>
    //     <ThemedText type="subtitle">Step 2: Explore</ThemedText>
    //     <ThemedText>
    //       Tap the Explore tab to learn more about what's included in this starter app.
    //     </ThemedText>
    //   </ThemedView>
    //   <ThemedView style={styles.stepContainer}>
    //     <ThemedText type="subtitle">Step 3: Get a fresh start</ThemedText>
    //     <ThemedText>
    //       When you're ready, run{' '}
    //       <ThemedText type="defaultSemiBold">npm run reset-project</ThemedText> to get a fresh{' '}
    //       <ThemedText type="defaultSemiBold">app</ThemedText> directory. This will move the current{' '}
    //       <ThemedText type="defaultSemiBold">app</ThemedText> to{' '}
    //       <ThemedText type="defaultSemiBold">app-example</ThemedText>.
    //     </ThemedText>
    //   </ThemedView>
    // </ParallaxScrollView>
  );
}

// Sets UI styles.
const styles = StyleSheet.create({
  titleContainer: {
    height: 60,
    backgroundColor: '#6200ED',
  },
  title: {
    lineHeight: 60,
    paddingLeft: 15,
    color: '#fff',
    fontSize: 20,
    fontWeight: '700',
  },
  inputCon: {
    marginLeft: '5%',
    width: '90%',
    height: 60,
    paddingBottom: 6,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  inputBox: {
    marginTop: 15,
    width: '100%',
    fontSize: 14,
    fontWeight: 'bold',
  },
  buttonCon: {
    marginLeft: '2%',
    width: '96%',
    flexDirection: 'row',
    marginTop: 20,
    height: 26,
    justifyContent: 'space-around',
    alignItems: 'center',
  },
  eachBtn: {
    height: 40,
    width: '28%',
    lineHeight: 40,
    textAlign: 'center',
    color: '#fff',
    fontSize: 16,
    backgroundColor: '#6200ED',
    borderRadius: 5,
  },
  btn2: {
    height: 40,
    width: '45%',
    lineHeight: 40,
    textAlign: 'center',
    color: '#fff',
    fontSize: 16,
    backgroundColor: '#6200ED',
    borderRadius: 5,
  },
  logText: {
    padding: 10,
    marginTop: 10,
    color: '#ccc',
    fontSize: 14,
    lineHeight: 20,
  },
});
