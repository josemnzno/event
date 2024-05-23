import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Modificar cuenta.dart';

class CuentaScreen extends StatefulWidget {
  @override
  _CuentaScreenState createState() => _CuentaScreenState();
}

class _CuentaScreenState extends State<CuentaScreen> {
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: user!.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        setState(() {
          userData = userQuery.docs.first.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pantallas/fondo2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 150),
                    Text(
                      'Información de la Cuenta',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    user == null || userData == null
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildText('Nombres: ${userData!['Nombres'] ?? 'No disponible'}'),
                        _buildText('Apellidos: ${userData!['Apellidos'] ?? 'No disponible'}'),
                        _buildText('Teléfono: ${userData!['Telefono'] ?? 'No disponible'}'),
                        _buildText('Correo: ${user!.email ?? 'No disponible'}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModificarCuenta(),
                              ),
                            );
                          },
                          child: Text('Modificar Información', style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}
