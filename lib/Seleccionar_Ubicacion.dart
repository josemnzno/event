import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(18.13502989419433, -94.46088845700719),
    zoom: 14.0,
  );
  late TextEditingController _searchController;
  late String _searchAddress;
  LatLng? _selectedLocation; // Variable para almacenar la ubicación seleccionada

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchAddress = '';
    _selectedLocation = null; // Inicializar la ubicación seleccionada como nula
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Ubicación'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set.of(_createMarkers()),
            onTap: _selectLocation, // Método para manejar el tap en el mapa
          ),
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar dirección',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchAddress = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _searchAddress.isEmpty ? null : _searchLocation,
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20, // Cambia la posición del botón flotante a la izquierda
              child: FloatingActionButton(
                onPressed: _confirmLocation,
                child: Icon(Icons.check),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    // Implementa la lógica para obtener la ubicación actual del usuario y mover la cámara a esa ubicación
  }

  Future<void> _searchLocation() async {
    List<Location> locations = await locationFromAddress(_searchAddress);
    if (locations.isNotEmpty) {
      Location location = locations.first;
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        14.0,
      ));
      _searchController.clear(); // Limpiar el campo de búsqueda
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Dirección no encontrada'),
      ));
    }
  }

  Set<Marker> _createMarkers() {
    return _selectedLocation != null
        ? {
      Marker(
        markerId: MarkerId('selectedLocation'),
        position: _selectedLocation!,
        infoWindow: InfoWindow(title: 'Ubicación seleccionada'),
      ),
    }
        : {};
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedLocation = position; // Guardar la ubicación seleccionada
    });
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(
          context, _selectedLocation); // Pasar la ubicación seleccionada de regreso a la pantalla anterior
    }
  }
}
