import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_nist/stationmodel.dart';

import 'api_services.dart';

class ApiImpl extends Api {
  bool success = false;
  @override
  Future<bool> saveData({
    String? name,
    String? address,
    String? contact,
    String? email,
    String? password,
    String? cpassword,
  }) async {
    var response = {
      "name": name,
      "address": address,
      "contact": contact,
      "email": email,
      "password": password,
      "cpassword": cpassword,
    };
    try {
      await FirebaseFirestore.instance.collection("Signup").add(response);
      success = true;
    } catch (e) {
      print(e);
      success = false;
    }
    return success;
  }

  bool notRegistered = false;
  bool alreadyRegistered = false;

  @override
  checkCredientialforLogin({String? email, String? password}) async {
    try {
      await FirebaseFirestore.instance
          .collection("Signup")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          notRegistered = true;
        } else {
          notRegistered = false;
        }
      });
    } catch (e) {
      notRegistered = false;
    }
    return notRegistered;
  }

  @override
  addStation(
      {String? name,
      String? address,
      String? phone,
      String? longitude,
      String? latitude,
      bool update = false}) async {
    var response = {
      "name": name,
      "address": address,
      "phone": phone,
      "longitude": longitude,
      "latitude": latitude,
    };
    if (update == false) {
      try {
        await FirebaseFirestore.instance.collection("Stations").add(response);
        success = true;
      } catch (e) {
        print(e);
        success = false;
      }
      return success;
    } else {
      var userId = await getUserIdForJobUpdateAndDelete(phone!);
      if (userId.isNotEmpty) {
        updateStation(userId, response);
      } else {
        print("User Id not found for the given phone number");
      }
    }
  }

  @override
  getStation() async {
    var response =
        await FirebaseFirestore.instance.collection('Stations').get();
    final user = response.docs;
    List<StationModel> stationData = [];
    try {
      if (user.isNotEmpty) {
        for (var workData in user) {
          stationData.add(StationModel.fromJson(workData.data()));
        }
        return stationData;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  Future<String> getUserIdForJobUpdateAndDelete(String phone) async {
    var response = await FirebaseFirestore.instance
        .collection('Stations')
        .where("phone", isEqualTo: phone)
        .get();

    if (response.docs.isNotEmpty) {
      var user = response.docs.first;
      return user.id;
    }
    return '';
  }

  Future<bool> updateStation(String userId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("Stations")
          .doc(userId)
          .update(data);
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> deleteStation(String phone) async {
    var userId = await getUserIdForJobUpdateAndDelete(phone);

    if (userId.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection("Stations")
            .doc(userId)
            .delete();
        return true;
      } catch (ex) {
        return false;
      }
    } else {
      print('User ID not found for the given email.');
      return false;
    }
  }
}
