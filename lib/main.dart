import 'package:flutter/material.dart';
import 'package:record_application/features/player_audio/player_page.dart';
import 'package:record_application/features/record_audio/record_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false/**/,
      title: 'Flutter Demo',
      theme: ThemeData(),
      routes: {
       "record-page": (context) => RecordPage(),
        "player-page": (context)=>PlayerPage()
      },
      initialRoute: "player-page",
    );
  }
}

