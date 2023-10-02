import 'package:flutter/material.dart';
import 'package:flutter_application_1/page1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Material(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Custompage(),
    );
  }
}
