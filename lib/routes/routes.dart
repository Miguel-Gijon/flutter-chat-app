import 'package:chat/models/user.dart';
import 'package:chat/pages/chat_page.dart';
import 'package:chat/pages/loading_page.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/services/blocs/chat_service/chat_service_bloc.dart';
import 'package:chat/services/blocs/users_service/users_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => BlocProvider(
        create: (context) => UsersServiceBloc(),
        child: UsuariosPage(),
      ),
  'chat': (context) {
    final User user = ModalRoute.of(context)!.settings.arguments as User;
    return BlocProvider(
      create: (context) => ChatServiceBloc(),
      child: ChatPage(userTo: user),
    );
  },
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
