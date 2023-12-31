import 'package:chat3/firebase_options.dart';
import 'package:chat3/screens/chat_screen.dart';
import 'package:chat3/screens/registration_screen.dart';
import 'package:chat3/screens/signin_screen.dart';
import 'package:chat3/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MessageMe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     /* home: WelcomeScreen(),*/
        initialRoute: _auth.currentUser != null?
        ChatScreen.screenRoute:
        WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute:(context)=>WelcomeScreen(),
          SignInScreen.screenRoute:(context)=>SignInScreen(),
          RegistrationScreen.screenRoute:(context)=>RegistrationScreen(),
          ChatScreen.screenRoute:(context)=>ChatScreen(),
    }
    );
  }
}
