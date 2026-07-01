import 'dart:convert';
import 'package:http/http.dart' as http;

/// Servicio centralizado que agrupa todas las llamadas a APIs externas
/// usadas por la aplicación.
class ApiService {
  // ---------- 2. Género (genderize.io) ----------
  static Future<Map<String, dynamic>> getGender(String name) async {
    final uri = Uri.parse('https://api.genderize.io/?name=$name');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error consultando genderize.io (${res.statusCode})');
  }

  // ---------- 3. Edad (agify.io) ----------
  static Future<Map<String, dynamic>> getAge(String name) async {
    final uri = Uri.parse('https://api.agify.io/?name=$name');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error consultando agify.io (${res.statusCode})');
  }

  // ---------- 4. Universidades (adamix.net) ----------
  static Future<List<dynamic>> getUniversities(String country) async {
    final uri =
        Uri.parse('https://adamix.net/proxy.php?country=${Uri.encodeComponent(country)}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // La API devuelve directamente una lista de universidades.
      return data as List<dynamic>;
    }
    throw Exception('Error consultando universidades (${res.statusCode})');
  }

  // ---------- 5. Clima (Open-Meteo, sin API key) ----------
  // Santo Domingo, República Dominicana: lat 18.4861, lon -69.9312
  static Future<Map<String, dynamic>> getWeatherSantoDomingo() async {
    final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312'
        '&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m'
        '&daily=temperature_2m_max,temperature_2m_min,weather_code'
        '&timezone=America%2FSanto_Domingo');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error consultando el clima (${res.statusCode})');
  }

  // ---------- 6. Pokémon (PokeAPI) ----------
  static Future<Map<String, dynamic>> getPokemon(String name) async {
    final uri =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Pokémon no encontrado (${res.statusCode})');
  }

  // ---------- 7. Noticias WordPress (REST API oficial de WordPress.org) ----------
  // API usada: https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_embed
  // (Publicar este enlace en el foro del curso, tal como pide la tarea)
  static Future<List<dynamic>> getWordPressNews() async {
    final uri = Uri.parse(
        'https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_embed');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List<dynamic>;
    }
    throw Exception('Error consultando noticias (${res.statusCode})');
  }
}
