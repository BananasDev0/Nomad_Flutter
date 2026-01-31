import 'package:dio/dio.dart';

/// Cliente HTTP para comunicación con el backend
/// Usa Dio para manejar requests y responses
class ApiClient {
  final Dio _dio;
  
  ApiClient({String? baseUrl}) : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://tu-api.com/api', // Cambia esto por tu URL
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    // Interceptor para logging (útil en desarrollo)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    
    // Interceptor para autenticación (si lo necesitas)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Aquí puedes agregar el token de autenticación
        // final token = await getToken();
        // options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        // Manejo de errores global
        if (error.response?.statusCode == 401) {
          // Token expirado, redirigir a login
        }
        handler.next(error);
      },
    ));
  }
  
  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  /// Manejo de errores
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de espera agotado. Verifica tu conexión.');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Error del servidor';
        
        switch (statusCode) {
          case 400:
            return Exception('Solicitud inválida: $message');
          case 401:
            return Exception('No autorizado. Inicia sesión nuevamente.');
          case 403:
            return Exception('Acceso prohibido.');
          case 404:
            return Exception('Recurso no encontrado.');
          case 500:
            return Exception('Error interno del servidor.');
          default:
            return Exception('Error: $message');
        }
      
      case DioExceptionType.cancel:
        return Exception('Solicitud cancelada.');
      
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return Exception('Sin conexión a internet.');
        }
        return Exception('Error desconocido: ${error.message}');
      
      default:
        return Exception('Error: ${error.message}');
    }
  }
}