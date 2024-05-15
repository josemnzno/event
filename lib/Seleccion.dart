import 'package:flutter/material.dart';
import 'Inicio.dart'; // Importa la pantalla a la que deseas navegar


class Seleccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLanguage = 'Español'; // Idioma seleccionado por defecto

  @override
  Widget build(BuildContext context) {
    return Container(
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
              'SELECCIONA\nLENGUAJE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 75),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedLanguage,
                icon: null, // Esto quitará el icono que aparece junto al menú desplegable
                dropdownColor: Colors.green, // Cambiar el color del cuadro desplegable
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    print('Idioma seleccionado: $newValue');
                    setState(() {
                      selectedLanguage = newValue;
                    });
                  }
                },
                items: <String>['Español', 'Inglés']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 25), // Tamaño de letra del botón
                    ),
                  );
                }).toList(),
              ),
            ),


            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inicio()),
                );
              },
              child: Image.asset(
                'lib/pantallas/Start.png', // Ruta de la imagen a utilizar
                width: 175, // Ancho de la imagen
                height: 175, // Alto de la imagen
              ),
            ),
          ],
        ),
      ),
    );
  }
}