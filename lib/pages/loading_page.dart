import 'package:chat/pages/login_page.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'usuarios_page.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkLoginState(context),
        builder: (context, snapshot) {
          return BlocListener<AuthServiceBloc, AuthServiceState>(
            listener: (context, state) {
              if (state.user != null) {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => UsuariosPage(),
                      transitionDuration: const Duration(milliseconds: 0),
                    ));
                return;
              }
              if (state.error != null) {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginPage(),
                      transitionDuration: const Duration(milliseconds: 0),
                    ));
              }
            },
            child: const Center(
              child: Text('Waiting...'),
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkLoginState(BuildContext context) async {
    context.read<AuthServiceBloc>().add(CheckAuthEvent());
  }
}
