import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'CompraBoletosScreen.dart'; // Importa la pantalla de compra de boletos

// Modelo de datos para el evento
class Evento {
  final String nombre;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String horaInicio;
  final String horaFin;
  final double precioAdulto;
  final double precioNino;
  final double precioSenior;
  final int boletosDisponibles;
  final String imagenUrl;
  final GeoPoint ubicacion;

  Evento({
    required this.nombre,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicio,
    required this.horaFin,
    required this.precioAdulto,
    required this.precioNino,
    required this.precioSenior,
    required this.boletosDisponibles,
    required this.imagenUrl,
    required this.ubicacion,
  });
}

class DetalleEvento extends StatefulWidget {
  final QueryDocumentSnapshot evento;

  const DetalleEvento({Key? key, required this.evento}) : super(key: key);

  @override
  _DetalleEventoState createState() => _DetalleEventoState();
}

class _DetalleEventoState extends State<DetalleEvento> {
  late int cantidadAdultos;
  late int cantidadNinos;
  late int cantidadSeniors;
  late String imageUrl;
  late Evento evento; // Definir el parámetro evento

  @override
  void initState() {
    super.initState();
    cantidadAdultos = 0;
    cantidadNinos = 0;
    cantidadSeniors = 0;
    imageUrl = widget.evento['imagenUrl'];
    // Crear objeto Evento con la información del documento
    Map<String, dynamic> data = widget.evento.data() as Map<String, dynamic>;
    DateTime fechaInicio = data['fechaInicio'].toDate();
    DateTime fechaFin = data['fechaFin'].toDate();
    GeoPoint ubicacion = data['ubicacion'];

    evento = Evento(
      nombre: data['nombre'],
      descripcion: data['descripcion'],
      fechaInicio: fechaInicio,
      fechaFin: fechaFin,
      horaInicio: data['horaInicio'],
      horaFin: data['horaFin'],
      precioAdulto: data['precioAdulto'],
      precioNino: data['precioNino'],
      precioSenior: data['precioSenior'],
      boletosDisponibles: data['boletosDisponibles'],
      imagenUrl: data['imagenUrl'],
      ubicacion: data['ubicacion'],
    );
  }

  bool _haySuficientesBoletos() {
    int totalBoletosSeleccionados = cantidadAdultos + cantidadNinos + cantidadSeniors;
    return totalBoletosSeleccionados <= evento.boletosDisponibles;
  }

  bool _boletosSeleccionados() {
    return cantidadAdultos > 0 || cantidadNinos > 0 || cantidadSeniors > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/pantallas/fondo2.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 65),
                      Text(
                        'Informacion',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildText('Evento: ${evento.nombre}'),
                      _buildText('Descripción: ${evento.descripcion}'),
                      _buildText('Inicio: ${DateFormat('dd/MM/yyyy').format(evento.fechaInicio)} - ${evento.horaInicio}'),
                      _buildText('Fin: ${DateFormat('dd/MM/yyyy').format(evento.fechaFin)} - ${evento.horaFin} '),
                      _buildText('Precio Adulto: \$${evento.precioAdulto}'),
                      _buildText('Precio Niño: \$${evento.precioNino}'),
                      _buildText('Precio Senior: \$${evento.precioSenior}'),
                      _buildText('Boletos disponibles: ${evento.boletosDisponibles}'),
                      SizedBox(height: 10),
                      Text(
                        'Imagen de el evento',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Image.network(
                        imageUrl,
                        width: 350,
                        height: 300,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Text('Error al cargar la imagen');
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Ubicación del evento',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(evento.ubicacion.latitude, evento.ubicacion.longitude),
                            zoom: 15,
                          ),
                          markers: Set.of([
                            Marker(
                              markerId: MarkerId('eventoLocation'),
                              position: LatLng(evento.ubicacion.latitude, evento.ubicacion.longitude),
                              infoWindow: InfoWindow(title: 'Ubicación del evento'),
                            ),
                          ]),
                        ),
                      ),
                      _buildCantidadBoletos('Adultos', cantidadAdultos, (value) {
                        setState(() {
                          cantidadAdultos = int.parse(value);
                        });
                      }),
                      _buildCantidadBoletos('Niños', cantidadNinos, (value) {
                        setState(() {
                          cantidadNinos = int.parse(value);
                        });
                      }),
                      _buildCantidadBoletos('Seniors', cantidadSeniors, (value) {
                        setState(() {
                          cantidadSeniors = int.parse(value);
                        });
                      }),
                      _buildText('Total: \$${_calcularTotal().toStringAsFixed(2)}'),
                      ElevatedButton(
                        onPressed: _haySuficientesBoletos() && _boletosSeleccionados() ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleCompraScreen(
                                total: _calcularTotal(),
                                cantidadAdultos: cantidadAdultos,
                                cantidadNinos: cantidadNinos,
                                cantidadSeniors: cantidadSeniors,
                                evento: evento, // Pasar el objeto Evento
                                boletosDisponibles: evento.boletosDisponibles, // Pasar boletos disponibles
                              ),
                            ),
                          );
                        } : null,
                        child: Text('Comprar'),
                      ),
                      if (!_haySuficientesBoletos())
                        Text(
                          'No hay suficientes boletos disponibles',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      if (!_boletosSeleccionados())
                        Text(
                          'Debe seleccionar al menos un boleto para comprar',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCantidadBoletos(String label, int cantidad, void Function(String) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label + ': ',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(width: 10),
        SizedBox(
          width: 50,
          child: TextFormField(
            initialValue: cantidad.toString(),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        textAlign: TextAlign.center, // Alinea el texto al centro
      ),
    );
  }

  double _calcularTotal() {
    return (cantidadAdultos * evento.precioAdulto) + (cantidadNinos * evento.precioNino) + (cantidadSeniors * evento.precioSenior);
  }
}
