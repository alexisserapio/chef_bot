class Recipe {
  final String? name;
  final String? area;
  final String? instructions;
  final String? thumbnailUrl;

  Recipe({this.name, this.area, this.instructions, this.thumbnailUrl});

  // Constructor de fábrica para crear una instancia de Meal
  // a partir de un Map (la respuesta JSON decodificada).
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['strMeal'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
      // Aquí mapeamos 'strMealThumb' a nuestra propiedad 'thumbnailUrl'
      thumbnailUrl: json['strMealThumb'] as String?,
    );
  }
}
