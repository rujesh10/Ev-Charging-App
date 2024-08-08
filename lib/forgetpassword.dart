import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_nist/helper.dart';
import 'package:project_nist/otp.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String phoneCode = "+977";
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = "";
  bool loader = false;
  saveValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("phoneNumber", phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
          behavior: MyBehaviour(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              forgetPasswordUi(),
              loader ? Helper.backdropFilter(context) : const SizedBox()
            ],
          )),
    );
  }

  forgetPasswordUi() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              const Text(
                "Forget Password",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              "Use your phone number to reset your password",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              "Enter your phone number",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Andika",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Phone",
                prefixIcon: const Padding(
                    padding: EdgeInsets.all(10), child: Icon(Icons.phone)),
              ),
              validator: ((value) {
                if (value!.isEmpty) {
                  return "field are required to be filled";
                } else if (value.length < 10) {
                  return "Phone number must have 10 digits";
                }
                return null;
              }),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value;
                });
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.001,
          ),
          Center(
            child: SizedBox(
              height: 45,
              width: 350,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  setState(() {
                    loader = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    saveValueToSharedPreference();
                    String? phone = phoneCode + phoneNumber;
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phone,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        setState(() {
                          loader = false;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpCode(
                                      number: phoneNumber,
                                      verificationId: verificationId,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                  }
                },
                child: const Text("Continue"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
