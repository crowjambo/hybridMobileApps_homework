import '../utility/globals.dart' as globals;
import '../businessLogic/login_screen_bl.dart';
import '../screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 8,
          title: Text(
            'Please Login',
            style: TextStyle(fontSize: globals.kBigHeaderSize),
          ),
        ),
        body: _LoginBody());
  }
}

class _LoginBody extends StatefulWidget {
  @override
  __LoginBodyState createState() => __LoginBodyState();
}

class __LoginBodyState extends State<_LoginBody> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreenBL loginScreenBL = LoginScreenBL();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        child: Container(
          height: 250,
          padding: EdgeInsets.all(globals.kDefaultPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: "Email"),
                controller: usernameController,
              ),
              TextField(
                decoration: InputDecoration(hintText: "Password"),
                controller: passwordController,
              ),
              Row(
                children: [
                  Checkbox(
                    value: loginScreenBL.rememberMe,
                    onChanged: (bool newValue) {
                      setState(() {
                        loginScreenBL.rememberMe = newValue;
                      });
                    },
                  ),
                  Text("Remember Me?")
                ],
              ),
              RaisedButton(
                  child: Text("Login"),
                  onPressed: () {
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                    } else {
                      _loginPressed();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  void _loginPressed() {
    loginScreenBL.userName = usernameController.text;
    loginScreenBL.password = passwordController.text;
    loginScreenBL.loginUser().then((value) {
      if (value == 2) {
      } else if (value == 3) {
      } else if (value == 1) {
      } else if (value == 0) {
        //successful login
        print(loginScreenBL.userData.toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                HomeScreen(loginScreenBL.userData)));
      }
    });
  }
}
