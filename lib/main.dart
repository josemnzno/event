import 'package:event/Seleccion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "eventapp",
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => Seleccion(), // Asigna la pantalla de inicio a la ruta inicial
        // Puedes agregar más rutas aquí si es necesario
      },
    );
  }
}
