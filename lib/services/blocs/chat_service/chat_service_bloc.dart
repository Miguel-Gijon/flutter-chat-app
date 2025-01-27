import 'dart:async';

import 'package:chat/global/enviroments.dart';
import 'package:chat/models/fetch_messages_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

part 'chat_service_event.dart';
part 'chat_service_state.dart';

class ChatServiceBloc extends Bloc<ChatServiceEvent, ChatServiceState> {
  ChatServiceBloc() : super(ChatServiceState()) {
    on<ChatServiceUserToEvent>(_chatToUser);
    on<ChatServiceMessageEvent>(_chatMessage);
    on<ChatServiceAddNewMessageEvent>(_addNewMessage);
    on<FetchChatServiceEvent>(_fetchMessages);
    on<MessageListEvent>(_addMessageList);
  }

  Future<void> _chatToUser(
      ChatServiceUserToEvent event, Emitter<ChatServiceState> emit) async {
    emit(state.copyWith(userTo: event.userTo));
  }

  Future<void> _chatMessage(
      ChatServiceMessageEvent event, Emitter<ChatServiceState> emit) async {
    event.socket?.emit('personal-message', {
      'from': event.chatMessage.uid,
      'to': state.userTo?.uid,
      'message': event.chatMessage.texto,
    });
    _addNewMessage(ChatServiceAddNewMessageEvent(event.chatMessage), emit);
  }

  Future<void> _addNewMessage(ChatServiceAddNewMessageEvent event,
      Emitter<ChatServiceState> emit) async {
    emit(state.copyWith(
      messages: [
        event.message,
        ...state.messages,
      ],
    ));
  }

  Future<void> _addMessageList(
      MessageListEvent event, Emitter<ChatServiceState> emit) async {
    emit(state.copyWith(messages: event.messages));
  }

  Future<void> _fetchMessages(
      FetchChatServiceEvent event, Emitter<ChatServiceState> emit) async {
    final Uri uri =
        Uri.parse('${Enviroments.apiUrl}/messages/${state.userTo?.uid}');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await event.token ?? '',
    });

    final messagesResponse = fetchMessagesResponseFromJson(resp.body);
    emit(state.copyWith(fetchMessagesResponse: messagesResponse));
  }
}
