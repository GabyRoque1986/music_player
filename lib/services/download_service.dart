import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../models/song.dart';

class DownloadService {
  final DefaultCacheManager _cacheManager = DefaultCacheManager();
  static const String _playlistUrl =
      'https://www.rafaelamorim.com.br/mobile2/musicas/list.json';

  Future<List<Song>> fetchPlaylist() async {
    try {
      final response = await http.get(Uri.parse(_playlistUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Song.fromJson(json)).toList();
      }
      throw Exception('Error al cargar la playlist');
    } catch (e) {
      final List<dynamic> jsonList = json.decode("""
[
   {
      "title": "On the Highway - No Backing Vocals",	
      "author": "RocknStock",
      "url": "https://www.rafaelamorim.com.br/mobile2/musicas/RocknStock%20-%20On%20the%20Highway%20-%20No%20Backing%20Vocals.mp3",
      "duration": "02:40"
   },
   {
      "title": "How About That - Instrumental version",	
      "author": "Foxxi",
      "url": "https://www.rafaelamorim.com.br/mobile2/musicas/Foxxi%20-%20How%20About%20That%20-%20Instrumental%20version.mp3",
      "duration": "03:10"
   },
   {
      "title": "Crush",
      "author": "Andree Amos/Isaac Elsie/Jace Amos/Patmixedit Patmixedit",
      "url": "https://www.rafaelamorim.com.br/mobile2/musicas/AXIS1237_01_Crush_Full.mp3",
      "duration": "02:47"
   },
   {
      "title": "When Duty Calls",
      "author": "Nathan Forsbach/Ross Redmond",
      "url": "https://www.rafaelamorim.com.br/mobile2/musicas/AXIS1188_11_When%20Duty%20Calls_Full.mp3",
      "duration": "02:10"
   },
   {
      "title": "Higher Self",	
      "author": "John Cimino",
      "url": "https://www.rafaelamorim.com.br/mobile2/musicas/AXIS1199_01_Higher%20Self_Full.mp3",
      "duration": "02:20"
   }
]
""");
      return jsonList.map((json) => Song.fromJson(json)).toList();
    }
  }

  Future<void> downloadSong(Song song, Function(double) onProgress) async {
    try {
      song.isDownloading = true;
      song.downloadProgress = 0.0;

      final fileStream = _cacheManager.getFileStream(
        song.url,
        withProgress: true,
      );
      File? file;
      await for (var response in fileStream) {
        if (response is DownloadProgress) {
          final progress = response.progress ?? 0.0;
          song.downloadProgress = progress;
          onProgress(progress);
        } else if (response is FileInfo) {
          file = response.file;
        }
      }

      if (file != null) {
        // Mover el archivo a una ubicación permanente
        final appDir = await getApplicationDocumentsDirectory();
        final songsDir = Directory('${appDir.path}/songs');
        if (!await songsDir.exists()) {
          await songsDir.create(recursive: true);
        }
        final destinationPath = '${songsDir.path}/${song.id}.mp3';
        await file.copy(destinationPath);

        song.isDownloaded = true;
        song.isDownloading = false;
        song.downloadProgress = 1.0;
      }
    } catch (e) {
      song.isDownloading = false;
      song.downloadProgress = 0.0;
      rethrow;
    }
  }

  Future<void> cancelDownload(Song song) async {
    if (song.isDownloading) {
      await _cacheManager.removeFile(song.url);
      song.isDownloading = false;
      song.downloadProgress = 0.0;
    }
  }
}
