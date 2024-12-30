// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

class SubjectModelGet {
  int id;
  String name;
  String type;
  int countOfLectures;
  SubjectModelGet({
    required this.id,
    required this.name,
    required this.type,
    required this.countOfLectures,
  });

  SubjectModelGet copyWith({
    int? id,
    String? name,
    String? type,
    int? countOfLectures,
  }) {
    return SubjectModelGet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      countOfLectures: countOfLectures ?? this.countOfLectures,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'countOfLectures': countOfLectures,
    };
  }

  factory SubjectModelGet.fromMap(Map<String, dynamic> map) {
    return SubjectModelGet(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String,
      countOfLectures: map['countOfLectures'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModelGet.fromJson(String source) => SubjectModelGet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubjectModelGet(id: $id, name: $name, type: $type, countOfLectures: $countOfLectures)';
  }

  @override
  bool operator ==(covariant SubjectModelGet other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.countOfLectures == countOfLectures;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      countOfLectures.hashCode;
  }
}
