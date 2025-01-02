import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../config/app_url.dart';

class AudioUploadPage extends StatefulWidget {
  const AudioUploadPage({super.key});

  @override
  _AudioUploadPageState createState() => _AudioUploadPageState();
}

class _AudioUploadPageState extends State<AudioUploadPage> {
  String? _filePath;

  Future<void> _pickAudio() async {
    // Picking audio file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      print('File selected: ${result.files.single.path}');

      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _uploadAudio() async {
    if (_filePath == null) {
      return;
    }

    File file = File(_filePath!);

    // Create Dio instance
    Dio dio = Dio();

    try {
      FormData formData = FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(file.path,
            filename: file.uri.pathSegments.last),
      });
      print("object");

      // Send the request
      Response response = await dio.post(
        'http://199.192.19.220:8000/api/v1/lectures/4/audio-lectures',
        data: formData,
      );
      print("object");
      if (response.statusCode == 201) {
        print('File uploaded successfully');
      } else {
        print('File upload failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error uploading file: $e');
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_filePath != null) Text('Selected: $_filePath'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickAudio,
              child: const Text('Pick Audio'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadAudio,
              child: const Text('Upload Audio'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AudioUploadPage(),
  ));
}
