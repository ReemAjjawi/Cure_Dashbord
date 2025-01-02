import 'package:flutter/material.dart';

import '../../model.dart';


@immutable
sealed class AudioState {}

final class AudioLoading extends AudioState {}

// final class SuccessAudioState extends AudioState {
//   final DataSuccessObject<AudioModel> audio;
//   SuccessAudioState({required this.audio});
// }

final class AudioList extends AudioState {
  List<AudioModel> audio;
    AudioList({required this.audio});

}

class AudioInitial extends AudioState {}

class AudioPlaying extends AudioState {
  final Duration duration;
  final Duration position;
  
  AudioPlaying(this.duration, this.position);
}

class AudioPaused extends AudioState {
  final Duration duration;
  final Duration position;

  AudioPaused(this.duration, this.position);
}

class AudioStopped extends AudioState {}
class FailureAudioState extends AudioState {
  final String message;

  FailureAudioState({required this.message});
}
