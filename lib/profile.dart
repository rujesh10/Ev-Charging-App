import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_nist/add.dart';
import 'package:project_nist/bloc/loginstate.dart';
import 'package:project_nist/bottomnav.dart';

import 'package:project_nist/changepassword.dart';
import 'package:project_nist/helper.dart';
import 'package:project_nist/login.dart';
import 'package:project_nist/privacy.dart';
import 'package:project_nist/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isAdmin = false;
  String email1 = "Rujesh10@gmail.com";
  String email = "";
  String name = "";
  String? Useremail;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    await areYouAdmin();
    await getDataFromDatabase();
  }

  Future<void> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    if (email!.isNotEmpty) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where("email", isEqualTo: email)
          .get();
      final user = response.docs.first;
      var role = user.data()['role'] ??
          ""; // Assuming 'role' is the field for user roles

      setState(() {
        role;
        var userId = user.id;
      });
    }
  }

  areYouAdmin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? "";
    if (email != null) {
      if (email == email1) {
        setState(() {
          isAdmin = true;
        });
      } else {
        setState(() {
          isAdmin = false;
        });
      }
    }
  }

  getDataFromDatabase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '';
    if (email.isNotEmpty) {
      var response = await FirebaseFirestore.instance
          .collection('Signup')
          .where("email", isEqualTo: email)
          .get();
      final user = response.docs.first;
      setState(() {
        name = user.data()['name'] ?? "";
      });
    }
  }

  removeValueFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("isLogin");
    prefs.remove("email");
  }

  profileUi() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigation(),
                      ));
                },
                icon: const Icon(Icons.arrow_back),
              ),
              Text(
                "Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        isAdmin
            ? CircleAvatar(
                // backgroundImage: AssetImage("assets/images/person.jpg"),
                child: Text(
                  "Admin",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                radius: 50,
              )
            : CircleAvatar(
                // backgroundImage: AssetImage("assets/images/rj.png"),
                child: Text(
                  "User",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                radius: 50,
              ),
        SizedBox(
          height: 10,
        ),
        (name.isNotEmpty)
            ? Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              )
            : Text(""),
        SizedBox(
          height: 5,
        ),
        (email1.isNotEmpty)
            ? Text(
                email,
                style: TextStyle(color: Colors.grey),
              )
            : Text(""),
        SizedBox(
          height: 25,
        ),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ChangePassword(), // Add ChangePassword widget
              ),
            );
          },
          child: const ListTile(
            leading: Icon(Icons.vpn_key),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: Text("Change Password"),
          ),
        ),
        const Divider(),
        isAdmin
            ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Add(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(Icons.ev_station),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text("Add Stations"),
                ),
              )
            : SizedBox(),
        Divider(),
        isAdmin
            ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobList(),
                      ));
                },
                child: const ListTile(
                  leading: Icon(Icons.view_carousel_outlined),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text("View Stations"),
                ),
              )
            : SizedBox(),
        Divider(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Privacy(),
                ));
          },
          child: const ListTile(
            leading: Icon(Icons.lock_outline),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            title: Text("Privacy and Policy"),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          title: const Text(
            "Log Out",
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            showLogoutDialog(context);
          },
        ),
        const Divider(),
      ],
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Do you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Make sure the onPressed function is asynchronous
                await removeValueFromSharedPreference(); // Await the function
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Start()),
                  (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: MyBehaviour(),
          child: Stack(
            children: [profileUi()],
          ),
        ),
      ),
    );
  }
}
