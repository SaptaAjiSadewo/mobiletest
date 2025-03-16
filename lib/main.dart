import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final int userId =
              settings.arguments as int; // Ambil userId dari arguments
          return MaterialPageRoute(
            builder: (context) =>
                MainPage(userId: userId), // ✅ Kirim userId ke MainPage
          );
        }
        return null;
      },
    );
  }
}
