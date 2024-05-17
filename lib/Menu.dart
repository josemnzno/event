import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/DetalleEvento.dart';
import 'package:intl/intl.dart'; // Importa la clase DateFormat
import 'Crear_Evento.dart'; // Importa la pantalla de detalles del evento

class EventosScreen extends StatefulWidget {
  const EventosScreen({Key? key}) : super(key: key);

  @override
  _EventosScreenState createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _eventos = []; // Lista para almacenar los eventos
  List<QueryDocumentSnapshot> _filteredEventos = []; // Lista filtrada de eventos
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _updateEventsList();
  }

  Future<void> _updateEventsList() async {
    List<QueryDocumentSnapshot> eventosDesdeFirestore = await obtenerEventosDesdeFirestore();
    setState(() {
      _eventos = eventosDesdeFirestore;
      _filteredEventos = List.from(_eventos);
    });
  }

  Future<List<QueryDocumentSnapshot>> obtenerEventosDesdeFirestore() async {
    List<QueryDocumentSnapshot> eventos = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Eventos').get();
      eventos = querySnapshot.docs;
    } catch (e) {
      print('Error al obtener eventos desde Firestore: $e');
    }
    return eventos;
  }

  void _filterEvents(String searchText) {
    setState(() {
      _filteredEventos = _eventos
          .where((event) => event['nombre'].toString().toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<void> _getUserDisplayName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _nombreUsuario = user.displayName ?? "";
      });
    }
  }

  void _showUserMenu(BuildContext context) {
    // Implementa el menú de usuario aquí
  }

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
                    SizedBox(height: 70),
                    Text(
                      'EventApp',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                hintText: 'Buscar evento',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                              onChanged: _filterEvents,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        // Espera a que se complete la creación del evento
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Crear_Evento(
                                usuario: FirebaseAuth.instance.currentUser),
                          ),
                        );

                        // Actualiza la lista de eventos después de crear un evento
                        _updateEventsList();
                      },
                      child: Image.asset(
                        'lib/pantallas/Crear_Evento.png',
                        width: 220,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Eventos',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredEventos.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> evento = _filteredEventos[index] as Map<String, dynamic>;
                          // Formatear la fecha utilizando DateFormat
                          var fechaInicio = DateFormat('dd/MM/yyyy').format(evento['fechaInicio'].toDate());

                          return Card(
                            color: Colors.greenAccent[100], // Color de fondo del rectángulo
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    evento['nombre'].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Color del texto
                                    ),
                                  ),
                                  Text(
                                    fechaInicio,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black, // Color del texto
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Navegar a la pantalla de detalles del evento y pasar el documento completo del evento
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalleEvento(evento: evento),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),


                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _nombreUsuario,
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () {
                    _showUserMenu(context);
                  },
                  icon: Icon(Icons.account_circle, size: 40),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
