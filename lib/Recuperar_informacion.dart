import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Obtener una referencia a Firebase Authentication y Firestore
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Función para obtener los datos del usuario actual
Future<Map<String, dynamic>?> obtenerDatosUsuario() async {
  try {
    // Obtener el usuario actualmente autenticado
    User? user = _auth.currentUser;

    if (user != null) {
      // Obtener el UID del usuario
      String uid = user.uid;

      // Realizar una consulta en Firestore para obtener los datos del usuario
      DocumentSnapshot snapshot =
      await _firestore.collection('users').doc(uid).get();

      // Verificar si existe un documento para el usuario en la colección 'users'
      if (snapshot.exists) {
        // Obtener los datos del documento
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        print('No se encontraron datos para el usuario.');
        return null;
      }
    } else {
      print('Usuario no autenticado.');
      return null;
    }
  } catch (e) {
    print('Error al obtener datos del usuario: $e');
    return null;
  }
}
