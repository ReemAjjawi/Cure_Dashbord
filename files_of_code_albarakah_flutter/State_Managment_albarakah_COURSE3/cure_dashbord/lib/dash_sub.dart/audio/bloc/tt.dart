import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioDownloader extends StatefulWidget {
  @override
  _AudioDownloaderState createState() => _AudioDownloaderState();
}

class _AudioDownloaderState extends State<AudioDownloader> {
  bool isLoading = false;
  bool isDownloaded = false;
  final String fileName = 'audio.mp3';
  final String url = 'https://example.com/audio.mp3';

  @override
  void initState() {
    super.initState();
    _checkFile();
  }

  Future<void> _checkFile() async {
    final available = await isAudioFileAvailable(fileName);
    setState(() => isDownloaded = available);
  }

  Future<void> downloadAudio() async {
    setState(() => isLoading = true);
    try {
      await _downloadAudioFile(url, fileName);
      setState(() {
        isLoading = false;
        isDownloaded = true;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Download failed: $e");
    }
  }

  Future<void> playAudio() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    AudioPlayer player = AudioPlayer();
    await player.play(DeviceFileSource(filePath));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: isLoading
              ? CircularProgressIndicator()
              : Icon(isDownloaded ? Icons.check : Icons.download),
          onPressed: isDownloaded ? null : downloadAudio,
        ),
        if (isDownloaded)
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: playAudio,
          ),
      ],
    );
  }

  Future<File> _downloadAudioFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    if (await file.exists()) return file;

    Dio dio = Dio();
    await dio.download(url, filePath);
    return file;
  }

  Future<bool> isAudioFileAvailable(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    return File(filePath).exists();
  }
}