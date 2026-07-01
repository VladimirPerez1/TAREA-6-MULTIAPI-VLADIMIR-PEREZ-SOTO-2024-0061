import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

/// Elimina etiquetas HTML simples que vienen en el "excerpt" de WordPress.
String _stripHtml(String html) {
  final withoutTags = html.replaceAll(RegExp(r'<[^>]*>'), '');
  return withoutTags
      .replaceAll('&#8230;', '…')
      .replaceAll('&#8217;', '\'')
      .replaceAll('&amp;', '&')
      .trim();
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _loading = true;
  String? _error;
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ApiService.getWordPressNews();
      setState(() => _posts = result);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo del sitio WordPress usado (WordPress.org News)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://s.w.org/style/images/about/WordPress-logotype-wmark.png',
                  height: 60,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.public, size: 50),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Últimas noticias de WordPress.org',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null) ResultCard(child: ErrorMessage(message: _error!)),
            if (!_loading && _error == null)
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    final title = _stripHtml(post['title']?['rendered'] ?? '');
                    final excerpt =
                        _stripHtml(post['excerpt']?['rendered'] ?? '');
                    final link = post['link'] as String?;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(excerpt,
                                style: const TextStyle(color: Colors.black87)),
                            const SizedBox(height: 10),
                            if (link != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => _openLink(link),
                                  icon: const Icon(Icons.open_in_new, size: 18),
                                  label: const Text('Visitar'),
                                ),
                              ),
                          ],
                        ),
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
