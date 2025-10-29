import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'view/Musica_Lista_View.dart';
import 'viewmodel/Musica_ViewModel.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.rafaelamorim.music_player.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => MusicaViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player de Música',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MusicaListView(),
    );
  }
}