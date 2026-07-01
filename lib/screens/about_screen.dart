import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const nombre = 'Vladimir Perez Soto';
    const carrera = 'Desarrollo de Software';
    const email = 'vladimirperezsoto1@gmail.com';
    const telefono = '+1 849-273-0349';
    const github = 'https://github.com/VladimirPerez1';

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.indigo.shade100,
              backgroundImage: const AssetImage('assets/images/app_icon.png'),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(nombre,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Text(carrera, style: TextStyle(color: Colors.black54)),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.indigo),
                  title: const Text(email),
                  onTap: () => _open('mailto:$email'),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.indigo),
                  title: const Text(telefono),
                  onTap: () => _open('tel:$telefono'),
                ),
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.indigo),
                  title: const Text('GitHub'),
                  onTap: () => _open(github),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Disponible para oportunidades laborales y pasantías en '
                'desarrollo de software móvil y consumo de APIs.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
