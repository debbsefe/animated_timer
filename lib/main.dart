import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_timer.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => CurrentNumberNotifier(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomTimer(),
    );
  }
}

///custom change notifier class to set selected number from timer and the animated values
class CurrentNumberNotifier with ChangeNotifier {
  double _selectedNumber = 20;
  double _animVal;
  double get selectedNumber => _selectedNumber;
  double get animVal => _animVal;

  void setNotifier({double number, double animeVal}) {
    _selectedNumber = number;
    _animVal = animeVal;
    notifyListeners();
  }
}
