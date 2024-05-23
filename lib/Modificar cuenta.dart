import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModificarCuenta extends StatefulWidget {
  @override
  _CuentaScreenState createState() => _CuentaScreenState();
}

class _CuentaScreenState extends State<ModificarCuenta> {
  User? user;
  Map<String, dynamic>? userData;
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();

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
          nombresController.text = userData!['Nombres'] ?? '';
          apellidosController.text = userData!['Apellidos'] ?? '';
          telefonoController.text = userData!['Telefono'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('User').doc(user!.uid).update({
        'Nombres': nombresController.text,
        'Apellidos': apellidosController.text,
        'Telefono': telefonoController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados con éxito')),
      );
    }
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController emailController = TextEditingController();
        return AlertDialog(
          title: Text('Cambiar Contraseña'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Correo Electrónico'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Se ha enviado un enlace de restablecimiento de contraseña a ${emailController.text}.'),
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error: ${e.toString()}'),
                  ));
                }
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
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
                    SizedBox(height: 70),
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
                        _buildTextField('Nombres', nombresController),
                        _buildTextField('Apellidos', apellidosController),
                        _buildTextField('Teléfono', telefonoController),
                        _buildText('Correo: ${user!.email ?? 'No disponible'}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updateUserData,
                          child: Text('Guardar Cambios', style: TextStyle(fontSize: 22)),
                        ),
                        ElevatedButton(
                          onPressed: _showChangePasswordDialog,
                          child: Text('Cambiar Contraseña', style: TextStyle(fontSize: 22)),
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        style: TextStyle(fontSize: 20),
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
