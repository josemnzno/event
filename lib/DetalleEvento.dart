import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/Gastos_Evento.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class DetalleEvento extends StatelessWidget {
  final Map<String, dynamic> evento;
  const DetalleEvento({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Extraer las coordenadas de ubicación
    GeoPoint ubicacion = evento['ubicacion'];

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width, // Establecer el ancho igual al ancho del dispositivo
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/pantallas/fondo2.png'),
            fit: BoxFit.fill, // Cambiado a BoxFit.fill
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height:65),
                    Text(
                      'Informacion',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildText('Evento: ${evento['nombre']}'),
                    _buildText('Descripción: ${evento['descripcion']}'),
                    _buildText('Inicio: ${dateFormat.format(evento['fechaInicio'].toDate())} - ${evento['horaInicio']}'),
                    _buildText('Fin: ${dateFormat.format(evento['fechaFin'].toDate())} - ${evento['horaFin']}'),
                    _buildText('Precio Adulto: \$${evento['precioAdulto']}'),
                    _buildText('Precio Niño: \$${evento['precioNino']}'),
                    _buildText('Precio Senior: \$${evento['precioSenior']}'),
                    // Mostrar las coordenadas de ubicación como texto
                    SizedBox(height: 10),
                    Text(
                      'Ubicacion de el evento',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // Widget para mostrar el mapa con la ubicación del evento
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(ubicacion.latitude, ubicacion.longitude),
                          zoom: 15,
                        ),
                        markers: Set.of([
                          Marker(
                            markerId: MarkerId('eventoLocation'),
                            position: LatLng(ubicacion.latitude, ubicacion.longitude),
                            infoWindow: InfoWindow(title: 'Ubicación del evento'),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the first window
                      },
                      child: Text('Modificar Evento'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gastos_Evento(),
                          ),
                        );
                      },
                      child: Text('Ver estadísticas'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}
