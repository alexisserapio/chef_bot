import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:chef_bot/core/app_constants.dart';
import 'package:chef_bot/data/models/recipes/recipe_listDTO.dart';

class AppRepository {
  final Dio _dio;

  AppRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.BASE_URL,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          ) {
    // Agregamos un interceptor para ver los logs del request/response
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Obtiene recetas desde TheMealDB API
  Future<RecipeList?> fetchRecipes(String name) async {
    try {
      final response = await _dio.get(name);

      if (response.statusCode == 200) {
        debugPrint('✅ Respuesta 200 OK');
        final data = response.data;
        final recipes = RecipeList.fromJson(data);
        return recipes;
      } else {
        throw Exception(
          '❌ Fallo al cargar las recetas. Código: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
      throw Exception('Error de red al conectar con la API.');
    } catch (e) {
      debugPrint('⚠️ Error inesperado: $e');
      throw Exception('Error desconocido al cargar las recetas.');
    }
  }

  /// Envía datos JSON a un endpoint de prueba (como Pipedream)
  Future<void> sendData(Recipe recipe) async {
    try {
      final response = await _dio.post(
        AppConstants.BASE_MY_URL,
        data: recipe.toJson(),
      );

      debugPrint('✅ Datos enviados con éxito: ${response.statusCode}');
      debugPrint('📤 Respuesta: ${response.data}');
    } catch (e) {
      debugPrint('❌ Error al enviar los datos: $e');
      throw Exception('No se pudieron enviar los datos');
    }
  }

  /// Manejo centralizado de errores de Dio
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        debugPrint('⏱ Tiempo de conexión agotado');
        break;
      case DioExceptionType.receiveTimeout:
        debugPrint('📭 Tiempo de respuesta agotado');
        break;
      case DioExceptionType.badResponse:
        debugPrint('❌ Error del servidor: ${e.response?.statusCode}');
        debugPrint('🧾 Cuerpo: ${e.response?.data}');
        break;
      case DioExceptionType.connectionError:
        debugPrint('🚫 Error de conexión (sin red)');
        break;
      default:
        debugPrint('⚠️ Error general de Dio: ${e.message}');
    }
  }
}
