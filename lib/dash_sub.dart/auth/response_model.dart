// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResponseModel {
  String message;
  String token;
  ResponseModel({
    required this.message,
    required this.token,
  });

  ResponseModel copyWith({
    String? message,
    String? token,
  }) {
    return ResponseModel(
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'token': token,
    };
  }

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      message: map['message'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseModel.fromJson(String source) => ResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResponseModel(message: $message, token: $token)';

  @override
  bool operator ==(covariant ResponseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.message == message &&
      other.token == token;
  }

  @override
  int get hashCode => message.hashCode ^ token.hashCode;
}
