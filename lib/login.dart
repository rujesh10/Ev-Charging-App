import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_nist/bloc/loginbloc.dart';
import 'package:project_nist/bloc/loginstate.dart';
import 'package:project_nist/bottomnav.dart';
import 'package:project_nist/dashboard.dart';
import 'package:project_nist/forgetpassword.dart';
import 'package:project_nist/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/loginevent.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

void showInvalidCredentialsSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      behavior: SnackBarBehavior.floating,
      content: const Text(
        "Invalid Credentials!",
        style: TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

class _StartState extends State<Start> {
  saveValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
    await prefs.setString("email", email!);
  }

  bool notvisible = true;
  // bool isVisible = false;
  String? email;
  String? password;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.isSuccessfull!) {
            saveValueToSharedPreference();
            // _resetLoginForm();
            // _navigateAfterDelay(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavigation(),
                ));
          } else {
            showInvalidCredentialsSnackbar(context);
          }
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/loginbg.jpg"),
                            fit: BoxFit.cover),
                      ),
                      // color: Color.fromARGB(255, 12, 40, 178),
                      // color: Colors.black,
                      height: 270,
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 200,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        height: MediaQuery.of(context).size.height * 0.78,
                        width: 500,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: const [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 1),
                                      child: Text(
                                        "Welcome Back",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 23),
                                      child: Text(
                                        "Hello there sign in to continue",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: ((value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return "Enter a valid email!";
                                  }
                                  return null;
                                }),
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Enter your username",
                                    labelText: "Email"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextFormField(
                                obscureText: notvisible,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return "Password field should not be empty";
                                  } else if (!RegExp("(?=.*[A-Z])")
                                      .hasMatch(value)) {
                                    return "Password must contain at least one uppercase letter\n";
                                  } else if (!RegExp((r'\d')).hasMatch(value)) {
                                    return "Password must contain at least one digit\n";
                                  } else if (!RegExp((r'\W')).hasMatch(value)) {
                                    return "Password must contain at least one symbol\n";
                                  } else {
                                    return null;
                                  }
                                }),
                                decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          notvisible = !notvisible;
                                        });
                                      },
                                      child: Icon(notvisible
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    border: const OutlineInputBorder(),
                                    hintText: "Enter your password",
                                    labelText: 'Password'),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: InkWell(
                                      onTap: () {},
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ForgetPassword(),
                                                ));
                                          },
                                          child:
                                              const Text("Forget Password?"))),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            SizedBox(
                              width: 350,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                              SizedBox(height: 10),
                                              Text("Logging In..."),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                    Timer(const Duration(seconds: 2), () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        LoginEvents(
                                            email: email, password: password),
                                      );

                                      Navigator.pop(
                                          context); // Close the dialog
                                    });
                                  }
                                },
                                child: Text("LOGIN"),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ));
                                  },
                                  child: const Text(
                                    " Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
