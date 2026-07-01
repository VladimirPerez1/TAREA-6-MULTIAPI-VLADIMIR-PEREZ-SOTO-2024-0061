import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _controller = TextEditingController();
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
      final result = await ApiService.getGender(name);
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gender = _data?['gender'] as String?; // "male" | "female" | null
    final isMale = gender == 'male';
    final bgColor = _data == null
        ? Colors.grey.shade100
        : (isMale ? Colors.blue.shade100 : Colors.pink.shade100);
    final accent = isMale ? Colors.blue : Colors.pink;

    return Scaffold(
      appBar: AppBar(title: const Text('Predicción de género')),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: bgColor,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                hintText: 'Ej: Irma',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
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
            if (_data != null && _error == null)
              ResultCard(
                child: Column(
                  children: [
                    Icon(
                      isMale ? Icons.male : Icons.female,
                      size: 72,
                      color: accent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_data!['name']}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      isMale ? 'Género: Masculino' : 'Género: Femenino',
                      style: TextStyle(
                          fontSize: 18,
                          color: accent,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Probabilidad: ${((_data!['probability'] ?? 0) * 100).toStringAsFixed(0)}%'
                      '  •  Muestras: ${_data!['count']}',
                      style: const TextStyle(color: Colors.black54),
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
