// material_model.dart
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class StationModel {
  // final String id;
  final String name;
  final String address;
  final String phone;
  final String? latitude, longitude;

  StationModel({
    // required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  static StationModel fromJson(Map<String, dynamic> json) {
    return StationModel(
        // id: snapshot.id,
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        latitude: json['Latitude'] ?? '',
        longitude: json['Longitude'] ?? '');
  }
}
