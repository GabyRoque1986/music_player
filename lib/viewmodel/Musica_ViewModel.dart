import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/service/Musica_Service.dart';
import '../model/Musica_Model.dart';
import 'dart:developer';


class MusicaViewModel with ChangeNotifier {
  final MusicaService _musicaService = MusicaService();
  final AudioPlayer _player = AudioPlayer();
  
  List<MusicaModel> _musicas = [];
  MusicaModel? _musicaAtual;
  bool _isPlaying = false;
  bool _isBuffering = false;

  List<MusicaModel> get musicas => _musicas;
  MusicaModel? get musicaAtual => _musicaAtual;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;

  Future<void> carregarMusicas() async {
    _musicas = await _musicaService.fetchMusicas();
    notifyListeners();
  }

  Future<void> tocarOuPausar(MusicaModel musica) async {
    if (_musicaAtual?.url == musica.url) {
      if (_player.playing) {
        await _player.pause();
        _isPlaying = false;
      } else {
        await _player.play();
        _isPlaying = true;
      }
      notifyListeners();
      return;
    }

    await _player.stop();
    _musicaAtual = musica;
    _isPlaying = false;
    _isBuffering = true;
    notifyListeners();

    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(musica.url),
          tag: MediaItem(
            id: musica.url,
            title: musica.title,
            artist: musica.author,
            duration: Duration(seconds: musica.duration.toInt()),
          ),
        ),
      );
      await _player.play();
      _isPlaying = true;
      _isBuffering = false;
      notifyListeners();

      _player.playerStateStream.listen((state) {
        _isBuffering = state.processingState == ProcessingState.buffering;
        _isPlaying = state.playing;
        notifyListeners();
      });
    } catch (e) {
  _isBuffering = false;
  notifyListeners();
  log('Erro ao tocar música: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }
}