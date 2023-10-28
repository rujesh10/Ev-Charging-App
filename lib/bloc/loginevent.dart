import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupEvent extends LoginEvent {
  String? name, address, contact, email, password, cpassword;

  SignupEvent(
      {this.name,
      this.address,
      this.contact,
      this.email,
      this.password,
      this.cpassword});
}

class LoginEvents extends LoginEvent {
  String? password;
  String? email;
  LoginEvents({this.email, this.password});
}

class StationEvent extends LoginEvent {
  String? name, address, phone, longitude, latitude;
  bool? update;

  StationEvent(
      {this.name,
      this.address,
      this.phone,
      this.longitude,
      this.latitude,
      this.update});
}

class GetStationEvent extends LoginEvent {}

class deleteStationEvent extends LoginEvent {
  String? phone;
  deleteStationEvent({this.phone});
}
