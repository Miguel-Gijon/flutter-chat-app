part of 'socket_service_bloc.dart';

@immutable
class SocketServiceState extends Equatable {

  final SocketServiceStatus status;
  final IO.Socket? socket;

  const SocketServiceState({
    this.status = SocketServiceStatus.connecting,
    this.socket,
  });


  @override
  List<Object?> get props => [status, socket];

  SocketServiceState copyWith(
    {
      SocketServiceStatus? status,
      IO.Socket? socket,
    }
  ) {
    return SocketServiceState(
      status: status ?? this.status,
      socket: socket ?? this.socket,
    );
  }
}