import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PdfLecture {
  final int? id;
  final String? file_name;
  final int file_size;
  final int lecture_id;
  final String? file_url;
  PdfLecture({
    this.id,
    this.file_name,
    required this.file_size,
    required this.lecture_id,
    this.file_url,
  });

  PdfLecture copyWith({
    int? id,
    String? file_name,
    int? file_size,
    int? lecture_id,
    String? file_url,
  }) {
    return PdfLecture(
      id: id ?? this.id,
      file_name: file_name ?? this.file_name,
      file_size: file_size ?? this.file_size,
      lecture_id: lecture_id ?? this.lecture_id,
      file_url: file_url ?? this.file_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'file_name': file_name,
      'file_size': file_size,
      'lecture_id': lecture_id,
      'file_url': file_url,
    };
  }

  factory PdfLecture.fromMap(Map<String, dynamic> map) {
    return PdfLecture(
      id: map['id'] != null ? map['id'] as int : null,
      file_name: map['file_name'] != null ? map['file_name'] as String : null,
      file_size: map['file_size'] as int,
      lecture_id: map['lecture_id'] as int,
      file_url: map['file_url'] != null ? map['file_url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfLecture.fromJson(String source) =>
      PdfLecture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdfLecture(id: $id, file_name: $file_name, file_size: $file_size, lecture_id: $lecture_id, file_url: $file_url)';
  }

  @override
  bool operator ==(covariant PdfLecture other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.file_name == file_name &&
        other.file_size == file_size &&
        other.lecture_id == lecture_id &&
        other.file_url == file_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        file_name.hashCode ^
        file_size.hashCode ^
        lecture_id.hashCode ^
        file_url.hashCode;
  }
}
