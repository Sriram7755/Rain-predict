import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RainPredictionScreen extends StatefulWidget {
  @override
  _RainPredictionScreenState createState() => _RainPredictionScreenState();
}

class _RainPredictionScreenState extends State<RainPredictionScreen> {
  final TextEditingController tempController = TextEditingController();
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController windSpeedController = TextEditingController();
  String predictionResult = "";

  Future<void> predictRain() async {
    final url = Uri.parse("http://172.31.94.22:5000/predict"); // Use this for Android Emulator
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "temperature": tempController.text,
        "humidity": humidityController.text,
        "wind_speed": windSpeedController.text
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        predictionResult = jsonDecode(response.body)["prediction"];
      });
    } else {
      setState(() {
        predictionResult = "Error: Unable to get prediction";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rain Prediction App 🌧")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: tempController,
              decoration: InputDecoration(labelText: "Temperature (°C)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: humidityController,
              decoration: InputDecoration(labelText: "Humidity (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: windSpeedController,
              decoration: InputDecoration(labelText: "Wind Speed (km/h)"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictRain,
              child: Text("Predict"),
            ),
            SizedBox(height: 20),
            Text("Prediction: $predictionResult",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}