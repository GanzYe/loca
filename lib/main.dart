import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double? alpha;
  double? beta;
  double? gamma;
  double targetX = 0.0;
  double targetY = 0.0;

  @override
  void initState() {
    super.initState();
    html.window.onMessage.listen((event) {
      if (event.data != null && event.data is Map) {
        setState(() {
          alpha = event.data['alpha'];
          beta = event.data['beta'];
          gamma = event.data['gamma'];
        });
      }
    });

    generateRandomCoordinates();
  }

  void generateRandomCoordinates() {
    final random = Random();
    targetX =
        random.nextDouble() * 200 - 100; // Координаты в диапазоне [-100, 100]
    targetY =
        random.nextDouble() * 200 - 100; // Координаты в диапазоне [-100, 100]
  }

  double calculateAngle(double alpha, double beta, double gamma) {
    // Простой расчет угла на основе альфа (yaw) для примера
    return alpha * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Loca Game'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                Spacer(),
                alpha != null
                    ? Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color.fromARGB(255, 214, 70, 68),
                              width: 5),
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: calculateAngle(alpha!, beta!, gamma!),
                            child: ImageIcon(
                              AssetImage('assets/arrow.png'),
                              size: 150,
                              color: const Color.fromARGB(255, 214, 70, 68),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 214, 70, 68),
                    ),
                    onPressed: generateRandomCoordinates,
                    child: const Text(
                      'Start New Game',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
