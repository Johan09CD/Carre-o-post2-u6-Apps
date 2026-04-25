// lib/network/api_client.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'token_interceptor.dart';

class ApiClient {
  static Dio? _instance;

  static Future<Dio> getInstance() async {
    if (_instance != null) return _instance!;
    _instance = await _crearDioSeguro();
    return _instance!;
  }

  static Future<Dio> _crearDioSeguro() async {
    // Cargar certificado desde assets del proyecto
    final certData = await rootBundle.load('assets/certs/server_cert.pem');
    final certBytes = certData.buffer.asUint8List();

    // Crear SecurityContext con SOLO nuestro certificado como confiable
    final secCtx = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certBytes);

    // Crear HttpClient que usa nuestro SecurityContext
    final httpClient = HttpClient(context: secCtx)
      ..connectionTimeout = const Duration(seconds: 10);

    // Configurar adaptador Dio para usar nuestro HttpClient
    final adapter = IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    );

    final dio = Dio(
      BaseOptions(
          baseUrl: 'https://10.0.2.2:8443',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..httpClientAdapter = adapter;

    // Agregar TokenInterceptor para manejo de autenticación
    dio.interceptors.add(TokenInterceptor());

    // Interceptor para logging (solo en debug)
    assert(() {
      dio.interceptors.add(LogInterceptor(responseBody: false));
      return true;
    }());

    return dio;
  }
}