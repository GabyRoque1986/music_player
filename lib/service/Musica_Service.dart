import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Musica_Model.dart';

class MusicaService {
  static const String jsonUrl = 'https://www.rafaelamorim.com.br/mobile2/musicas/list.json';

  Future<List<MusicaModel>> fetchMusicas() async {
    final response = await http.get(Uri.parse(jsonUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MusicaModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar músicas');
    }
  }
}