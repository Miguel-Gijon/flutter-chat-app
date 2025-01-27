// To parse this JSON data, do
//
//     final fetchMessagesResponse = fetchMessagesResponseFromJson(jsonString);

import 'dart:convert';

FetchMessagesResponse fetchMessagesResponseFromJson(String str) => FetchMessagesResponse.fromJson(json.decode(str));

String fetchMessagesResponseToJson(FetchMessagesResponse data) => json.encode(data.toJson());

class FetchMessagesResponse {
    final bool ok;
    final List<Message> messages;

    FetchMessagesResponse({
        required this.ok,
        required this.messages,
    });

    factory FetchMessagesResponse.fromJson(Map<String, dynamic> json) => FetchMessagesResponse(
        ok: json["ok"],
        messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    };
}

class Message {
    final String from;
    final String to;
    final String message;
    final DateTime createdAt;
    final DateTime updatedAt;

    Message({
        required this.from,
        required this.to,
        required this.message,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        from: json["from"],
        to: json["to"],
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
