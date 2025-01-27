part of 'users_service_bloc.dart';

class UsersServiceState extends Equatable {
  final List<User> users;

  const UsersServiceState({
    this.users = const []
    });

  @override
  List<Object> get props => [users];

  UsersServiceState copyWith({
    List<User>? users
    }) {
    return UsersServiceState(
      users: users ?? this.users
      );
  }
}
