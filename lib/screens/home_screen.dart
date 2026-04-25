// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../network/security_error_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _estadoConexion = 'Sin intentos de conexión';
  bool _cargando = false;

  Future<void> _probarConexion() async {
    setState(() {
      _cargando = true;
      _estadoConexion = 'Intentando conectar...';
    });

    try {
      final dio = await ApiClient.getInstance();
      await dio.get('/api/health');
      setState(() {
        _estadoConexion = 'Conexión exitosa ✓';
      });
    } catch (e) {
      final mensaje = SecurityErrorHandler.interpretar(e);
      setState(() {
        _estadoConexion = mensaje;
      });

      debugPrint("Error tipo: ${e.runtimeType}");
      if (e is DioException) debugPrint("Causa: ${e.error}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banca Segura'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.security,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Cliente HTTP Seguro\nCertificate Pinning',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _estadoConexion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _cargando ? null : _probarConexion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _cargando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Probar conexión', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}