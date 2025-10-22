import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:chef_bot/data/repository/appRepository.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final AppRepository _repository = AppRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _repository.sendData(widget.recipe);
            debugPrint('Receta enviada a Pipedream');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Receta enviada con éxito 🚀')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error al enviar la receta ❌')),
            );
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.star, color: Colors.white),
      ),

      body: ListView(
        // ⭐ CAMBIO CLAVE: Usamos NeverScrollableScrollPhysics para deshabilitar el scroll.,
        padding: EdgeInsets
            .zero, // Importante: Elimina el padding por defecto del ListView.
        children: [
          // 🖼️ IMAGEN DE ANCHO COMPLETO
          widget.recipe.thumbnailUrl != null
              ? Image.network(
                  widget.recipe.thumbnailUrl!,
                  // El ancho se expande automáticamente dentro del ListView,
                  // pero lo aseguramos con width: double.infinity
                  width: double.infinity,
                  fit: BoxFit.cover, // Asegura que cubra el área
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 300, // Altura del placeholder
                      child: Center(
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
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Imagen no disponible')),
                ),

          // Agregamos un espaciador entre la imagen y el texto
          const SizedBox(height: 10),

          // 📝 CONTENIDO DE TEXTO (con Padding para los márgenes laterales)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              // Alineamos el texto a la izquierda para mejor lectura
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟣 Nombre de la receta
                Text(
                  widget.recipe.name ?? 'Nombre no disponible',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // 🔵 Pais
                Text(
                  widget.recipe.area != null
                      ? widget.recipe.area!
                      : 'Area no disponible',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.recipe.instructions != null
                      ? widget.recipe.instructions!
                      : 'Receta no disponible',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),

                // Puedes agregar más widgets aquí y se desplazarán
                const SizedBox(height: 500), // Ejemplo para forzar el scroll
              ],
            ),
          ),
        ],
      ),
    );
  }
}
