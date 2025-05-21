import 'dart:convert';
import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// TODO: Replace with your own API key from https://openweathermap.org
const String apiKey = 'c83ba7edbba3feeeb299b24c6a8d822a';
const String city = 'São Paulo'; // or any city you like

// void main() {
//   runApp(const WeatherApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AgentConfiguration(
    appKey: "AD-AAB-ADY-XJZ",
    loggingLevel: LoggingLevel.verbose, // optional, for better debugging.
  );
  await Instrumentation.start(config);

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String? _description;
  double? _temperature;
  bool _loading = true;
  String? _error;

  @override
  Future<void> initState() async {
    super.initState();
    await WidgetTracker.instance.trackWidgetStart("Main");
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=-23.4682814&lon=-46.8737504&appid=$apiKey',
    );
    try {
      final client = TrackedHttpClient(http.Client());
      final response = await client.get(Uri.parse(url.toString()));
      // final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _description = data['weather'][0]['description'];
          _temperature = data['main']['temp'];
          _loading = false;
        });
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current Weather')),
      body: Center(
        child:
            _loading
                ? const CircularProgressIndicator()
                : _error != null
                ? Text('Error: $_error')
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_temperature?.toStringAsFixed(1)} °C',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _description ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
      ),
    );
  }
}
