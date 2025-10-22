import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_strings.dart';
import 'package:chef_bot/data/Repository/appRepository.dart';
import 'package:chef_bot/data/recipe_listDTO.dart';
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
    _recipes = Future.value(null);
  }

  void searchRecipe() {
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

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 10.0, left: 10.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: _textController, // Asignamos el controlador
              onSubmitted: (_) => searchRecipe(), // Enviamos al presionar Enter
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
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                var recipeList = snapshot.data?.result;
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: recipeList?.length ?? 0,
                    itemBuilder: (context, index) {
                      if (recipeList != null) {
                        return Text(recipeList[index].name!);
                      } else {
                        return Text('Error!');
                      }
                    },
                  ),
                );
              } else {
                return Text("No data");
              }
            },
          ),
        ],
      ),
    );
  }
}
