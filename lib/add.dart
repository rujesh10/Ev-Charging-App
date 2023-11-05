import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_nist/bloc/loginbloc.dart';
import 'package:project_nist/bloc/loginevent.dart';
import 'package:project_nist/bottomnav.dart';
import 'package:project_nist/dashboard.dart';
import 'package:project_nist/profile.dart';

class Add extends StatefulWidget {
  String? name, address, phone, long, lat;

  Add({Key? key, this.name, this.address, this.phone, this.long, this.lat})
      : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  initState() {
    if (widget.phone != null) {
      update = true;
    }
    name = widget.name;
    address = widget.address;
    phone = widget.phone;
    longitude = widget.long ?? "";
    latitude = widget.lat ?? "";
    super.initState();
  }

  Future<void> _submitData() async {
    try {
      BlocProvider.of<LoginBloc>(context).add(StationEvent(
          name: name,
          address: address,
          phone: phone,
          longitude: longitude,
          latitude: latitude,
          update: update));
    } catch (e) {
      print(e);
    }
  }

  bool update = false;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? name, address, phone, longitude, latitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text(
                      "Add Stations",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: widget.name,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Please enter station name";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Station Name"),
                      hintText: "Enter Station name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: widget.address,
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Please enter address";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Address"),
                      hintText: "Enter Station address"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: widget.phone,
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Please enter phone number";
                    }
                    return null;
                  }),
                  keyboardType:
                      TextInputType.phone, // Set the keyboard type to phone
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone",
                    hintText: "Enter phone number",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: widget.long,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      longitude = value;
                    });
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Longitude field empty";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Longitude"),
                      hintText: "Enter Longitude"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  initialValue: widget.lat,
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      latitude = value;
                    });
                  },
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Latitude field empty";
                    }
                    return null;
                  }),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Latitude"),
                      hintText: "Enter Latitude"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 350,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });

                    Timer(Duration(seconds: 2), () {
                      if (_formKey.currentState!.validate()) {
                        _submitData();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Success"),
                              content:
                                  const Text("Form submitted successfully!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Navigator.of(context)
                                    //     .pop(); // Close the dialog
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Settings(),
                                        )); // Go back to the original page
                                  },
                                  child: Text("Ok"),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text("Submit"),
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
