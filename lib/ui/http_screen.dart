import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_strings.dart';
import 'package:chef_bot/data/repository/appRepository.dart';
import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:chef_bot/data/models/recipes/recipe_listDTO.dart';
import 'package:chef_bot/ui/recipe_screen.dart';
import 'package:flutter/material.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  final appRepository _repository = appRepository();
  late Future<RecipeList?> _recipes;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipes = Future.value(null);
  }

  void _searchRecipe() {
    final inputText = _textController.text;

    if (inputText.isNotEmpty) {
      // Lógica para procesar el mensaje, actualizar el estado, etc.
      debugPrint('Receta buscada: $inputText');

      setState(() {
        _recipes = _repository.fetchRecipes(inputText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold
      backgroundColor: AppColors.backgroundColor,

      //AppBar
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.navigate_before_sharp),
        ),
        elevation: 5,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.grey.withOpacity(0.3),
        titleSpacing: 0,
        title: const Text(
          'HTTP Requests 🌐',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      //Body
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 10.0, left: 10.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _textController, // Asignamos el controlador
              onSubmitted: (_) =>
                  _searchRecipe(), // Enviamos al presionar Enter
              decoration: InputDecoration(
                hintText: AppStrings.searchFieldHint,
                prefixIcon: Icon(Icons.search),
                suffixIcon: const Opacity(
                  opacity: 0.0, // Lo hacemos invisible
                  child: Icon(
                    Icons.search,
                  ), // Usamos el mismo icono para asegurar el tamaño
                ),
                hintStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.orange, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.orange, width: 2.5),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

          FutureBuilder(
            future: _recipes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: CircularProgressIndicator(color: AppColors.sendColor),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                var recipeList = snapshot.data?.result;
                if (recipeList == null || recipeList.isEmpty) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          AppStrings.noRecipesFoundOne,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          AppStrings.noRecipesFoundTwo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: recipeList.length,
                    itemBuilder: (context, index) {
                      return itemRecipe(recipeList[index]);
                    },
                  ),
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        AppStrings.instructionsTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        AppStrings.firstInstructions,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        AppStrings.firstSubText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Text(
                        AppStrings.secondInstructions,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 3.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Text(
                        AppStrings.secondSubText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Padding itemRecipe(Recipe recipe) => Padding(
    padding: const EdgeInsets.only(
      top: 10.0,
      bottom: 8.0,
      left: 15.0,
      right: 15.0,
    ),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RecipeScreen(recipe: recipe)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.sendColor,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                recipe.thumbnailUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                recipe.name!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
