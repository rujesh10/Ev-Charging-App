import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_nist/createpassword.dart';
import 'package:project_nist/helper.dart';

class OtpCode extends StatefulWidget {
  String? number;
  String? verificationId;

  OtpCode({Key? key, this.number, this.verificationId}) : super(key: key);

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String> otpPin = List.filled(6, "", growable: false);
  String code = "";
  bool loader = false;
  Timer? _resendTimer;
  int _resendDelay = 30;

  final _formKey = GlobalKey<FormState>();
  FocusNode b1 = FocusNode();
  FocusNode b2 = FocusNode();
  FocusNode b3 = FocusNode();
  FocusNode b4 = FocusNode();
  FocusNode b5 = FocusNode();
  FocusNode b6 = FocusNode();
  FocusNode verify = FocusNode();

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendDelay > 0) {
          _resendDelay--;
        } else {
          _resendTimer?.cancel();
        }
      });
    });
  }

  void resendOTP() async {
    // OTP resend logic

    if (_resendTimer == null) {
      String? phone = widget.number;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            loader = false;
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpCode(
                        number: widget.number,
                        verificationId: verificationId,
                      )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
    setState(() {
      otpPin = List.filled(6, "", growable: false);
      code = "";
      _resendDelay = 30;
    });

    // Start the resend timer
    startResendTimer();
  }

  @override
  void initState() {
    super.initState();
    // Start the resend timer when the widget is initialized
    startResendTimer();
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
            otpUi(),
            loader ? Helper.backdropFilter(context) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget otpUi() {
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
                "OTP Verification",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
            child: Text(
              "Code has been sent to ${widget.number}",
              style: const TextStyle(
                fontSize: 16.0,
                fontFamily: "Andika",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                for (int i = 0; i < otpPin.length; i++) ...[
                  Expanded(
                    child: TextFormField(
                      focusNode: i == 0
                          ? b1
                          : i == 1
                              ? b2
                              : i == 2
                                  ? b3
                                  : i == 3
                                      ? b4
                                      : i == 4
                                          ? b5
                                          : b6,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [LengthLimitingTextInputFormatter(1)],
                      onChanged: (value) {
                        setState(() {
                          otpPin[i] = value;
                          if (value.isNotEmpty) {
                            if (i == otpPin.length - 1) {
                              verify.requestFocus();
                            } else {
                              otpPin[i + 1] = "";
                              FocusNode nextFocusNode = i == 0
                                  ? b2
                                  : i == 1
                                      ? b3
                                      : i == 2
                                          ? b4
                                          : i == 3
                                              ? b5
                                              : b6;
                              FocusScope.of(context)
                                  .requestFocus(nextFocusNode);
                            }
                          }
                        });
                      },
                    ),
                  ),
                  if (i < otpPin.length - 1)
                    const SizedBox(
                      width: 10,
                    ),
                ],
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Center(
            child: SizedBox(
              width: 350,
              height: 40,
              child: ElevatedButton(
                focusNode: verify,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Validate the OTP fields
                    code = otpPin.join();

                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verificationId!,
                        smsCode: code,
                      );

                      setState(() {
                        loader = true;
                      });

                      // Sign in with the credential
                      await auth.signInWithCredential(credential);

                      setState(() {
                        loader = false;
                      });

                      // Navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreatePassword()),
                      );
                    } catch (e) {
                      setState(() {
                        loader = false;
                      });

                      const snackBar = SnackBar(
                        content: Text('Wrong OTP'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                child: Text("Verify"),
                style: ElevatedButton.styleFrom(primary: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  _resendDelay > 0
                      ? "Please wait $_resendDelay seconds to resend code."
                      : "Resend code is now available.",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontFamily: "Andika",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_resendDelay == 0)
                  GestureDetector(
                    onTap: resendOTP,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Didn't receive the code? ",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Andika",
                          ),
                        ),
                        Text(
                          "RESEND",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Andika",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
