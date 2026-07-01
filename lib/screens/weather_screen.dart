import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';

/// Traduce el "weather code" de Open-Meteo (estándar WMO) a texto e ícono.
({String label, IconData icon}) _describeWeatherCode(int code) {
  if (code == 0) return (label: 'Cielo despejado', icon: Icons.wb_sunny);
  if (code <= 2) return (label: 'Parcialmente nublado', icon: Icons.wb_cloudy);
  if (code == 3) return (label: 'Nublado', icon: Icons.cloud);
  if (code == 45 || code == 48) return (label: 'Neblina', icon: Icons.foggy);
  if (code >= 51 && code <= 57) return (label: 'Llovizna', icon: Icons.grain);
  if (code >= 61 && code <= 67) return (label: 'Lluvia', icon: Icons.umbrella);
  if (code >= 80 && code <= 82) return (label: 'Chubascos', icon: Icons.beach_access);
  if (code >= 95) return (label: 'Tormenta eléctrica', icon: Icons.thunderstorm);
  return (label: 'Clima variable', icon: Icons.cloud_queue);
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

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
      final result = await ApiService.getWeatherSantoDomingo();
      setState(() => _data = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _data?['current'] as Map<String, dynamic>?;
    final daily = _data?['daily'] as Map<String, dynamic>?;

    Widget content;
    if (_loading) {
      content = const CircularProgressIndicator();
    } else if (_error != null) {
      content = ResultCard(child: ErrorMessage(message: _error!));
    } else if (current != null) {
      final code = current['weather_code'] as int? ?? 0;
      final info = _describeWeatherCode(code);
      final temp = current['temperature_2m'];
      final humidity = current['relative_humidity_2m'];
      final wind = current['wind_speed_10m'];
      final tMax = daily?['temperature_2m_max']?[0];
      final tMin = daily?['temperature_2m_min']?[0];
      final today = DateFormat('EEEE d MMMM y', 'es').format(DateTime.now());

      content = ResultCard(
        child: Column(
          children: [
            Text(today, style: const TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 8),
            const Text('Santo Domingo, República Dominicana',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Icon(info.icon, size: 90, color: Colors.orange),
            const SizedBox(height: 8),
            Text('$temp°C', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Text(info.label, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: [
                _InfoChip(icon: Icons.water_drop, text: 'Humedad: $humidity%'),
                _InfoChip(icon: Icons.air, text: 'Viento: $wind km/h'),
                if (tMax != null) _InfoChip(icon: Icons.arrow_upward, text: 'Máx: $tMax°C'),
                if (tMin != null) _InfoChip(icon: Icons.arrow_downward, text: 'Mín: $tMin°C'),
              ],
            ),
          ],
        ),
      );
    } else {
      content = const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: content),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
    );
  }
}
