import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  DateTime? lastResetEmailSent; // Variable para almacenar la fecha y hora del último correo enviado
  Timer? countdownTimer; // Temporizador para actualizar el contador regresivo
  int remainingTime = 0; // Tiempo restante en segundos

  @override
  void initState() {
    super.initState();
    loadRemainingTime(); // Carga el tiempo restante del temporizador al iniciar la página
  }

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancela el temporizador al salir de la pantalla
    super.dispose();
  }

  Future<void> resetPassword(BuildContext context) async {
    final now = DateTime.now();
    if (lastResetEmailSent != null &&
        now.difference(lastResetEmailSent!) < Duration(minutes: 2)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, espere $remainingTime segundos antes de enviar otro correo electrónico de restablecimiento de contraseña.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );
      setState(() {
        lastResetEmailSent = now;
        remainingTime = 120; // Establece el tiempo restante en 2 minutos
      });
      startTimer(); // Inicia el temporizador
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Éxito'),
            content: Text('Se ha enviado un correo electrónico para restablecer su contraseña.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/')); // Regresa a la pantalla principal
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al enviar el correo electrónico para restablecer la contraseña. Por favor, verifique su correo o inténtelo de nuevo más tarde.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        remainingTime--; // Actualiza el tiempo restante cada segundo
      });
      if (remainingTime == 0) {
        countdownTimer?.cancel(); // Cancela el temporizador cuando llega a cero
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('remainingTime', remainingTime); // Guarda el tiempo restante en SharedPreferences
    });
  }

  void loadRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTime = prefs.getInt('remainingTime') ?? 0;
    setState(() {
      remainingTime = savedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/pantallas/fondo.png'), // Ruta de la imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Text(
                'Recuperar \nContraseña',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => resetPassword(context),
                child: Text('Enviar Correo Electrónico de Restablecimiento'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              remainingTime > 0
                  ? Text(
                'Espere $remainingTime segundos antes de enviar otro correo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
