import 'package:flutter/material.dart';

class Crear_Evento extends StatefulWidget {
  const Crear_Evento({Key? key}) : super(key: key);

  @override
  _Crear_EventoState createState() => _Crear_EventoState();
}

class _Crear_EventoState extends State<Crear_Evento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/pantallas/fondo2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 125),
                    Text(
                      'EventApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // Agrega aquí los demás widgets que desees mostrar en la pantalla
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
