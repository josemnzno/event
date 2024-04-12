import 'package:event/Seleccion.dart';
import 'package:event/Tipo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Crear_cuenta.dart';

class Inicio extends StatelessWidget {
  Inicio({Key? key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Función para iniciar sesión con correo electrónico y contraseña
  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Tipo()));
    } catch (e) {
      // Handle errors aquí
      print("Error: $e");
      // Mostrar mensaje de error o tomar otra acción según sea necesario
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error al iniciar sesión. Por favor, verifique sus credenciales.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/pantallas/fondo.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 250),
                Text(
                  'ACCEDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 75),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    String email = emailController.text;
                    String password = passwordController.text;
                    // Validar los campos antes de intentar iniciar sesión
                    if (email.isEmpty || password.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Por favor, ingrese su correo electrónico y contraseña.'),
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
                    } else {
                      // Iniciar sesión con el correo electrónico y contraseña ingresados
                      signInWithEmailAndPassword(context, email, password);
                    }
                  },
                  child: Image.asset(
                    'lib/pantallas/iniciar_sesion.png',
                    width: 200,
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  '¿No tienes una cuenta?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Crear_cuenta()),
                    );
                  },
                  child: Image.asset(
                    'lib/pantallas/Crear_cuenta.png',
                    width: 200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Inicio(),
  ));
}
