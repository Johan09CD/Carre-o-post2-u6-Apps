// lib/network/security_error_handler.dart
import 'dart:io';
import 'package:dio/dio.dart';

class SecurityErrorHandler {
  static String interpretar(dynamic error) {
    if (error is DioException) {
      if (error.error is HandshakeException) {
        return "Conexión rechazada: el certificado del servidor no es confiable. "
            "Por favor, contacte al soporte técnico.";
      }
      if (error.type == DioExceptionType.connectionTimeout) {
        return "El servidor no responde. Verifique su conexión a internet.";
      }
      if (error.type == DioExceptionType.receiveTimeout) {
        return "La respuesta del servidor tardó demasiado. Intente de nuevo.";
      }
      if (error.response?.statusCode == 401) {
        return "Sesión expirada. Por favor inicie sesión nuevamente.";
      }
    }
    return "Error de conexión. Intente de nuevo más tarde.";
  }

  static bool esFalloCertificado(dynamic error) {
    return error is DioException && error.error is HandshakeException;
  }
}