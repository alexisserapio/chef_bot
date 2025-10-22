import 'package:chef_bot/data/recipeDTO.dart';

class Recipe {
  final String? name;
  final String? category;
  final String? area;
  final String? thumbnailUrl;

  Recipe({this.name, this.category, this.area, this.thumbnailUrl});

  // Constructor de fábrica para crear una instancia de Meal
  // a partir de un Map (la respuesta JSON decodificada).
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['strMeal'] as String?,
      category: json['strCategory'] as String?,
      area: json['strArea'] as String?,
      // Aquí mapeamos 'strMealThumb' a nuestra propiedad 'thumbnailUrl'
      thumbnailUrl: json['strMealThumb'] as String?,
    );
  }
}
