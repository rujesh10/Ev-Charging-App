import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_nist/helper.dart';
import 'package:project_nist/login.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool loader = false;
  String? password;
  String? cpassword;
  var userId;
  updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString("phoneNumber") ?? "";

    if (phoneNumber.isNotEmpty) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where("contact", isEqualTo: int.parse(phoneNumber))
          .get();
      final user = response.docs.first;
      print("User ID: ${user.id}");

      setState(() {
        userId = user.id;
      });
    }
  }

  @override
  void initState() {
    updatePassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScrollConfiguration(
          behavior: MyBehaviour(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              createPasswordUi(),
              loader ? Helper.backdropFilter(context) : const SizedBox()
            ],
          )),
    );
  }

  createPasswordUi() {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const Text(
                "Privacy & Policy",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),

        // const Padding(
        //   padding: EdgeInsets.all(20),
        //   child: Center(
        //     child: Text(
        //       "Create a new password.",
        //       style: TextStyle(
        //         fontSize: 16.0,
        //         fontFamily: "Andika",
        //       ),
        //     ),
        //   ),
        // ),

        const Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "New Password",
            style: TextStyle(
              // color: Colors.grey,
              fontSize: 16.0,
              fontFamily: "Andika",
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: isVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = false;
                        });
                      },
                      icon: const Icon(Icons.visibility))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = true;
                        });
                      },
                      icon: const Icon(Icons.visibility_off)),
            ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "password field must be filed up";
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
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Re-Password",
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Andika",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: isVisible
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = false;
                        });
                      },
                      icon: const Icon(Icons.visibility))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = true;
                        });
                      },
                      icon: const Icon(Icons.visibility_off)),
            ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "field are required to be filled";
              } else if (password != value) {
                return "Password doesn't match";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                cpassword = value;
              });
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        Center(
          child: SizedBox(
            width: 360,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () async {
                // if (await Helper.checkInternetConnection()) {
                // delayFunction();
                if (_formKey.currentState!.validate()) {
                  loadingBlur(true);

                  FirebaseFirestore.instance
                      .collection("Signup")
                      .doc(userId)
                      .update({
                    'password': password,
                    'cpassword': cpassword
                  }).then((value) {
                    loadingBlur(false);
                    const snackBar = SnackBar(
                      content: Text('Password updated Successfully'),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Start()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print('Field updated successfully!');
                  }).catchError((error) {
                    loadingBlur(false);
                    print('Error updating field: $error');
                  });
                }
                // } else {
                //   loadingBlur(false);
                //   Helper.noInternetConnection(context);
                // }
              },
              child: Text("Confirm"),
            ),
          ),
        )
      ]),
    );
  }

  loadingBlur(bool value) {
    setState(() {
      loader = value;
    });
  }
}
