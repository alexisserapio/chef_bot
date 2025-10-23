import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/data/repository/appRepository.dart';
import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:chef_bot/data/models/recipes/recipe_listDTO.dart';
import 'package:chef_bot/l10n/app_localizations.dart';
import 'package:chef_bot/ui/recipe_screen.dart';
import 'package:flutter/material.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  final AppRepository _repository = AppRepository();
  late Future<RecipeList?> _recipes;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Inicializamos la lista de recetas como nulo
    _recipes = Future.value(null);
  }

  //######## Método para BUSCAR la receta ingresada por el usuario ################
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

  //############ UI ################
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
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      //Body
      body: Column(
        children: [
          //TextField
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 10.0, left: 10.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _textController, // Asignamos el controlador
              onSubmitted: (_) =>
                  _searchRecipe(), // Enviamos al presionar Enter
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchFieldHint,
                prefixIcon: Icon(
                  Icons.search,
                ), //Se añade un icono para mejorar la experiencia
                suffixIcon: const Opacity(
                  //Este otro es para garantizar que el texto esté centrado
                  opacity: 0.0, // Lo hacemos invisible
                  child: Icon(Icons.search),
                ),
                hintStyle: TextStyle(color: AppColors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.orange, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.orange, width: 2.5),
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

          //Lista de Recetas
          FutureBuilder(
            future: _recipes,
            builder: (context, snapshot) {
              //Se maneja la respuesta obtenida de la API

              //En lo que recibimos la respuesta de la API
              if (snapshot.connectionState == ConnectionState.waiting) {
                //Colocamos un CircularProgressIndicator
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: CircularProgressIndicator(color: AppColors.sendColor),
                );

                //Si la respuesta no es exitosa
              } else if (snapshot.hasError) {
                debugPrint(
                  'Ha ocurrido un error en el snapshot: ${snapshot.error}',
                );
                return Text("Error: ${snapshot.error}");

                //Si la respuesta es exitosa
              } else if (snapshot.hasData) {
                var recipeList = snapshot.data?.result;

                //Si la respuesta es exitosa al conectarse a la API pero falla en encontrar una receta
                if (recipeList == null || recipeList.isEmpty) {
                  //Se muestra un mensaje de error y tips para volver a intentarlo
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          AppLocalizations.of(context)!.noRecipesFoundOne,
                          style: TextStyle(
                            color: AppColors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          AppLocalizations.of(context)!.noRecipesFoundTwo,
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

                //Si la respuesta es completamente exitosa
                return Expanded(
                  //Generamos la ListView
                  child: ListView.builder(
                    itemCount: recipeList.length,
                    itemBuilder: (context, index) {
                      return itemRecipe(recipeList[index]);
                    },
                  ),
                );

                //Instrucciones para realizar las peticiones HTTP
              } else {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.instructionsTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.firstInstructions,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        AppLocalizations.of(context)!.firstSubText,
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
                        AppLocalizations.of(context)!.secondInstructions,
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
                        AppLocalizations.of(context)!.secondSubText,
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
