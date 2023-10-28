import '../stationmodel.dart';

abstract class Api {
  saveData(
      {String? name,
      String? address,
      String? contact,
      String? email,
      String? password,
      String? cpassword});

  checkCredientialforLogin({String? email, String? password});

  addStation(
      {String? name,
      String? address,
      String? phone,
      String? longitude,
      String? latitude,
      bool update = false});

  getStation();
  Future<bool> deleteStation(String phone);
}
