import 'dart:async';

import 'package:chat/global/enviroments.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'socket_service_event.dart';
part 'socket_service_state.dart';

enum SocketServiceStatus { online, offline, connecting }

class SocketServiceBloc extends Bloc<SocketServiceEvent, SocketServiceState> {
  SocketServiceBloc() : super(const SocketServiceState()) {
    on<SocketServiceConnectEvent>(_connect);
    on<SocketEmmitMessageEvent>(_onEmmitMessage);
    on<SocketDisconnectEvent>(_disconnect);
    on<ListenMessageEvent>(_listenMessage);
  }

  Future<void> _connect(
      SocketServiceConnectEvent event, Emitter<SocketServiceState> emit) async {
    final token = await event.token;

    IO.Socket socket = IO.io(Enviroments.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token,
      }
    });
    final Completer<void> completer = Completer<void>();

    socket
      ..on('connect', (_) {
        if (!completer.isCompleted) {
          emit(state.copyWith(
              status: SocketServiceStatus.online, socket: socket));
        }
      })
      ..on('disconnect', (_) {
        if (!completer.isCompleted) {
          emit(state.copyWith(
              status: SocketServiceStatus.offline, socket: socket));
        }
      });

    await completer.future;
  }

  void _disconnect(
      SocketDisconnectEvent event, Emitter<SocketServiceState> emit) {
    state.socket?.disconnect();
  }

  Future<void> _onEmmitMessage(
      SocketEmmitMessageEvent event, Emitter<SocketServiceState> emit) async {
    state.socket?.emit('emitir-mensaje', event.map);
  }

  Future<void> _listenMessage(
      ListenMessageEvent event, Emitter<SocketServiceState> emit) async {
    state.socket?.on(
      'personal-message', 
      event.listenMessage
      );
  }
}
