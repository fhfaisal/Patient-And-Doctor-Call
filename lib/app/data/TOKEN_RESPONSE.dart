// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) => TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  int? status;
  String? message;
  String? channelName;
  String? token;

  TokenResponse({
    this.status,
    this.message,
    this.channelName,
    this.token,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
    status: json["status"],
    message: json["message"],
    channelName: json["channelName"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "channelName": channelName,
    "token": token,
  };
}
