import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lostarkbus/services/database.dart';
import 'package:lostarkbus/ui/navigation.dart';
import 'package:lostarkbus/util/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/mainController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'LostArk Bus',
      theme: ThemeData(
        //fontFamily: 'text',
        scaffoldBackgroundColor: AppColor.mainColor ,
      ),
      initialBinding: BindingsBuilder(() => {
            Get.put(MainController()),
          }),
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          //print(snapshot.data.uid);
          if (snapshot.data == null) {
            return MainPage();
          } else {
            String uid = snapshot.data.uid;
            return FutureBuilder(
                future: DatabaseService.instance.setUser(uid),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else{
                    return Navigation();
                  }
                });
          }
        });
  }
}

class MainPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("Login"),
          onPressed: () {
            signInAnon();
          },
        ),
      ),
    );
  }

  void signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }
}
