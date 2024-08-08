import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  String areaName = '';
  String weather = '';
  double temperature = 0;
  int humidity = 0;
  double temperatureMax = 0;
  double temperatureMin = 0;

Future<void> loadWeather(String query) async {
  final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?appid=927593552cfdec4ba7a21d15ce857e50&lang=ja&units=metric&q=$query'));
  if(response.statusCode != 200) {
    return;
  }
  print(response.body);
  final body = json.decode(response.body) as Map<String, dynamic>;
  final main = (body['main'] ?? {}) as Map<String, dynamic>;
  setState(() {
    areaName = body['name'];
    weather = (body['weather']?[0]?['description'] ?? '') as String;
    humidity = (main['humidity'] ?? 0) as int;
    temperature = (main['temp'] ?? 0) as double;
    temperatureMax = (main['temp_max'] ?? 0) as double;
    temperatureMin = (main['temp_min'] ?? 0) as double;
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isNotEmpty) {
              loadWeather(value);
            }
          },
        ),
      ),
      body: ListView(
        children: [
          ListTile(title: Text('地域'),subtitle: Text(areaName),),
          ListTile(title: Text('天気'),subtitle: Text(weather),),
          ListTile(title: Text('温度'),subtitle: Text(temperature.toString()),),
          ListTile(title: Text('最高温度'),subtitle: Text(temperatureMax.toString()),),
          ListTile(title: Text('最低温度'),subtitle: Text(temperatureMin.toString()),),
          ListTile(title: Text('湿度'),subtitle: Text(humidity.toString()),),

        ],
      ),
    );
  }
}
