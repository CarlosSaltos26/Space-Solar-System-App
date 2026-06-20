import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Servicio global de audio de fondo.
///
///
/// El botón de mute/play solo se muestra en HomeScreen, pero como este
/// servicio es global, el estado (_isPlaying) se mantiene sin importar
/// en qué pantalla esté el usuario.
class AudioService extends ChangeNotifier with WidgetsBindingObserver {
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isPlaying = true;
  bool get isPlaying => _isPlaying;

  // Recordamos si el usuario muteó manualmente, para no "revivir" el audio
  // al volver de segundo plano si el usuario lo había pausado a propósito.
  bool _wasPlayingBeforeBackground = true;

  AudioService() {
    WidgetsBinding.instance.addObserver(this);
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset('assets/audio/fondoSpaceApp.mp3');
      await _audioPlayer.setLoopMode(LoopMode.all);

      //AUDIO DEL VOLUMEN OJOOOOOOOO
      await _audioPlayer.setVolume(1.5);

      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Error cargando el audio: $e");
    }
  }

  /// Alterna entre reproducir y pausar. Se llama desde el botón en HomeScreen.
  void toggleAudio() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // Guardamos si estaba sonando ANTES de pasar a segundo plano,
      // para saber si debemos retomarlo al volver.
      _wasPlayingBeforeBackground = _isPlaying;
      _audioPlayer.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_wasPlayingBeforeBackground) {
        _audioPlayer.play();
        _isPlaying = true;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }
}