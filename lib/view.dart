import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_nist/add.dart';
import 'package:project_nist/bloc/loginevent.dart';
import 'package:project_nist/helper.dart';
import 'package:project_nist/profile.dart';
import 'package:project_nist/stationmodel.dart';

import '../bloc/loginbloc.dart';
import '../bloc/loginstate.dart';
import 'custom.dart';

class JobList extends StatefulWidget {
  const JobList({Key? key}) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  bool loader = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return SafeArea(
              child: ScrollConfiguration(
                behavior: MyBehaviour(),
                child: SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [stationListUi(state.dataList)],
                  ),
                ),
              ),
            );
          }

          if (state is DeleteState) {
            // Refresh the job list by re-triggering the JobEvent
            addEvent();
            return const CircularProgressIndicator(); // Show loading while refreshing
          }
          return const SizedBox();
        },
      ),
    );
  }

  stationListUi(List<StationModel>? dataList) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const Text(
                "Station List",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        //sizebox
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        SingleChildScrollView(
          child: Column(
            children: dataList!
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    blurRadius: 2,
                                    offset: Offset(0, 0.9),
                                    spreadRadius: 1),
                              ]),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.fromLTRB(
                                      //       20, 5, 0, 15),
                                      //   child: SizedBox(
                                      //       height: 30,
                                      //       width: 30,
                                      //       child: Image.network(
                                      //           dataList[e.key].logo!)),
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            dataList[e.key].name ?? "Ui",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: 150,
                                          child: Text(
                                            dataList[e.key].address!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: "Andika",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        CustomAdd(
                                          icon: Icons.edit,
                                          onpressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Add(
                                                          name: dataList[e.key]
                                                              .name,
                                                          address:
                                                              dataList[e.key]
                                                                  .address,
                                                          phone: dataList[e.key]
                                                              .phone,
                                                          lat: dataList[e.key]
                                                              .latitude,
                                                          long: dataList[e.key]
                                                              .longitude,
                                                        )));
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomAdd(
                                          icon: Icons.delete_outline,
                                          onpressed: () {
                                            showDeleteConfirmation(context,
                                                dataList[e.key].phone!);
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }

  void showDeleteConfirmation(BuildContext context, String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(fontFamily: "Andika"),
        ),
        content: const Text(
          'Are you sure you want to delete this station?',
          textAlign: TextAlign.start,
          style: TextStyle(fontFamily: "Andika", fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: "Andika"),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  )); // Close the dialog
              // Call the delete job event
              context.read<LoginBloc>().add(deleteStationEvent(phone: phone));
            },
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: "Andika"),
            ),
          ),
        ],
      ),
    );
  }
}

class Application {
  String? img, txt1, txt2;
  Application({
    this.img,
    this.txt1,
    this.txt2,
  });
}
