// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CodeResponse {
  String activation_code;
  bool is_taken;
  int id;
  CodeResponse({
    required this.activation_code,
    required this.is_taken,
    required this.id,
  });

  CodeResponse copyWith({
    String? activation_code,
    bool? is_taken,
    int? id,
  }) {
    return CodeResponse(
      activation_code: activation_code ?? this.activation_code,
      is_taken: is_taken ?? this.is_taken,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activation_code': activation_code,
      'is_taken': is_taken,
      'id': id,
    };
  }

  factory CodeResponse.fromMap(Map<String, dynamic> map) {
    return CodeResponse(
      activation_code: map['activation_code'] as String,
      is_taken: map['is_taken'] as bool,
      id: map['id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeResponse.fromJson(String source) => CodeResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CodeResponse(activation_code: $activation_code, is_taken: $is_taken, id: $id)';

  @override
  bool operator ==(covariant CodeResponse other) {
    if (identical(this, other)) return true;
  
    return 
      other.activation_code == activation_code &&
      other.is_taken == is_taken &&
      other.id == id;
  }

  @override
  int get hashCode => activation_code.hashCode ^ is_taken.hashCode ^ id.hashCode;
}
