class Recipe {
  final String? name;
  final String? area;
  final String? instructions;
  final String? thumbnailUrl;

  Recipe({this.name, this.area, this.instructions, this.thumbnailUrl});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['strMeal'] as String?,
      area: json['strArea'] as String?,
      instructions: json['strInstructions'] as String?,
      thumbnailUrl: json['strMealThumb'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'area': area,
      'instructions': instructions,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
