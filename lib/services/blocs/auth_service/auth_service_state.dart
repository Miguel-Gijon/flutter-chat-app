part of 'auth_service_bloc.dart';

@immutable
class AuthServiceState extends Equatable {

  User? user;
  bool authenticating = false;
  bool authenticated = false;
  Register register = Register.pending;
  CustomError? error;

  AuthServiceState({
    this.user,
    this.authenticating = false,
    this.authenticated = false,
    this.error,
    this.register = Register.pending,
  });
  
  @override
  List<Object?> get props => [user, authenticating, error, register,authenticated];

  AuthServiceState copyWith({
    User? user,
    bool? authenticating,
    bool? authenticated,
    CustomError? error,
    Register? register,
  }) => AuthServiceState(
    user: user ?? this.user,
    authenticating: authenticating ?? this.authenticating,
    authenticated: authenticated ?? this.authenticated,
    error: error ?? this.error,
    register: register ?? this.register,
  );

  AuthServiceState resetError() => AuthServiceState(
    user: user,
    authenticating: authenticating,
    authenticated: authenticated,
    error: null,
    register: register,
  );

}

enum Register{
  pending,
  processing,
  success,
}
