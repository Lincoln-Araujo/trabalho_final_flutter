import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
<<<<<<< HEAD
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
=======
>>>>>>> 280d65d32295feb1bb24340978a9d8a1218ebcd9
import 'screens/dogs_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
<<<<<<< HEAD
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    sqfliteFfiInit();
=======
    // Configure o banco de dados para o Flutter Web
>>>>>>> 280d65d32295feb1bb24340978a9d8a1218ebcd9
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const DogsListScreen(),
    );
  }
}
