import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:chat/services/blocs/socket_service/socket_service_bloc.dart';
import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(titulo: 'Register'),
                _Form(),
                const Labels(
                  route: 'login',
                  firstLabel: 'Do you have one account?',
                  secondLabel: 'Sing in!',
                ),
                const Text('Terms and conditions of use',
                    style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final blocService = context.watch<AuthServiceBloc>();

    void resetError() {
      context.read<AuthServiceBloc>().add(ResetErrorEvent());
    }

    void registerCompleted() {
      context.read<SocketServiceBloc>().add(SocketServiceConnectEvent(
        AuthServiceBloc.getToken(),
      ));
      Navigator.pushReplacementNamed(context, 'users');
    }

    return BlocListener<AuthServiceBloc, AuthServiceState>(
      listener: (context, state) {
        if (state.register == Register.success) {
          showAlert(context, 'Registered', 'User created successfully', registerCompleted);
          return;
        }
        if (state.register == Register.processing) return;
        if (state.error != null) {
          showAlert(context, 'Register Error',
                  state.error!.message ?? 'An error occurred')
              .whenComplete(() {
            resetError();
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: <Widget>[
            CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Name',
              keyboardType: TextInputType.text,
              textController: nameCtrl,
            ),
            CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl,
            ),
            CustomInput(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              isPassword: true,
              textController: passwordCtrl,
            ),
            BlueButton(
              text: 'Create account',
              onPressed: blocService.state.register == Register.processing
                  ? null
                  : () {
                      // Remove keyboard
                      FocusScope.of(context).unfocus();
                      // Send login event
                      context.read<AuthServiceBloc>().add(RegisterEvent(
                          emailCtrl.text.trim(),
                          passwordCtrl.text.trim(),
                          nameCtrl.text.trim()));
                    },
            )
          ],
        ),
      ),
    );
  }
}
