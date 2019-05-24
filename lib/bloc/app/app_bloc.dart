import 'package:bloc/bloc.dart';
import 'package:flutter_chat_sdk/bloc/app/user.dart';

abstract class AppState {}

abstract class AppEvent {}

class UserSignInEvent extends AppEvent {
  final UserChat userInfo;

  UserSignInEvent({this.userInfo});
}

class UserSignOutEvent extends AppEvent {}

class UserSignInState extends AppState {
  final UserChat userInfo;

  UserSignInState(this.userInfo);
}

class UserSignOutState extends AppState {}

class AppInitState extends AppState {}

class AppBloc extends Bloc<AppEvent, AppState> {
  UserChat userInfo;

  @override
  AppState get initialState => AppInitState();

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is UserSignInEvent) {
      userInfo = event.userInfo;
      yield UserSignInState(event.userInfo);
    } else if (event is UserSignOutEvent) {}
  }

  bool isSignIn() => userInfo != null && !userInfo.isUndefined();
}
