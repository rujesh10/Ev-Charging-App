import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Future<void> updatePasswordInFirestore() async {
    String? email = getUserEmail();

    await FirebaseFirestore.instance
        .collection('Signup')
        .doc(email)
        .update({'password': newpassword});
  }

  String? getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  getDataFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    if (email!.isNotEmpty) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where("email", isEqualTo: email)
          .get();
      final user = response.docs.first;
      password = user.data()['password'] ?? "";

      setState(() {
        password;
        userId = user.id;
      });
    }
  }

  Future<void> updateNewPasswordInFirestore(String newpassword) async {
    String? email = getUserEmail();
    print('Email retrieved from Firebase Auth: $email');
    if (email != null) {
      await FirebaseFirestore.instance
          .collection('Signup')
          .doc(email)
          .update({'password': newpassword});
    }
  }

// onPressed: () {
//   if (_formKey.currentState!.validate()) {
//     updatePasswordInFirestore();
//   }
// },
  var userId;
  String? password;
  String? email;
  String? oldpassword, newpassword, cpassword;
  final _formKey = GlobalKey<FormState>();
  bool notvisible = true;
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const Text(
                        "Change Password",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    obscureText: isVisible,
                    onChanged: (value) {
                      setState(() {
                        oldpassword = value;
                      });
                    },
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Password field can not be empty";
                      } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
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
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: "Enter your old password",
                        labelText: 'Old Password'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    obscureText: isVisible,
                    onChanged: (value) {
                      setState(() {
                        newpassword = value;
                      });
                    },
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Password field can not be empty";
                      } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
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
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Create a new password",
                        labelText: 'New Password'),
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
                        return "Password field must can not be empty";
                      } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                        return "Password must contain at least one uppercase letter\n";
                      } else if (!RegExp((r'\d')).hasMatch(value)) {
                        return "Password must contain at least one digit\n";
                      } else if (newpassword != value) {
                        return "Password didn't matched";
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
                              isVisible = !isVisible;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        border: OutlineInputBorder(),
                        hintText: "Confirm your new password",
                        labelText: 'Confirm New Password'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 350,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection("Signup")
                            .doc(userId)
                            .update({
                          'password': newpassword,
                          'cpassword': cpassword
                        }).then((value) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Password Changed"),
                                content: Text(
                                    "Your password has been successfully changed."),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        });
                      }
                    },
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
