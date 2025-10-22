import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_strings.dart';
import 'package:chef_bot/data/Repository/AppRepository.dart';
import 'package:chef_bot/data/recipeDTO.dart';
import 'package:flutter/material.dart';

class HttpScreen extends StatefulWidget {
  const HttpScreen({super.key});

  @override
  State<HttpScreen> createState() => _HttpScreenState();
}

class _HttpScreenState extends State<HttpScreen> {
  final AppRepository _repository = AppRepository();
  late Future<Recipe?> _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = _repository.getRandomMeal();

    _recipe.then((recipe) {
      if (recipe != null) {
        debugPrint('Nombre de la Receta: ${recipe.name}');
        debugPrint('Categoría: ${recipe.category}');
        debugPrint('URL de la Miniatura: ${recipe.thumbnailUrl}');
        debugPrint('Area: ${recipe.area}');
      } else {
        debugPrint('La receta es nula.');
      }
    });
  }

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
        title: const Text(
          'HTTP Requests 🌐',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: FutureBuilder<Recipe?>(
        future: _recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  AppStrings.httpError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            );
          }

          final recipe = snapshot.data;
          if (recipe == null) {
            return const Center(child: Text(AppStrings.httpError));
          }

          // Usamos ListView para desplazar y para que la imagen pueda ocupar el ancho completo.
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets
                .zero, // Importante: Elimina el padding por defecto del ListView.
            children: [
              // 🖼️ IMAGEN DE ANCHO COMPLETO
              recipe.thumbnailUrl != null
                  ? Image.network(
                      recipe.thumbnailUrl!,
                      // El ancho se expande automáticamente dentro del ListView,
                      // pero lo aseguramos con width: double.infinity
                      width: double.infinity,
                      height: 300, // Mantenemos la altura
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
              const SizedBox(height: 25),

              // 📝 CONTENIDO DE TEXTO (con Padding para los márgenes laterales)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  // Alineamos el texto a la izquierda para mejor lectura
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟣 Nombre de la receta
                    Text(
                      recipe.name ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 🔵 Categoría de la receta
                    Text(
                      recipe.category != null
                          ? 'Categoría: ${recipe.category}'
                          : 'Categoría no disponible',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black87,
                      ),
                    ),

                    // Puedes agregar más widgets aquí y se desplazarán
                    const SizedBox(
                      height: 500,
                    ), // Ejemplo para forzar el scroll
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
