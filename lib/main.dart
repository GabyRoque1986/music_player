import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'view/Musica_Lista_View.dart';
import 'viewmodel/Musica_ViewModel.dart';

Future<void> main() async {
  print("Main iniciado"); // <<== Aqui já vemos que o main começou

  try {
    print("Inicializando JustAudioBackground...");
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.rafaelamorim.music_player.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    print("JustAudioBackground inicializado com sucesso");
  } catch (e, stack) {
    print("Erro ao inicializar JustAudioBackground: $e");
    print(stack);
  }

  print("Inicializando runApp...");
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        print("Criando MusicaViewModel");
        return MusicaViewModel();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Construindo MyApp"); // <<== aqui vemos se o build do app começa
    return MaterialApp(
      title: 'Player de Música',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) {
          print("Construindo MusicaListView"); // <<== aqui vemos se o home está sendo carregado
          return const MusicaListView();
        },
      ),
    );
  }
}
