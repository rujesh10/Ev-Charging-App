import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helper.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, String?> calculatedDistances = {};

  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _performSearch(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Search for Professions
    QuerySnapshot<Map<String, dynamic>> professionsQuerySnapshot =
        await _firestore
            .collection('Stations')
            .where('address', isGreaterThanOrEqualTo: searchText)
            .where('address', isLessThan: searchText + 'z')
            .get();

    // Search for Materials

    List<Map<String, dynamic>> combinedResults = [];
    combinedResults.addAll(
        professionsQuerySnapshot.docs.map((doc) => doc.data()).toList());

    setState(() {
      _searchResults = combinedResults;
    });
  }

  double? long;
  double? lat;
  String? address;
  String? distance;
  String? currentAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text(
                    "Search",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                left: 15,
                right: 15,
              ),
              child: SizedBox(
                height: 55,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) => _performSearch(value),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    hintText: 'Search for stations',
                    hintStyle: const TextStyle(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is OverscrollNotification) {
                    if (notification.overscroll > 0) {
                      // Scrolling down, fade out the overflowing text
                      _searchController.clear();
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final searchData = _searchResults[index];

                    final name = searchData['name'] ?? 'N/A';
                    final address = searchData['address'] ?? 'N/A';
                    final phone = searchData['phone'] ?? 'N/A';

                    // Decide whether to show profession or material data
                    bool isProfession = searchData.containsKey('Profession');

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 350,
                                height: 220,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 17,
                                            left: 20,
                                          ),
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, top: 5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                color: Color.fromARGB(
                                                    255, 236, 33, 18),
                                              ),
                                              Text(
                                                address,
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 15),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.power,
                                                color: Colors.green,
                                              ),
                                              Text(
                                                "01 Kw",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.attach_money_rounded,
                                                color: Colors.green,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "Rs 500  ",
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "0 km",
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                                                    onPressed: () {},
                                                    child: Text("View"),
                                                    // style: ButtonStyle(
                                                    //   overlayColor:
                                                    //       MaterialStateProperty.all(
                                                    //           Colors.red),
                                                    // ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.black,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shadowColor: Color(1),
                                                      side: const BorderSide(
                                                          color: Colors.blue),
                                                    ),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 150,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // launchUrl('tell:+9813688376');
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
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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
