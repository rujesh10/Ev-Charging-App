import '../stationmodel.dart';

abstract class LoginState {}

class InitialState extends LoginState {}

class LoadingState extends LoginState {}

class LoadedState extends LoginState {
  final List<StationModel>? dataList;
  final bool? isSuccessfull;
  LoadedState({this.dataList, this.isSuccessfull});
}

class DeleteState extends LoginState {}
