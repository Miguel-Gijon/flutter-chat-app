
import 'package:chat/global/enviroments.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'users_service_event.dart';
part 'users_service_state.dart';

class UsersServiceBloc extends Bloc<UsersServiceEvent, UsersServiceState> {
  UsersServiceBloc() : super(const UsersServiceState(users: [])) {
    on<GetUsersEvent>(_getUsers);
  }

  Future<void> _getUsers(GetUsersEvent event, Emitter<UsersServiceState> emit) async {

      try{
        final response = await http.get(
          Uri.parse('${Enviroments.apiUrl }/users'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': await event.token ?? ''
          }
        );

        final users = usersResponseFromJson(response.body);
        emit(state.copyWith(users: users.users));
        event.completedAction();
      } catch (e) {
        emit(state.copyWith(users: []));
      }
  }
}
