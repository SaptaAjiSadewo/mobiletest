import 'package:flutter/material.dart';
import 'login_page.dart'; // Impor halaman login
import 'home_page.dart'; // Impor halaman beranda

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Halaman pertama yang ditampilkan
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}


