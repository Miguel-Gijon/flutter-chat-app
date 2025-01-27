part of 'socket_service_bloc.dart';

@immutable
sealed class SocketServiceEvent {}

class SocketServiceConnectEvent extends SocketServiceEvent {
  final Future token;

  SocketServiceConnectEvent(this.token);
}

class SocketEmmitMessageEvent extends SocketServiceEvent {
  final Map map;

  SocketEmmitMessageEvent(this.map);
}

class SocketDisconnectEvent extends SocketServiceEvent {}

class ListenMessageEvent extends SocketServiceEvent {
  final void Function(dynamic playload) listenMessage;
  ListenMessageEvent(this.listenMessage);
}