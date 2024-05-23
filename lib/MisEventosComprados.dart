import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'DetalleEventoComprado.dart';
import 'EventoComprado.dart';
import 'Menu.dart'; // Importa la pantalla de detalles del evento

class MisEventosComprados extends StatelessWidget {
  final String userId;

  MisEventosComprados({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pantallas/fondo2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido de la pantalla
          Positioned(
            top: 150, // Ajusta la posición vertical
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Text(
                  'Mis eventos comprados',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: _buildEventosComprados(context),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventosScreen(),
                        ),
                            (route) => false, // Esto elimina todas las rutas anteriores
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      child: Text(
                        'Volver al menú principal',
                        style: TextStyle(fontSize: 20), // Tamaño de letra más grande
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent[100], // Color verde como los cuadros
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Ajusta este valor para cambiar la distancia desde el borde inferior
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventosComprados(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Boletos')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData) {
          final eventos = snapshot.data!.docs;
          if (eventos.isEmpty) {
            return Center(child: Text('No hay eventos comprados'));
          }

          Set<String> idsBoletos = Set<String>();

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              final idBoleto = evento['codigoBoleto'];
              final fechaInicio = evento['inicioEvento'] as Timestamp;

              if (idsBoletos.contains(idBoleto)) {
                return SizedBox.shrink();
              } else {
                idsBoletos.add(idBoleto);

                // Formatear la fecha en el formato deseado: día/mes/año
                final formattedDate = DateFormat('dd/MM/yyyy').format(fechaInicio.toDate());

                return Card(
                  color: Colors.greenAccent[100],
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento['nombreEvento'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Fecha: $formattedDate',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleEventoComprado(evento: evento),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
        }
        return Center(child: Text('No hay eventos comprados'));
      },
    );
  }
}
