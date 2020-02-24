import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:found_it_admin_panel/provider/loginProvider.dart';
import 'package:found_it_admin_panel/views/login.dart';
import 'package:found_it_admin_panel/views/shareAbleWidget.dart/commonShareWidget.dart';
import 'package:provider/provider.dart';

import 'views/homePage.dart';

void main() => runApp(ChangeNotifierProvider<AuthService>(
  create: (BuildContext context)=>AuthService(),
child: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Found It admin panel',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
   home: FutureBuilder<FirebaseUser>(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console 
            if (snapshot.error != null) { 
             // print("error");
              return Text(snapshot.error.toString());
            }

            // if(snapshot.hasData){
            //    global.userEmail= snapshot.data.email.toString();
            // }
          

            // redirect to the proper page
            return snapshot.hasData ? HomePage() : LoginPage();
          } else {
            // show loading indicator
            return Scaffold(
              body: Center(
                child: CommonShareWidget.showLoader(),
              ),
            );
          }
        },
      ),
    );
  }
}

