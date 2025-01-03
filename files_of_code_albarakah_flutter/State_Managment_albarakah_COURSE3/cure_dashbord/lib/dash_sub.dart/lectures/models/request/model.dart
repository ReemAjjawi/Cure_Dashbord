// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LectureModel {
  int id;
  String name;
  int subject_id;
  LectureModel({
    required this.id,
    required this.name,
    required this.subject_id,
  });

  LectureModel copyWith({
    int? id,
    String? name,
    int? subject_id,
  }) {
    return LectureModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subject_id: subject_id ?? this.subject_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'subject_id': subject_id,
    };
  }

  factory LectureModel.fromMap(Map<String, dynamic> map) {
    return LectureModel(
      id: map['id'] as int,
      name: map['name'] as String,
      subject_id: map['subject_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LectureModel.fromJson(String source) =>
      LectureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'LectureModel(id: $id, name: $name, subject_id: $subject_id)';

  @override
  bool operator ==(covariant LectureModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.subject_id == subject_id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ subject_id.hashCode;
}
