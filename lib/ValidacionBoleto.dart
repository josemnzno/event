import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScanScreen extends StatefulWidget {
  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null) {
        setState(() {
          result = scanData;
        });
        await _validarBoleto(scanData.code);
      }
    });
  }

  Future<void> _validarBoleto(String? codigoBoleto) async {
    if (codigoBoleto == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Boletos')
          .where('codigoBoleto', isEqualTo: codigoBoleto)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showDialog('Boleto inválido', 'Este boleto no es válido.');
      } else {
        _showDialog('Boleto válido', 'Este boleto es válido.');
      }
    } catch (e) {
      _showDialog('Error', 'Hubo un error al validar el boleto.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                result = null;
              });
              Navigator.of(context).pop();
              controller?.resumeCamera();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Escanear QR')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                'Código escaneado: ${result!.code}',
                style: TextStyle(fontSize: 20),
              )
                  : Text(
                'Escanea un código QR',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }
}
