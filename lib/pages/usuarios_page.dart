import 'package:chat/models/user.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:chat/services/blocs/chat_service/chat_service_bloc.dart';
import 'package:chat/services/blocs/socket_service/socket_service_bloc.dart';
import 'package:chat/services/blocs/users_service/users_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  @override
  void initState() {
    super.initState();
    _loadUsers(context.read<UsersServiceBloc>(), AuthServiceBloc.getToken());
  }

  @override
  Widget build(BuildContext context) {
    final authServiceBloc = context.watch<AuthServiceBloc>();
    final socketServiceBloc = context.watch<SocketServiceBloc>();

    return BlocListener<AuthServiceBloc, AuthServiceState>(
        listener: (context, state) {
          if (!state.authenticated) {
            Navigator.pushReplacementNamed(context, 'login');
          }
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(authServiceBloc.state.user?.name ?? 'Name',
                  style: const TextStyle(color: Colors.black87)),
              elevation: 1,
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.black87),
                  onPressed: () {
                    context.read<AuthServiceBloc>().add(LogoutEvent());
                    context
                        .read<SocketServiceBloc>()
                        .add(SocketDisconnectEvent());
                  }),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: socketServiceBloc.state.status ==
                          SocketServiceStatus.online
                      ? Icon(Icons.check_circle, color: Colors.blue[400])
                      : const Icon(Icons.offline_bolt, color: Colors.red),
                )
              ]),
          body: SmartRefresher(
            controller: widget._refreshController,
            enablePullDown: true,
            onRefresh: () => _loadUsers(
              context.read<UsersServiceBloc>(),
              AuthServiceBloc.getToken(),
            ),
            header: WaterDropHeader(
              complete: Icon(Icons.check, color: Colors.blue[400]),
              waterDropColor: Colors.blue[400] ?? Colors.blue,
            ),
            child:
                _listViewUsers(context.watch<UsersServiceBloc>().state.users),
          ),
        ));
  }

  ListView _listViewUsers(List<User> users) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'chat', arguments: user);
      },
    );
  }

  _loadUsers(UsersServiceBloc readBloc, Future<String?> token) async {
    readBloc
        .add(GetUsersEvent(token, widget._refreshController.refreshCompleted));
  }
}
