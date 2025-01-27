import 'dart:async';
import 'dart:convert';
import 'package:chat/global/enviroments.dart';
import 'package:chat/models/custom_error.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_service_event.dart';
part 'auth_service_state.dart';

class AuthServiceBloc extends Bloc<AuthServiceEvent, AuthServiceState> {
  final _storage = const FlutterSecureStorage();

  AuthServiceBloc() : super(AuthServiceState()) {
    on<LoginEvent>(_login);
    on<ResetErrorEvent>(_resetError);
    on<RegisterEvent>(_regiser);
    on<CheckAuthEvent>(_isLoggedIn);
    on<LogoutEvent>((LogoutEvent event, Emitter<AuthServiceState> emit) async {
      emit(state.copyWith(authenticated: false));
      _logout();
    });
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future _login(LoginEvent event, Emitter<AuthServiceState> emit) async {
    emit(state.copyWith(authenticating: true));

    final data = {
      'email': event.email,
      'password': event.password,
    };

    final uri = Uri.parse('${Enviroments.apiUrl}/login');

    final response = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      await _saveToken(loginResponse.token);
      emit(state.copyWith(user: loginResponse.user, authenticating: false, authenticated: true));
      emit(state.resetError());
    } else {
      emit(state.copyWith(
          error: CustomError(message: response.body), authenticating: false));
    }
  }

  Future _regiser(RegisterEvent event, Emitter<AuthServiceState> emit) async {
    emit(state.copyWith(register: Register.processing));

    final data = {
      'name': event.name,
      'email': event.email,
      'password': event.password,
    };

    final uri = Uri.parse('${Enviroments.apiUrl}/login/new');

    final response = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      emit(state.copyWith(
          user: loginResponse.user, register: Register.success, authenticated: true));
      await _saveToken(loginResponse.token);
    } else {
      emit(state.copyWith(
          error: CustomError(message: jsonDecode(response.body)['message']),
          register: Register.pending));
    }
  }

  Future _isLoggedIn(
      CheckAuthEvent event, Emitter<AuthServiceState> emit) async {
    final token = await _storage.read(key: 'token');

    final resp = await http.get(
      Uri.parse('${Enviroments.apiUrl}/login/renew'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? '',
      },
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      emit(state.copyWith(user: loginResponse.user, authenticated: true));
      await _saveToken(loginResponse.token);
    } else {
      _logout();
      emit(state.copyWith(error: CustomError(message: 'Token not valid')));
    }
  }

  Future _resetError(ResetErrorEvent event, Emitter<AuthServiceState> emit) async {
    emit(state.resetError());
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
  }
}
