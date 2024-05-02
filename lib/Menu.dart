import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/Crear_Evento.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Tipo extends StatefulWidget {
  const Tipo({Key? key}) : super(key: key);

  @override
  _TipoState createState() => _TipoState();
}
class _TipoState extends State<Tipo> {
  TextEditingController _searchController = TextEditingController();
  List<String> _events = []; // Lista dinámica para almacenar los eventos
  List<String> _filteredEvents = [];
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _getUserDisplayName();
    _updateEventsList(); // Obtener la lista de eventos al iniciar la aplicación
  }

  // Método para obtener la lista de eventos
  Future<void> _updateEventsList() async {
    List<String> eventosDesdeFirestore = await obtenerEventosDesdeFirestore();
    setState(() {
      _events = eventosDesdeFirestore;
      _filteredEvents = List.from(_events);
    });
  }

  Future<List<String>> obtenerEventosDesdeFirestore() async {
    List<String> eventos = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Eventos').get();
      querySnapshot.docs.forEach((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Convertir a Map<String, dynamic>
        if (data != null) {
          var nombre = data['nombre'] as String?; // Acceder a 'nombre' y convertir a String
          if (nombre != null) {
            eventos.add(nombre);
          }
        }
      });

    } catch (e) {
      print('Error al obtener eventos desde Firestore: $e');
    }
    return eventos;
  }


  void _filterEvents(String searchText) {
    setState(() {
      _filteredEvents = _events
          .where((event) =>
          event.toLowerCase().contains(searchText.toLowerCase()))
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
    // Implementación del menú de usuario
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
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
                            builder: (context) => Crear_Evento(usuario: FirebaseAuth.instance.currentUser),
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
                    SizedBox(height: 10), // Espacio entre el botón y la lista de eventos
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
                    // Espacio adicional entre el botón y el ListView
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredEvents.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(_filteredEvents[index]),
                              onTap: () {
                                // Acción al hacer clic en el evento
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
