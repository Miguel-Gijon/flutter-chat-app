part of 'chat_service_bloc.dart';

sealed class ChatServiceEvent {}

class ChatServiceUserToEvent extends ChatServiceEvent {
  final User userTo;

  ChatServiceUserToEvent(this.userTo);
}

class ChatServiceMessageEvent extends ChatServiceEvent {
  final ChatMessage chatMessage;
  final IO.Socket? socket;

  ChatServiceMessageEvent({
    required this.chatMessage,
    this.socket
    });
}

class ChatServiceAddNewMessageEvent extends ChatServiceEvent {
  final ChatMessage message;

  ChatServiceAddNewMessageEvent(this.message);
}

class FetchChatServiceEvent extends ChatServiceEvent {
  final Future<String?> token;

  FetchChatServiceEvent({
    required this.token, 
    });
}

class MessageListEvent extends ChatServiceEvent {
  final List<ChatMessage> messages;

  MessageListEvent(this.messages);
}