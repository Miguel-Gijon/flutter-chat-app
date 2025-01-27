import 'package:chat/routes/routes.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:chat/services/blocs/socket_service/socket_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthServiceBloc(),
      child: BlocProvider(
        create: (context) => SocketServiceBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          initialRoute: 'loading',
          routes: appRoutes,
        ),
      ),
    );
  }
}
