// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

class SubjectModel {
  int id;
  String name;
  int type;
  String updated_at;
  String created_at;
  SubjectModel({
    required this.id,
    required this.name,
    required this.type,
    required this.updated_at,
    required this.created_at,
  });

  SubjectModel copyWith({
    int? id,
    String? name,
    int? type,
    String? updated_at,
    String? created_at,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      updated_at: updated_at ?? this.updated_at,
      created_at: created_at ?? this.created_at,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'updated_at': updated_at,
      'created_at': created_at,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as int,
      updated_at: map['updated_at'] as String,
      created_at: map['created_at'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) => SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubjectModel(id: $id, name: $name, type: $type, updated_at: $updated_at, created_at: $created_at)';
  }

  @override
  bool operator ==(covariant SubjectModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.updated_at == updated_at &&
      other.created_at == created_at;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      updated_at.hashCode ^
      created_at.hashCode;
  }
}
