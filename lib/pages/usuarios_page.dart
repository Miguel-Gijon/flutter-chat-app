import 'package:chat/models/user.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {


  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1', name: 'Maria', email: 'test1@test.com', online: true),
    User(uid: '2', name: 'Melissa', email: 'test2@test.com', online: false),
    User(uid: '3', name: 'Fernando', email: 'test3@test.com', online: true),
  ];

  UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  @override
  Widget build(BuildContext context) {

    final authServiceBloc = context.watch<AuthServiceBloc>();

    return BlocListener<AuthServiceBloc, AuthServiceState>(
      listener: (context, state) {
        if (!state.authenticated) {
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
      child: Scaffold(
          appBar: AppBar(
              title:
                  Text(authServiceBloc.state.user?.name ?? 'Name', 
                  style: const TextStyle(color: Colors.black87)),
              elevation: 1,
              backgroundColor: Colors.white,
              leading: IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.black87),
                  onPressed: () {
                    print('Usuario registrado: ${authServiceBloc.state.user?.name}');
                    context.read<AuthServiceBloc>().add(LogoutEvent());
                  }),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.check_circle, color: Colors.blue[400]),
                  //child: Icon(Icons.offline_bolt, color: Colors.red),
                )
              ]),
          body: SmartRefresher(
            controller: widget._refreshController,
            enablePullDown: true,
            onRefresh: _loadUsers,
            header: WaterDropHeader(
              complete: Icon(Icons.check, color: Colors.blue[400]),
              waterDropColor: Colors.blue[400] ?? Colors.blue,
            ),
            child: _listViewUsers())
            ),
    );
  }

  ListView _listViewUsers() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) => _userListTile(widget.users[i]),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: widget.users.length,
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
                color: user.online
                    ? Colors.green[300]
                    : Colors.red,
                borderRadius: BorderRadius.circular(100)),
          ),
        );
  }


  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    widget._refreshController.refreshCompleted();
  }
}
