import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController();
  final _player = AudioPlayer();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _data;

  Future<void> _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _data = null;
    });
    try {
      final result = await ApiService.getPokemon(name);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = 'No se encontró ese Pokémon. Verifica el nombre.');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _playCry() async {
    final cryUrl = _data?['cries']?['latest'] as String?;
    if (cryUrl != null) {
      await _player.play(UrlSource(cryUrl));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sprite = _data?['sprites']?['other']?['official-artwork']?['front_default']
        as String?;
    final baseExp = _data?['base_experience'];
    final abilities = (_data?['abilities'] as List?)
            ?.map((a) => a['ability']?['name'] as String? ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];
    final hasCry = _data?['cries']?['latest'] != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre del Pokémon',
                hintText: 'Ej: pikachu',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: const Icon(Icons.search),
              label: const Text('Buscar'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) ResultCard(child: ErrorMessage(message: _error!)),
            if (_data != null && _error == null)
              Expanded(
                child: SingleChildScrollView(
                  child: ResultCard(
                    child: Column(
                      children: [
                        if (sprite != null)
                          Image.network(sprite, height: 180)
                        else
                          const Icon(Icons.catching_pokemon, size: 120),
                        const SizedBox(height: 8),
                        Text(
                          '${_data!['name']}'.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Experiencia base: $baseExp',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          alignment: WrapAlignment.center,
                          children: abilities
                              .map((a) => Chip(label: Text(a)))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        if (hasCry)
                          ElevatedButton.icon(
                            onPressed: _playCry,
                            icon: const Icon(Icons.volume_up),
                            label: const Text('Reproducir sonido'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
