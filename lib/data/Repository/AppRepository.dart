import 'dart:convert';
import 'package:chef_bot/core/app_constants.dart';
import 'package:chef_bot/data/models/messages/message_struct.dart';
import 'package:chef_bot/data/models/recipes/recipeDTO.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:chef_bot/data/models/recipes/recipe_listDTO.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  final Dio _dio;

  final String requestBinUrl =
      dotenv.maybeGet('requestBinUrl') ??
      const String.fromEnvironment('RQB_URL', defaultValue: '');

  AppRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.apiMealUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          ) {
    // Agregamos un interceptor para ver los logs del request/response
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Obtiene recetas desde TheMealDB API
  Future<RecipeList?> fetchRecipes(String name) async {
    try {
      final response = await _dio.get(name);

      if (response.statusCode == 200) {
        debugPrint('✅ Respuesta 200 OK');
        final data = response.data;
        final recipes = RecipeList.fromJson(data);
        if (recipes.result == null) {
          debugPrint('🔍 No se encontraron resultados (meals: null)');
          // Si no hay resultados, puedes devolver null para que el UI
          // lo interprete como "No hay resultados".
          return RecipeList(result: []);
        }
        return recipes;
      } else {
        throw Exception(
          '❌ Fallo al cargar las recetas. Código: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
      throw Exception('Error de red al conectar con la API.');
    } catch (e) {
      debugPrint('⚠️ Error inesperado: $e');
      throw Exception('Error desconocido al cargar las recetas.');
    }
  }

  /// Envía datos JSON a un endpoint de prueba (como Pipedream)
  Future<void> sendData(Recipe recipe) async {
    final dioTemp = Dio();

    try {
      final response_rqb = await dioTemp.post(
        requestBinUrl,
        data: recipe.toJson(),
      );

      debugPrint('✅ Datos enviados con éxito: ${response_rqb.statusCode}');
      debugPrint('📤 Respuesta: ${response_rqb.data}');
    } catch (e) {
      debugPrint('❌ Error al enviar los datos: $e');
      throw Exception('No se pudieron enviar los datos');
    }
  }

  /// Manejo centralizado de errores de Dio
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        debugPrint('⏱ Tiempo de conexión agotado');
        break;
      case DioExceptionType.receiveTimeout:
        debugPrint('📭 Tiempo de respuesta agotado');
        break;
      case DioExceptionType.badResponse:
        debugPrint('❌ Error del servidor: ${e.response?.statusCode}');
        debugPrint('🧾 Cuerpo: ${e.response?.data}');
        break;
      case DioExceptionType.connectionError:
        debugPrint('🚫 Error de conexión (sin red)');
        break;
      default:
        debugPrint('⚠️ Error general de Dio: ${e.message}');
    }
  }
}

class ChatRepository {
  final GenerativeModel model;

  ChatRepository({required String apiKey})
    : model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<void> saveMessages(List<ChatMessage> _messages) async {
    final prefs = await SharedPreferences.getInstance();

    // Convertir lista de mensajes a JSON
    final mensajesJson = _messages.map((msg) {
      return {
        'text': msg.text,
        'sender': msg.sender == MessageSender.user ? 'user' : 'bot',
      };
    }).toList();

    await prefs.setString('chat_history', jsonEncode(mensajesJson));
    debugPrint('💾 Chat guardado correctamente');
  }

  //Cargar Mensajes
  Future<List<ChatMessage>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_history');
    if (data == null) return [];

    final List<dynamic> mensajesJson = jsonDecode(data);
    return mensajesJson
        .map(
          (item) => ChatMessage(
            text: item['text'],
            sender: item['sender'] == 'user'
                ? MessageSender.user
                : MessageSender.bot,
          ),
        )
        .toList();
  }

  //Borrar Historial
  Future<void> deleteHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
  }

  List<Content> construirContenido(List<ChatMessage> mensajes) {
    List<Content> content = [];
    content.add(
      Content.text(
        'Sistema: Eres ChefBot, da respuestas de longitud mediana o cortas sobre recetas...',
      ),
    );

    for (var msg in mensajes) {
      content.add(
        Content.text(
          '${msg.sender == MessageSender.user ? "Usuario" : "Bot"}: ${msg.text}',
        ),
      );
    }
    return content;
  }

  Future<String?> obtenerRespuesta(List<ChatMessage> mensajes) async {
    final content = construirContenido(mensajes);
    final response = await model.generateContent(content);
    return response.text;
  }
}
