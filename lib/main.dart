import 'dart:html' as html;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TelegramWebApp telegram = TelegramWebApp.instance;

  bool? isDefinedVersion;
  String? clipboardText;

  double? alpha;
  double? beta;
  double? gamma;
  double targetX = 0.0;
  double targetY = 0.0;

  final BorderRadius _borderRadius = const BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
  );

  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(24);

  int _selectedItemPosition = 0;
  PageController _pageController = PageController(initialPage: 0);
  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color selectedColor = Color.fromARGB(255, 214, 70, 68);
  Color unselectedColor = Colors.blueGrey;

  @override
  void initState() {
    super.initState();
    super.initState();
    telegram.ready();

    check();
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

  void check() async {
    await Future.delayed(const Duration(seconds: 2));
    isDefinedVersion = await telegram.isVersionAtLeast('Bot API 6.1');
    setState(() {});
  }

  void generateRandomCoordinates() {
    final random = Random();
    setState(() {
      targetX = random.nextDouble() * 200 - 100;
      targetY = random.nextDouble() * 200 - 100;
    });
  }

  double calculateAngle(double targetX, double targetY, double alpha) {
    // Вычисляем угол до целевой позиции
    double angleToTarget = atan2(targetY, targetX);
    // Преобразуем alpha (угол устройства) в радианы
    double deviceAngle = alpha * (pi / 180);
    // Возвращаем разницу между углом до целевой позиции и углом устройства
    double angle = angleToTarget - deviceAngle;

    // Нормализуем угол в диапазоне от -π до π
    if (angle < -pi) {
      angle += 2 * pi;
    } else if (angle > pi) {
      angle -= 2 * pi;
    }
    return deviceAngle;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SnakeNavigationBar.color(
          // height: 80,
          behaviour: snakeBarStyle,
          snakeShape: snakeShape,
          shape: bottomBarShape,
          padding: padding,
          backgroundColor: Color(0xFFE0E0E0),

          ///configuration for SnakeNavigationBar.color
          snakeViewColor: selectedColor,
          selectedItemColor:
              snakeShape == SnakeShape.indicator ? selectedColor : null,
          unselectedItemColor: unselectedColor,

          ///configuration for SnakeNavigationBar.gradient
          // snakeViewGradient: selectedGradient,
          // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          // unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: showUnselectedLabels,
          showSelectedLabels: showSelectedLabels,

          currentIndex: _selectedItemPosition,
          onTap: (index) {
            setState(() => _selectedItemPosition = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
            );
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send_and_archive_outlined),
              label: 'search',
            )
          ],
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              children: [
                Column(
                  children: [
                    Spacer(),
                    alpha != null
                        ? Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color.fromARGB(255, 214, 70, 68),
                                  width: 5),
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: calculateAngle(targetX, targetY, alpha!),
                                child: const ImageIcon(
                                  AssetImage('images/arrow.png'),
                                  size: 150,
                                  color: Color.fromARGB(255, 214, 70, 68),
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
                          backgroundColor:
                              const Color.fromARGB(255, 214, 70, 68),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16.0,
                    ),
                    Text('Invite Friends and earn LOCA coins'),
                    Text(
                      'get 10 LOCA coins and 10% LOCA coins from each friend.',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 65, 63, 63),
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          border: Border.all(
                              color: const Color.fromARGB(255, 214, 70, 68),
                              width: 1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text(
                                'LOCA coins',
                                style: TextStyle(color: Colors.black),
                              ),
                              const Text(
                                '0.0000',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 214, 70, 68),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    fixedSize: Size(100, 20),
                                  ),
                                  onPressed: null,
                                  child: const Text(
                                    'Claim',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 214, 70, 68),
                        ),
                        onPressed: () async {
                          telegram.openTelegramLink(
                              'https://t.me/share/url?url={http://t.me/botLOCAbot/locaapp}');
                        },
                        child: const Text(
                          'Invite Friends',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
