part of 'chat_service_bloc.dart';

class ChatServiceState extends Equatable {
  User? userTo;
  List<ChatMessage> messages;
  FetchMessagesResponse? fetchMessagesResponse;

  ChatServiceState({
    this.userTo,
    this.messages = const [],
    this.fetchMessagesResponse,
  });

  @override
  List<Object?> get props => [userTo, messages, fetchMessagesResponse];

  ChatServiceState copyWith({
    User? userTo,
    List<ChatMessage>? messages,
    FetchMessagesResponse? fetchMessagesResponse,
  }) {
    return ChatServiceState(
      userTo: userTo ?? this.userTo,
      messages: messages ?? this.messages,
      fetchMessagesResponse: fetchMessagesResponse ?? this.fetchMessagesResponse,
    );
  }

  ChatServiceState resetUserTo() {
    return ChatServiceState(
      userTo: null,
    );
  }
}
