import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:chef_bot/core/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:chef_bot/data/model/recipe_listDTO.dart'; // Ajusta la ruta a tu DTO (modelo)

class AppRepository {
  // Método público que la UI u otras capas de negocio usarán
  Future<RecipeList?> fetchRecipes(String name) async {
    final url = Uri.parse(AppConstants.BASE_URL + name);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint('Respuesta recibida 200 OK');
        // Decodificación del JSON
        final data = json.decode(response.body);

        // La API de TheMealDB devuelve la respuesta envuelta en un array 'meals'
        RecipeList recipes = RecipeList.fromJson(data);
        return recipes;
      } else {
        // Manejo de errores HTTP (404, 500, etc.)
        // Puedes lanzar una excepción personalizada aquí si lo deseas
        throw Exception(
          'Fallo al cargar las recetas. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Manejo de errores de conexión o de parsing
      // Es crucial capturar y manejar el error
      debugPrint('Error al cargar las recetas: $e');
      // Puedes lanzar una excepción para que la UI sepa que algo falló
      throw Exception('Error de red al conectar con la API.');
    }
  }
}
