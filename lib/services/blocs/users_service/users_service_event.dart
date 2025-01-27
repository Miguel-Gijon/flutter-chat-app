part of 'users_service_bloc.dart';

sealed class UsersServiceEvent {}

class GetUsersEvent extends UsersServiceEvent {
    final Future<String?> token;
    final Function completedAction;
    GetUsersEvent(
        this.token, 
        this.completedAction
        );
}
