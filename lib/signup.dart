import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_nist/bloc/loginbloc.dart';
import 'package:project_nist/bloc/loginevent.dart';
import 'package:project_nist/login.dart';

import 'bloc/loginstate.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Future<void> _submitData() async {
    try {
      // Assuming 'users' is the reference to your Firestore collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Signup')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Email already exists, show an error message
        showEmailExistsSnackbar(context);
      } else {
        // Email doesn't exist, proceed with sign-up
        BlocProvider.of<LoginBloc>(context).add(SignupEvent(
            name: name,
            address: address,
            contact: contact,
            email: email,
            password: password,
            cpassword: cpassword));
      }
    } catch (e) {
      print(e);
    }
  }

  void showEmailExistsSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email already exists, please use a different email.'),
        duration: Duration(seconds: 10),
      ),
    );
  }

  bool notvisible = true;
  bool isVisible = true;
  String? name, address, contact, email, password, cpassword;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.isSuccessfull!) {
              // _resetLoginForm();
              // _navigateAfterDelay(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Start(),
                  ));
            } else {
              showInvalidCredentialsSnackbar(context);
            }
          }
        },
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/sl2.avif"),
                              fit: BoxFit.fill),
                        ),
                        // color: Color.fromARGB(255, 12, 40, 178),
                        height: 220,
                        width: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
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
                          height: 1000,
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
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Create an account",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Register your account today !",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                      name = value;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your name";
                                    }
                                    return null;
                                  }),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter your name",
                                      labelText: "Name"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      address = value;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your address";
                                    }
                                    return null;
                                  }),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter your address",
                                      labelText: "Address"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      contact = value;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your contact number";
                                    }
                                    return null;
                                  }),
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter your contact number",
                                      labelText: "Contact"),
                                ),
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
                                      hintText: "Enter your username or email",
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
                                      return "password field must be filed up";
                                    } else if (!RegExp("(?=.*[A-Z])")
                                        .hasMatch(value)) {
                                      return "Password must contain at least one uppercase letter\n";
                                    } else if (!RegExp((r'\d'))
                                        .hasMatch(value)) {
                                      return "Password must contain at least one digit\n";
                                    } else if (!RegExp((r'\W'))
                                        .hasMatch(value)) {
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
                                      border: OutlineInputBorder(),
                                      hintText: "Enter your password",
                                      labelText: 'Password'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: TextFormField(
                                  obscureText: isVisible,
                                  onChanged: (value) {
                                    setState(() {
                                      cpassword = value;
                                    });
                                  },
                                  validator: ((value) {
                                    if (value!.isEmpty) {
                                      return "password field must be filed up";
                                    } else if (!RegExp("(?=.*[A-Z])")
                                        .hasMatch(value)) {
                                      return "Password must contain at least one uppercase letter\n";
                                    } else if (!RegExp((r'\d'))
                                        .hasMatch(value)) {
                                      return "Password must contain at least one digit\n";
                                    } else if (!RegExp((r'\W'))
                                        .hasMatch(value)) {
                                      return "Password must contain at least one symbol\n";
                                    } else if (password != value) {
                                      return "Password didn't matched";
                                    } else {
                                      return null;
                                    }
                                  }),
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isVisible = !isVisible;
                                          });
                                        },
                                        child: Icon(isVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      border: OutlineInputBorder(),
                                      hintText: "Confirm password",
                                      labelText: 'Confirm Password'),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
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
                                      _isLoading
                                          ? const CircularProgressIndicator()
                                          : _submitData();
                                    }
                                  },
                                  child: Text("SIGN UP"),
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
                                    "Already have an account?",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Start(),
                                            ));
                                      },
                                      child: const Text(
                                        " Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ))
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
        ),
      ),
    );
  }
}
