import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_nist/api_services/apiImpl.dart';
import 'package:project_nist/bloc/loginevent.dart';
import 'package:project_nist/bloc/loginstate.dart';
import 'package:project_nist/stationmodel.dart';

import '../api_services/api_services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  Api apiService = ApiImpl();

  LoginBloc() : super(InitialState()) {
    List<StationModel> data;
    on<SignupEvent>(
      (event, emit) async {
        var response = await apiService.saveData(
            name: event.name,
            address: event.address,
            contact: event.contact,
            email: event.email,
            password: event.password,
            cpassword: event.cpassword);
        if (response != null) {
          emit(LoadedState(isSuccessfull: response));
        }
      },
    );
    on<LoginEvents>((event, emit) async {
      var response = await apiService.checkCredientialforLogin(
          email: event.email, password: event.password);
      if (response != null) {
        emit(LoadedState(isSuccessfull: !response));
      }
    });

    on<StationEvent>(
      (event, emit) async {
        var response = await apiService.addStation(
            name: event.name,
            address: event.address,
            phone: event.phone,
            longitude: event.longitude,
            latitude: event.latitude,
            update: event.update!);
        if (response != null) {
          emit(LoadedState(isSuccessfull: response));
        }
      },
    );

    on<GetStationEvent>((event, emit) async {
      emit(LoadingState());
      try {
        data = await apiService.getStation();

        if (data != null) {
          emit(LoadedState(dataList: data));
        }
      } catch (e) {
        // emit(ErrorState());
      }
    });

    on<deleteStationEvent>(
      (event, emit) async {
        var response = await apiService.deleteStation(
          event.phone ?? "",
        );
        if (response != null) {
          emit(LoadedState(isSuccessfull: response));
        }
      },
    );
  }
}
