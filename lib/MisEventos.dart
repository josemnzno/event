import 'package:event/MisEventosDetalles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EventosCreadosScreen extends StatefulWidget {
  @override
  _EventosCreadosScreenState createState() => _EventosCreadosScreenState();
}

class _EventosCreadosScreenState extends State<EventosCreadosScreen> {
  User? user;
  List<Map<String, dynamic>> eventos = [];

  @override
  void initState() {
    super.initState();
    _getEventosCreados();
  }

  Future<void> _getEventosCreados() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user!.uid;
      QuerySnapshot eventQuery = await FirebaseFirestore.instance
          .collection('Eventos')
          .where('usuarioId', isEqualTo: userId)
          .get();

      if (eventQuery.docs.isNotEmpty) {
        setState(() {
          eventos = eventQuery.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        });
      }
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

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
                  'Mis eventos creados',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: _buildEventosCreados(context),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {


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

  Widget _buildEventosCreados(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Eventos')
          .where('usuarioId', isEqualTo: user?.uid)
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
            return Center(child: Text('No has creado eventos'));
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              final fechaInicio = evento['fechaInicio'] as Timestamp;
              final formattedDate = _formatTimestamp(fechaInicio);

              return Card(
                color: Colors.greenAccent[100],
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento['nombre'],
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
                        builder: (context) => MisEventosDetalles(evento: evento)
                      ),
                    );
                  },
                ),
              );
            },
          );
        }
        return Center(child: Text('No has creado eventos'));
      },
    );
  }
}
