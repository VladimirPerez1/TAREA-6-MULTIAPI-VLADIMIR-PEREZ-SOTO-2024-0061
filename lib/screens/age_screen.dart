import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

enum _AgeGroup { joven, adulto, anciano }

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  Map<String, dynamic>? _data;

  _AgeGroup _groupFor(int age) {
    if (age < 30) return _AgeGroup.joven;
    if (age < 60) return _AgeGroup.adulto;
    return _AgeGroup.anciano;
  }

  Future<void> _search() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _data = null;
    });
    try {
      final result = await ApiService.getAge(name);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = _data?['age'] as int?;
    final group = age != null ? _groupFor(age) : null;

    final config = {
      _AgeGroup.joven: (
        label: 'Joven',
        icon: Icons.directions_run,
        color: Colors.green,
      ),
      _AgeGroup.adulto: (
        label: 'Adulto',
        icon: Icons.work,
        color: Colors.orange,
      ),
      _AgeGroup.anciano: (
        label: 'Anciano',
        icon: Icons.elderly,
        color: Colors.brown,
      ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de edad')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                hintText: 'Ej: Meelad',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: const Icon(Icons.search),
              label: const Text('Consultar'),
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) ResultCard(child: ErrorMessage(message: _error!)),
            if (_data != null && group != null && _error == null)
              ResultCard(
                child: Column(
                  children: [
                    Icon(config[group]!.icon, size: 80, color: config[group]!.color),
                    const SizedBox(height: 12),
                    Text(
                      '${_data!['name']}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Edad estimada: $age años',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        config[group]!.label,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: config[group]!.color,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
