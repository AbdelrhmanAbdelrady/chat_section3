import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore=FirebaseFirestore.instance;
late User signedInUser;
class ChatScreen extends StatefulWidget {
  static const String screenRoute='Chat_Screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;


  String messageText ="";

  get builder => null;
  @override
  void initState() {
// ignore: unused_local_variable
    String ? messageText;
    super.initState();
    getcurrentuser();
  }
  void getcurrentuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }
  void getmessage() async{
    final message=await _firestore.collection('message').get();
    for (var message in message.docs){
      print(message.data());
    }
  }
 /* void messageStream()async{
    await for(var snapshot in _firestore.collection('message').snapshots() ){
      for (var msg in snapshot.docs){
        print(msg.data());
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset(
              'images/chatIcon.png',
              height: 25,
            ),
            const SizedBox(width: 10),
            const Text('message me'),
          ],
        ),
        actions: [
          IconButton(
            onPressed:(){
        _auth.signOut();
        Navigator.pop(context);

             /* getmessage();
              messageStream();*/
            },
            icon: Icon(Icons.output),
          )
        ],
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuiIder(),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.cyan,
                        ))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText=value;
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection("messagea").add({
                          'text' :messageText,
                          'sender': signedInUser.email,
                          'time':FieldValue.serverTimestamp(),

                        });
                      },
                      child: const Text(
                        'send',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
class MessageStreamBuiIder extends StatelessWidget {
  const MessageStreamBuiIder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>
      (stream: _firestore.collection('messagea').orderBy('time').snapshots(),
        builder: (context, snapshots)
        {
          List<massegline>widgetmessage=[];
          if(!snapshots.hasData){

          }
          final message =snapshots.data!.docs.reversed;
          for (var msg in message) {
            final messageText=msg.get('text');
            final msgSender=msg.get('sender');
            final cruuntUser =signedInUser.email;



            final widget= massegline(
                sender: msgSender,
                text:messageText ,
                isme:cruuntUser ==msgSender
            );
            widgetmessage.add(widget);
          }
          return Expanded(
            child: ListView(
             reverse:true ,
              padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                children: widgetmessage,

            ),
          );

        },);

  }
}

class massegline extends StatelessWidget {
  const massegline({this.sender,required this.isme,this.text, super.key});
final String? sender;
final String? text;
final bool isme ;


  @override
  Widget build(BuildContext context) {
     return Padding(
        padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: isme? CrossAxisAlignment.end:CrossAxisAlignment.start,

      children: [
        Text("$sender",style: TextStyle(fontSize: 12,color: Colors.black38),),
        Material(
          elevation: 5,
          borderRadius: isme? BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight:  Radius.circular(30),

          ):BorderRadius.only(
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight:  Radius.circular(30),

          ),
        color:isme? Colors.blue [800]:Colors.red,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Text(
           '$text' ,
          style: TextStyle (fontSize:15,color:Colors.white,),),
        )),
      ],
    ));
  }
}
