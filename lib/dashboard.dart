import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_nist/bloc/loginbloc.dart';
import 'package:project_nist/bloc/loginevent.dart';
import 'package:project_nist/bloc/loginstate.dart';
import 'package:project_nist/search.dart';
import 'package:project_nist/stationmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_services/api_services.dart';
import 'helper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    addEvent();
    super.initState();
  }

  addEvent() {
    final stationBloc = BlocProvider.of<LoginBloc>(context);
    stationBloc.add(GetStationEvent());
  }

  @override
  Future<bool> onWillPop() async {
    return false;
  }

  //   late String =_lat;
  // late String =_long;

  double? long;
  double? lat;
  String? address;
  String? distance;
  String? currentAddress;
  Map<String, String?> calculatedDistances = {};

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return SafeArea(
              child: RefreshIndicator(
                onRefresh: () {
                  addEvent();

                  return Future<void>.delayed(const Duration(seconds: 2));
                },
                child: SingleChildScrollView(
                  child: dashboardUi(state.dataList),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget dashboardUi(List<StationModel>? dataList) {
    if (dataList == null || dataList.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 800,
              width: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  getCurrentLocation(dataList[index].name);
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 500, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          width: 350,
                          height: 220,
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 17,
                                      left: 20,
                                    ),
                                    child: Text(
                                      dataList[index].name,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 15, top: 5),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color:
                                              Color.fromARGB(255, 236, 33, 18),
                                        ),
                                        Text(
                                          dataList[index].address,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 15),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.power,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "01 Kw",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.monetization_on,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Rs 1500",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.run_circle_outlined,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            calculatedDistances[
                                                    dataList[index].name] ??
                                                "0 KM",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 16),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                String url =
                                                    'https://www.google.com/maps/search/?api=1&query=$long,$lat';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                                // String? latitudeString =
                                                //     dataList[index].latitude;
                                                // String? longitudeString =
                                                //     dataList[index].longitude;

                                                // if (latitudeString != null &&
                                                //     longitudeString != null) {
                                                //   double latitude =
                                                //       double.tryParse(
                                                //               latitudeString) ??
                                                //           0.0;
                                                //   double longitude =
                                                //       double.tryParse(
                                                //               longitudeString) ??
                                                //           0.0;

                                                //   String url =
                                                //       'maps:https://www.google.com/maps/search/?api=1&query=$latitudeString,$longitudeString';
                                                //   if (await canLaunch(url)) {
                                                //     await launch(url);
                                                //   } else {
                                                //     throw 'Could not launch $url';
                                                //   }
                                                // } else {
                                                //   // Handle case where latitude or longitude is null
                                                // }
                                              },
                                              child: Text("View"),
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Color(1),
                                                side: const BorderSide(
                                                    color: Colors.blue),
                                                primary: Colors.white,
                                                onPrimary: Colors.black,
                                              ),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // launchUrl('tell:+9813688376');
                                              String? contactNumber =
                                                  dataList[index].phone;
                                              String url = 'tel:$contactNumber';
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: const Text('Contact'),
                                            // style: ButtonStyle(
                                            //   overlayColor:
                                            //       MaterialStateProperty.all(
                                            //           Colors.red),
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SizedBox(
                height: 55,
                child: TextFormField(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Search()));
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: const Icon(Icons.search),
                    hintText: 'Search for stations',
                    hintStyle: const TextStyle(),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  getCurrentLocation(String hardwareName) async {
    LocationPermission permission = await Helper().getPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Stream<Coordinate> coordinateStream = Helper().getCoordinateStream();
      coordinateStream.listen((Coordinate coordinate) async {
        setState(() {
          lat = coordinate.latitude;
          long = coordinate.longitude;
        });

        var response = await FirebaseFirestore.instance
            .collection('Stations')
            .where('name', isEqualTo: hardwareName)
            .get();
        if (response.docs.isNotEmpty) {
          final user = response.docs.first;
          String? latitudeString = user.data()['latitude'];
          String? longitudeString = user.data()['longitude'];

          if (latitudeString != null && longitudeString != null) {
            double latitude = double.tryParse(latitudeString) ?? 0.0;
            double longitude = double.tryParse(longitudeString) ?? 0.0;

            double haversine = await Helper().calculateDistance(
              lat ?? 0.0,
              long ?? 0.0,
              latitude,
              longitude,
            );

            setState(() {
              currentAddress = user.data()['Address'];
              calculatedDistances[hardwareName] =
                  '${haversine.toStringAsFixed(3)} KM';
            });
          }
        }
      });
    }
  }
}
