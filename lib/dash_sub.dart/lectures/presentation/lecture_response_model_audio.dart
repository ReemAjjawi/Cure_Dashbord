// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AudioLecture {
  final int id;
  final String file_name;
  final int file_size;
  final double duration;
  final int lecture_id;
  final String file_url;
  AudioLecture({
    required this.id,
    required this.file_name,
    required this.file_size,
    required this.duration,
    required this.lecture_id,
    required this.file_url,
  });

  AudioLecture copyWith({
    int? id,
    String? file_name,
    int? file_size,
    double? duration,
    int? lecture_id,
    String? file_url,
  }) {
    return AudioLecture(
      id: id ?? this.id,
      file_name: file_name ?? this.file_name,
      file_size: file_size ?? this.file_size,
      duration: duration ?? this.duration,
      lecture_id: lecture_id ?? this.lecture_id,
      file_url: file_url ?? this.file_url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'file_name': file_name,
      'file_size': file_size,
      'duration': duration,
      'lecture_id': lecture_id,
      'file_url': file_url,
    };
  }

  factory AudioLecture.fromMap(Map<String, dynamic> map) {
    return AudioLecture(
      id: map['id'] as int,
      file_name: map['file_name'] as String,
      file_size: map['file_size'] as int,
      duration: map['duration'] as double,
      lecture_id: map['lecture_id'] as int,
      file_url: map['file_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AudioLecture.fromJson(String source) => AudioLecture.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AudioLecture(id: $id, file_name: $file_name, file_size: $file_size, duration: $duration, lecture_id: $lecture_id, file_url: $file_url)';
  }

  @override
  bool operator ==(covariant AudioLecture other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.file_name == file_name &&
      other.file_size == file_size &&
      other.duration == duration &&
      other.lecture_id == lecture_id &&
      other.file_url == file_url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      file_name.hashCode ^
      file_size.hashCode ^
      duration.hashCode ^
      lecture_id.hashCode ^
      file_url.hashCode;
  }
}
