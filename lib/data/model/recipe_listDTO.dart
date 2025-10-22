import 'package:chef_bot/data/model/recipeDTO.dart';

class RecipeList {
  final List<Recipe>? result;

  RecipeList({this.result});

  // Constructor de fábrica para crear una instancia de Meal
  // a partir de un Map (la respuesta JSON decodificada).
  factory RecipeList.fromJson(Map<String, dynamic> json) {
    var list = json["meals"] as List?;

    List<Recipe>? recipeList = list
        ?.map((recipe) => Recipe.fromJson(recipe))
        .toList();

    return RecipeList(result: recipeList);
  }
}
