
sealed class AudioBEvent {}

 class GetAudio extends AudioBEvent {


 }

class PlayAudio extends AudioBEvent {
  final String url;
  PlayAudio(this.url);
}

class PauseAudio extends AudioBEvent {}

class StopAudio extends AudioBEvent {}

class UpdatePosition extends AudioBEvent {
  final Duration position;
  UpdatePosition(this.position);
}
