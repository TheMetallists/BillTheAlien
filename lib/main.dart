import 'package:billthealien/elementform.dart';
import 'package:billthealien/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToiletpaperAdapter());
  Hive.registerAdapter(BillValueAdapter());
  Hive.registerAdapter(BillStateAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill, the Alien',
      theme: ThemeData(
        fontFamily: 'kellyslab',
        primarySwatch: Colors.cyan,
      ),
      routes: {
        '/': (context) => LoginForm(),
      },
    );
  }
}
