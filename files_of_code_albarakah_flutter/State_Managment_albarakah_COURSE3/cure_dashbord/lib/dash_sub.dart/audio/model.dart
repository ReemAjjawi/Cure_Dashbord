// To parse this JSON data, do
//
//     final audioModel = audioModelFromJson(jsonString);

import 'dart:convert';

AudioModel audioModelFromJson(String str) => AudioModel.fromJson(json.decode(str));

String audioModelToJson(AudioModel data) => json.encode(data.toJson());

class AudioModel {
    int id;
    String fileName;
    int fileSize;
    int duration;
    int lectureId;
    String fileUrl;

    AudioModel({
        required this.id,
        required this.fileName,
        required this.fileSize,
        required this.duration,
        required this.lectureId,
        required this.fileUrl,
    });

    factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
        id: json["id"],
        fileName: json["file_name"],
        fileSize: json["file_size"],
        duration: json["duration"],
        lectureId: json["lecture_id"],
        fileUrl: json["file_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "file_name": fileName,
        "file_size": fileSize,
        "duration": duration,
        "lecture_id": lectureId,
        "file_url": fileUrl,
    };
}
