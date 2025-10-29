import 'package:flutter/material.dart';
import 'package:music_player/view/widget/Card_musica.dart';
import 'package:provider/provider.dart' show Provider;

import '../viewmodel/Musica_ViewModel.dart';

class MusicaListView extends StatelessWidget {
  const MusicaListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MusicaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player de Música'),
      ),
      body: FutureBuilder(
        future: viewModel.carregarMusicas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: viewModel.musicas.length,
            itemBuilder: (context, index) {
              final musica = viewModel.musicas[index];
              final isSelected = viewModel.musicaAtual?.url == musica.url;
              
              return CardMusica(
                musica: musica,
                isPlaying: isSelected && viewModel.isPlaying,
                isSelected: isSelected,
                onPressed: () => viewModel.tocarOuPausar(musica),
              );
            },
          );
        },
      ),
    );
  }
}