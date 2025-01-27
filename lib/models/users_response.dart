// To parse this JSON data, do
//
//     final usersResponse = usersResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat/models/user.dart';

UsersResponse usersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String usersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
    final bool ok;
    final List<User> users;
    final int from;

    UsersResponse({
        required this.ok,
        required this.users,
        required this.from,
    });

    factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        from: json["from"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "from": from,
    };
}