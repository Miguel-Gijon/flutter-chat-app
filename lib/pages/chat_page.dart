import 'dart:io';

import 'package:chat/models/fetch_messages_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/blocs/auth_service/auth_service_bloc.dart';
import 'package:chat/services/blocs/chat_service/chat_service_bloc.dart';
import 'package:chat/services/blocs/socket_service/socket_service_bloc.dart';
import 'package:chat/services/blocs/users_service/users_service_bloc.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final User userTo;

  const ChatPage({super.key, required this.userTo});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Bloc de solo lectura para lanzar eventos
  late ChatServiceBloc chatBloc;
  late SocketServiceBloc socketBloc;

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  var _isWriting = false;

  @override
  void initState() {
    super.initState();
    chatBloc = context.read<ChatServiceBloc>();
    socketBloc = context.read<SocketServiceBloc>();

    chatBloc
      ..add(ChatServiceUserToEvent(widget.userTo))
      ..add(FetchChatServiceEvent(token: AuthServiceBloc.getToken()));
    socketBloc.add((ListenMessageEvent(_listenMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final blocState = context.watch<ChatServiceBloc>().state;

    return BlocListener<ChatServiceBloc, ChatServiceState>(
      listenWhen: (previous, current) {
        return previous.messages.isEmpty && current.fetchMessagesResponse?.messages.isNotEmpty == true;
      },
      listener: (context, state) {
        chatBloc.add(MessageListEvent(_mapMessagesResponse(
          state.fetchMessagesResponse?.messages ?? [])));
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
                child: Text(blocState.userTo?.name.substring(0, 2) ?? '',
                    style: const TextStyle(fontSize: 12)),
              ),
              const SizedBox(height: 3),
              Text(blocState.userTo?.name ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          centerTitle: true,
          elevation: 1,
        ),
        body: BlocBuilder<ChatServiceBloc, ChatServiceState>(
          builder: (context, state) {
            return Container(
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.messages.length,
                      itemBuilder: (_, i) => state.messages[i],
                      reverse: true,
                    ),
                  ),
                  const Divider(height: 1),
                  Container(
                   color: Colors.white,
                   child: _inputChat(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    _isWriting = text.trim().isNotEmpty;
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _isWriting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text('Send'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    final authBloc = context.read<AuthServiceBloc>();

    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      type: MessageType.mine,
      texto: text,
      uid: authBloc.state.user?.uid ?? '',
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    chatBloc.add(ChatServiceMessageEvent(
      chatMessage: newMessage,
      socket: socketBloc.state.socket,
    ));
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // Clean up the animation controller, it is important to avoid memory leaks
    for (ChatMessage message in chatBloc.state.messages) {
      message.animationController.dispose();
    }
    // Cerramos el listener del socket de mensajes personales.
    socketBloc.state.socket?.off('personal-message');
    super.dispose();
  }

  void _listenMessage(dynamic playload) {
    final newMessage = ChatMessage(
      type: MessageType.notMine,
      texto: playload['message'],
      uid: playload['from'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    chatBloc.add(ChatServiceAddNewMessageEvent(
      newMessage,
    ));

    // Animate the message when it arrives
    newMessage.animationController.forward();
  }

  List<ChatMessage> _mapMessagesResponse(List<Message> messages) {
    final newMessages = messages.map(
          (message) {
            return ChatMessage(
              texto: message.message,
              uid: message.from,
              type: message.from == chatBloc.state.userTo?.uid
                  ? MessageType.notMine
                  : MessageType.mine,
              animationController: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 0),
              )..forward(),
            );
          },
        ).toList();

    //TODO Corregir que cargue los mensajes, ya que no se estan mostrando
    //newMessages.map((message) => message.animationController.forward());
    return newMessages;
  }
}
