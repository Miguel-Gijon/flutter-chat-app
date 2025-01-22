part of 'auth_service_bloc.dart';

@immutable
sealed class AuthServiceEvent {}

class LoginEvent extends AuthServiceEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class ResetErrorEvent extends AuthServiceEvent {}

class RegisterEvent extends AuthServiceEvent {
  final String email;
  final String password;
  final String name;

  RegisterEvent(this.email, this.password, this.name);
}

class CheckAuthEvent extends AuthServiceEvent {}

class LogoutEvent extends AuthServiceEvent {}