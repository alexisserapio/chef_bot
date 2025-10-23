import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:chef_bot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:chef_bot/data/repository/appRepository.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final AppRepository _repository = AppRepository();

  //Generamos una bandera para revisar cuando la informacion se mande para evitar que el usuario vuelva a mandar antes de completar
  bool _isSending = false;

  //######## Método para MANDAR la receta a Pipedream RequestBin ################
  Future<void> _sendRecipe() async {
    //Actualizamos el valor de isSending a true mientras la funcion async esté en curso
    setState(() => _isSending = true);

    try {
      await _repository.sendData(widget.recipe);
      debugPrint('Receta enviada a Pipedream');

      //SnackBar para mostrar si el envío fue exitoso o erroneo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          //Si la respuesta no mandó excepciones, entonces el envío fue exitoso
          content: Text(
            AppLocalizations.of(context)!.snackBarSuccessful,
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: AppColors.sendColor,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        ),
      );

      //En caso de errores en el envío, se muestra con un snackbar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.snackBarError,
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: AppColors.saveColor,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        ),
      );

      //Si la respuesta fue exitosa o erronea, permitimos que pueda volver a enviarse
    } finally {
      setState(() => _isSending = false);
    }
  }

  //############ UI ################
  @override
  Widget build(BuildContext context) {
    //Scaffold
    return Scaffold(
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
        title: Text(
          widget.recipe.name!,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),

      //Boton de agregar a favoritos (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        onPressed: _isSending ? null : _sendRecipe,
        backgroundColor: _isSending ? AppColors.grey : AppColors.ambar,
        child: _isSending
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : const Icon(Icons.star, color: AppColors.white),
      ),

      body: ListView(
        padding: EdgeInsets.zero, //Elimina el padding por defecto del ListView.
        children: [
          //Imagen de la receta
          widget.recipe.thumbnailUrl != null
              ? Image.network(
                  widget.recipe.thumbnailUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 300, // Altura del placeholder
                      child: Center(
                        //CPI en lo que carga la imagen
                        child: CircularProgressIndicator(
                          color: AppColors.sendColor,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  // Agregamos un errorBuilder para manejar fallos de carga
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: AppColors.grey,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: AppColors.grey,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  height: 300,
                  color: AppColors.grey,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.noImage),
                  ),
                ),

          // Agregamos un espaciador entre la imagen y el texto
          const SizedBox(height: 10),

          //Elementos de texto de la Receta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              // Alineamos el texto a la izquierda para mejor lectura
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Nombre de la receta
                Text(
                  widget.recipe.name ?? AppLocalizations.of(context)!.noName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                const SizedBox(height: 8),

                //Pais de la receta
                Text(
                  widget.recipe.area != null
                      ? widget.recipe.area!
                      : AppLocalizations.of(context)!.noArea,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                //Receta
                Text(
                  widget.recipe.instructions != null
                      ? widget.recipe.instructions!
                      : AppLocalizations.of(context)!.noReceipe,
                  style: const TextStyle(fontSize: 20, color: AppColors.black),
                ),
                const SizedBox(height: 500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
