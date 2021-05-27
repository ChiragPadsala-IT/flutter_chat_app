import 'package:chat_app/helper/login_helper.dart';
import 'package:chat_app/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String email;
  String password;

  login() async {
    ///check email/username and password is correct or not
    if (_loginFormKey.currentState.validate()) {
      ///save form fields data
      _loginFormKey.currentState.save();

      if (await LoginHelper.login(email: email, password: password)) {
        ///show snackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome to chat app"),
          ),
        );

        ///switch chatRoom screen
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      } else {
        /// show snackBar if sign in failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${auth.exception.message}"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          margin: EdgeInsets.only(bottom: 10),
          height: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    CircleAvatar(
                      child: Icon(Icons.chat),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text("My chat",style: TextStyle(fontSize: 24),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          validator: (val) {
                            if (val.isNotEmpty || val != null) {
                              if (EmailValidator.validate(val)) {
                                return null;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "This email address is not valid please enter valid email address ...")));
                                return "Your email address not valid";
                              }
                            } else {
                              return "enter your email address";
                            }
                          },
                          onSaved: (val) {
                            email = val;
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                            prefixIcon: Icon(CupertinoIcons.mail),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (val) {
                            if (val.length < 6 || val == null) {
                              return "Password must be more than 6 character";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            password = val;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            prefixIcon: Icon(CupertinoIcons.lock),
                          ),
                        ),
                        SizedBox(height: 15),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: ElevatedButton(
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: () async {
                              login();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: "Don't have account?\t\t",
                            style: TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .pushNamed("/sign_up_screen");
                                  },
                                style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
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
}
