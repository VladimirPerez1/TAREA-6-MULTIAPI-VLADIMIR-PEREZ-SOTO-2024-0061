import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/gender_screen.dart';
import 'screens/age_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/news_screen.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas ITLA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget Function() builder;

  _MenuItem(this.title, this.subtitle, this.icon, this.color, this.builder);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem('Predecir género', 'A partir de un nombre (genderize.io)',
          Icons.wc, Colors.pink, () => const GenderScreen()),
      _MenuItem('Predecir edad', 'A partir de un nombre (agify.io)',
          Icons.cake, Colors.orange, () => const AgeScreen()),
      _MenuItem('Universidades', 'Buscar universidades por país',
          Icons.school, Colors.blue, () => const UniversitiesScreen()),
      _MenuItem('Clima en RD', 'Clima de hoy en Santo Domingo',
          Icons.wb_sunny, Colors.lightBlue, () => const WeatherScreen()),
      _MenuItem('Pokémon', 'Buscar información de un Pokémon',
          Icons.catching_pokemon, Colors.red, () => const PokemonScreen()),
      _MenuItem('Noticias WordPress', 'Últimas 3 noticias de un sitio WP',
          Icons.newspaper, Colors.teal, () => const NewsScreen()),
      _MenuItem('Acerca de', 'Sobre el desarrollador',
          Icons.person, Colors.deepPurple, () => const AboutScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caja de Herramientas'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Imagen representativa de la app (caja de herramientas)
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.handyman_rounded, size: 72, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Tu caja de herramientas de apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Elige una herramienta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item.color.withOpacity(0.15),
                  child: Icon(item.icon, color: item.color),
                ),
                title: Text(item.title),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item.builder()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
