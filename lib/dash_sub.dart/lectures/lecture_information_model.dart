// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LectureInformationModel {
  int id;
  String name;
  int subject_id;
  int? audioLectureId;
  String? audioLectureDownloadLink;
  int? pdfLectureId;
  String? pdfLectureDownloadLink;
  LectureInformationModel({
    required this.id,
    required this.name,
    required this.subject_id,
    this.audioLectureId,
    this.audioLectureDownloadLink,
    this.pdfLectureId,
    this.pdfLectureDownloadLink,
  });

  LectureInformationModel copyWith({
    int? id,
    String? name,
    int? subject_id,
    int? audioLectureId,
    String? audioLectureDownloadLink,
    int? pdfLectureId,
    String? pdfLectureDownloadLink,
  }) {
    return LectureInformationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subject_id: subject_id ?? this.subject_id,
      audioLectureId: audioLectureId ?? this.audioLectureId,
      audioLectureDownloadLink:
          audioLectureDownloadLink ?? this.audioLectureDownloadLink,
      pdfLectureId: pdfLectureId ?? this.pdfLectureId,
      pdfLectureDownloadLink:
          pdfLectureDownloadLink ?? this.pdfLectureDownloadLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'subject_id': subject_id,
      'audioLectureId': audioLectureId,
      'audioLectureDownloadLink': audioLectureDownloadLink,
      'pdfLectureId': pdfLectureId,
      'pdfLectureDownloadLink': pdfLectureDownloadLink,
    };
  }

  factory LectureInformationModel.fromMap(Map<String, dynamic> map) {
    return LectureInformationModel(
      id: map['id'] as int,
      name: map['name'] as String,
      subject_id: map['subject_id'] as int,
      audioLectureId:
          map['audioLectureId'] != null ? map['audioLectureId'] as int : null,
      audioLectureDownloadLink: map['audioLectureDownloadLink'] != null
          ? map['audioLectureDownloadLink'] as String
          : null,
      pdfLectureId:
          map['pdfLectureId'] != null ? map['pdfLectureId'] as int : null,
      pdfLectureDownloadLink: map['pdfLectureDownloadLink'] != null
          ? map['pdfLectureDownloadLink'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LectureInformationModel.fromJson(String source) =>
      LectureInformationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LectureInformationModel(id: $id, name: $name, subject_id: $subject_id, audioLectureId: $audioLectureId, audioLectureDownloadLink: $audioLectureDownloadLink, pdfLectureId: $pdfLectureId, pdfLectureDownloadLink: $pdfLectureDownloadLink)';
  }

  @override
  bool operator ==(covariant LectureInformationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.subject_id == subject_id &&
        other.audioLectureId == audioLectureId &&
        other.audioLectureDownloadLink == audioLectureDownloadLink &&
        other.pdfLectureId == pdfLectureId &&
        other.pdfLectureDownloadLink == pdfLectureDownloadLink;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        subject_id.hashCode ^
        audioLectureId.hashCode ^
        audioLectureDownloadLink.hashCode ^
        pdfLectureId.hashCode ^
        pdfLectureDownloadLink.hashCode;
  }
}
