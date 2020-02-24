import 'package:flutter/material.dart';
import 'package:found_it_admin_panel/constant/colors.dart';
import 'package:found_it_admin_panel/provider/loginProvider.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'shareAbleWidget.dart/commonShareWidget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
 final _formKey = GlobalKey<FormState>();
 bool _loaderState=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: ModalProgressHUD(
        inAsyncCall: _loaderState,
        color: AppColor.transparentColor,
        progressIndicator: CommonShareWidget.showLoader(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Form(
          autovalidate: true,
          key: _formKey,
                  child: Container(
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: kToolbarHeight * 2,
                    ),
                    Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Image.asset(
                            'assets/images/found_it_logo.jpeg',
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    TextFormField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      validator: (v){
                        if(v.isEmpty)return "Enter email";
                        return isEmail(v);

                      },
                    ),
                    
             
                    SizedBox(
                      height: 10.0,
                    ),
                    
                   TextFormField(
                      controller: _controllerPassword,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                      ),
                      validator: (v){
                        if(v.isEmpty)return "Enter password";
                        if(v.length<6)return "password must be at least 6";
                        return null;

                      },
                    ),
                  
                    SizedBox(
                      height: 20.0,
                    ),
                    CommonShareWidget.signInUpbutton("SIGN IN", () {
                     
                     if (_formKey.currentState.validate()) {
                       handleSubmit();
                     }
                    }, context),
                    SizedBox(
                      height: 5.0,
                    ),
                    
                  ],
                ),
            ),
          ),
        ),
              ),
      ),
    );
  }
  isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em) ? null : "Enter correct Email address";
  }
  handleSubmit()async{
              if (mounted) {
            setState(() {
              _loaderState = true;
            });
          }

          try {
            await Provider.of<AuthService>(context,listen: false)
                .loginUser(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text)
                .then((onValue) {
              

            });
          } on AuthException catch (error) {
            if (mounted)
              setState(() {
                _loaderState = false;
              });
            return CommonShareWidget.buildErrorDialog(context, error.message);
          } on Exception catch (error) {
            if (mounted)
              setState(() {
                _loaderState = false;
              });
            return CommonShareWidget.buildErrorDialog(context, error.toString());
          }

  }

 
}