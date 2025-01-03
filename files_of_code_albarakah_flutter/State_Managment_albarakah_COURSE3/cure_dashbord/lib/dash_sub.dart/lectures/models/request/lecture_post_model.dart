// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LectureAdd {
  String name;
  int subject_id;
  LectureAdd({
    required this.name,
    required this.subject_id,
  });

  LectureAdd copyWith({
    String? name,
    int? subject_id,
  }) {
    return LectureAdd(
      name: name ?? this.name,
      subject_id: subject_id ?? this.subject_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subject_id': subject_id,
    };
  }

  factory LectureAdd.fromMap(Map<String, dynamic> map) {
    return LectureAdd(
      name: map['name'] as String,
      subject_id: map['subject_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LectureAdd.fromJson(String source) => LectureAdd.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LectureAdd(name: $name, subject_id: $subject_id)';

  @override
  bool operator ==(covariant LectureAdd other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.subject_id == subject_id;
  }

  @override
  int get hashCode => name.hashCode ^ subject_id.hashCode;
}
