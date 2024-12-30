// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogInModelAdmin {
  String phone_number;
  String password;
  LogInModelAdmin({
    required this.phone_number,
    required this.password,
  });

  LogInModelAdmin copyWith({
    String? phone_number,
    String? password,
  }) {
    return LogInModelAdmin(
      phone_number: phone_number ?? this.phone_number,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone_number': phone_number,
      'password': password,
    };
  }

  factory LogInModelAdmin.fromMap(Map<String, dynamic> map) {
    return LogInModelAdmin(
      phone_number: map['phone_number'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogInModelAdmin.fromJson(String source) => LogInModelAdmin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LogInModelAdmin(phone_number: $phone_number, password: $password)';

  @override
  bool operator ==(covariant LogInModelAdmin other) {
    if (identical(this, other)) return true;
  
    return 
      other.phone_number == phone_number &&
      other.password == password;
  }

  @override
  int get hashCode => phone_number.hashCode ^ password.hashCode;
}
