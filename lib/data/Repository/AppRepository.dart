import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chef_bot/core/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:chef_bot/data/recipeDTO.dart'; // Ajusta la ruta a tu DTO (modelo)

class AppRepository {
  // Método público que la UI u otras capas de negocio usarán
  Future<Recipe?> getRandomMeal() async {
    final url = Uri.parse(AppConstants.BASE_URL);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decodificación del JSON
        final data = json.decode(response.body);

        // La API de TheMealDB devuelve la respuesta envuelta en un array 'meals'
        final meals = data['meals'] as List<dynamic>?;

        if (meals != null && meals.isNotEmpty) {
          // Mapeo del JSON al DTO (la clase modelo Meal)
          return Recipe.fromJson(meals.first as Map<String, dynamic>);
        } else {
          // Caso en que la respuesta es 200 pero 'meals' está vacío
          return null;
        }
      } else {
        // Manejo de errores HTTP (404, 500, etc.)
        // Puedes lanzar una excepción personalizada aquí si lo deseas
        throw Exception(
          'Fallo al cargar el plato. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Manejo de errores de conexión o de parsing
      // Es crucial capturar y manejar el error
      debugPrint('Error al obtener datos del plato: $e');
      // Puedes lanzar una excepción para que la UI sepa que algo falló
      throw Exception('Error de red al conectar con la API.');
    }
  }
}
