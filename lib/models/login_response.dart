// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:cchat_app/models/custom_models.dart';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    bool ok;
    String msg;
    Usuario usuario;
    String token;

    LoginResponse({
        required this.ok,
        required this.msg,
        required this.usuario,
        required this.token,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        msg: json["msg"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuario": usuario.toJson(),
        "token": token,
    };
}

