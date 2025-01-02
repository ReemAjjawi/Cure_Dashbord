// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class PdfModel {
    int id;
    String file_name;
    int file_size;
    int lecture_id;
    String file_url;
  PdfModel({
    required this.id,
    required this.file_name,
    required this.file_size,
    required this.lecture_id,
    required this.file_url,
  });

  PdfModel copyWith({
    int? id,
    String? file_name,
    int? file_size,
    int? lecture_id,
    String? file_url,
  }) {
    return PdfModel(
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

  factory PdfModel.fromMap(Map<String, dynamic> map) {
    return PdfModel(
      id: map['id'] as int,
      file_name: map['file_name'] as String,
      file_size: map['file_size'] as int,
      lecture_id: map['lecture_id'] as int,
      file_url: map['file_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfModel.fromJson(String source) => PdfModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PdfModel(id: $id, file_name: $file_name, file_size: $file_size, lecture_id: $lecture_id, file_url: $file_url)';
  }

  @override
  bool operator ==(covariant PdfModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
