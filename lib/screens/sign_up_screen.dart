import 'package:chat_app/helper/signup_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  static String username;
  static String email;
  static String password;

  ///method for validate form field
  validate() async {
    if (_signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();

      if (await SignUpHelper.SignUp(
          username: username, email: email, password: password)) {
        ///show snackBar if signUp successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome to chat app"),
          ),
        );

        ///navigate to chatRoom screen
        Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${SignUpHelper.exception}")));
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
                key: _signUpFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    CircleAvatar(
                      child: Icon(Icons.chat),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text("My chat",style: TextStyle(fontSize: 24),),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          validator: (val) {
                            if (val.isEmpty || val == null || val.length < 6) {
                              return "username must be greater than 6";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Username",
                            hintText: "Enter your username",
                            prefixIcon: Icon(CupertinoIcons.person),
                          ),
                        ),
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
                            if (val.isEmpty || val == null || val.length < 6) {
                              return "Enter valid password";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            prefixIcon: Icon(CupertinoIcons.lock),
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            if (_passwordController.text != val ||
                                val.isEmpty) {
                              return "Re-Enter password not matched";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            username = _usernameController.text;
                            email = _emailController.text;
                            password = _passwordController.text;
                          },
                          decoration: InputDecoration(
                            labelText: "Re-Enter Password",
                            hintText: "Re-Enter your password",
                            prefixIcon: Icon(CupertinoIcons.lock),
                          ),
                        ),
                        SizedBox(height: 15),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: ElevatedButton(
                            child: Text(
                              "SignUp",
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: () async {
                              validate();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
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
