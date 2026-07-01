import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final _controller = TextEditingController(text: 'Dominican Republic');
  bool _loading = false;
  String? _error;
  List<dynamic> _universities = [];

  Future<void> _search() async {
    final country = _controller.text.trim();
    if (country.isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
      _universities = [];
    });
    try {
      final result = await ApiService.getUniversities(country);
      setState(() => _universities = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por país')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'País (en inglés)',
                hintText: 'Ej: Dominican Republic',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: const Icon(Icons.search),
              label: const Text('Buscar universidades'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) ResultCard(child: ErrorMessage(message: _error!)),
            if (!_loading && _error == null)
              Expanded(
                child: ListView.builder(
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final uni = _universities[index];
                    final name = uni['name'] ?? 'Sin nombre';
                    final domains =
                        (uni['domains'] as List?)?.join(', ') ?? 'N/D';
                    final webPages = (uni['web_pages'] as List?) ?? [];
                    final website =
                        webPages.isNotEmpty ? webPages.first.toString() : null;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.school),
                        ),
                        title: Text(name),
                        subtitle: Text('Dominio: $domains'),
                        trailing: website != null
                            ? IconButton(
                                icon: const Icon(Icons.open_in_new),
                                onPressed: () => _openLink(website),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
