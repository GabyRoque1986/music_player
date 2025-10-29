import 'package:flutter/material.dart';
import '../../model/Musica_Model.dart';


class CardMusica extends StatelessWidget {
  final MusicaModel musica;
  final VoidCallback onPressed;
  final VoidCallback? onDownload;
  final bool isPlaying;
  final bool isSelected;
  final bool isDownloading;

  const CardMusica({
    required this.musica,
    required this.onPressed,
    this.onDownload,
    required this.isPlaying,
    required this.isSelected,
    this.isDownloading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/7826/7826826.png",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.music_note, size: 32),
            ),
          ),
          const SizedBox(width: 12),
          // --- Título e autor ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  musica.title,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  musica.author,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // --- Botão de play/pause ---
          IconButton(
            icon: Icon(
              isSelected
                  ? (isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled)
                  : Icons.play_arrow_rounded,
              size: 32,
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.grey.shade800,
            ),
            onPressed: onPressed,
          ),

          // --- Botão de download ---
          IconButton(
            icon: isDownloading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_rounded, size: 26),
            onPressed: isDownloading ? null : onDownload,
          ),
        ],
      ),
    );
  }
}
