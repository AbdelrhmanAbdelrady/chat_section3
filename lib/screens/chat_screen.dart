import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String screenRoute='Chat_Screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore =FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
  late User signedInUser;
  String? messageText;
  @override
  void  initState(){
    super.initState();
  getCurrentUser();
  }

  void getCurrentUser(){


    try{ final user =_auth.currentUser;
    if (user!=null){
      signedInUser=user;
      print(signedInUser.email);

    }}
    catch (e){
      print(e);
    }
  }
 /*void getMessages() async{
      final  messages= await _firestore.collection('messages').get();
      for(var message in messages.docs){
     print(message.data());


      }
 }*/
void messagesStreams()async{
  await for (var snapshot in _firestore.collection('messages').snapshots()){
    for(var masg in snapshot.docs ){
      print(masg.data());
    };
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              messagesStreams();

              /*
              _auth.signOut();
              Navigator.pop(context);*/
            },
            icon: Icon(Icons.download),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {

                       messageText=value;



                      },


                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender':signedInUser.email,
                      });
                      
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
