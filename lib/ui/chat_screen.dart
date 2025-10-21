import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_strings.dart';
import 'package:chef_bot/core/widget_message.dart';
import 'package:chef_bot/data/message_struct.dart';

import 'package:flutter/material.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Aquí es donde puedes declarar variables de estado (ej: TextEditingController, lista de mensajes, etc.)
  // Por ejemplo, para el campo de texto:
  final TextEditingController _textController = TextEditingController();

  late final GenerativeModel model;

  //Lista de mensajes que se mostraran en la UI
  final List<ChatMessage> _messages = [];

  // 🆕 Estado de carga para el indicador de respuesta del bot
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    // 🔑 Aquí inicializas el modelo, quizás cargando la clave de un .env
    // (Asegúrate que 'apiKey' sea una variable disponible aquí)
    model = GenerativeModel(
      model: 'gemini-2.5-flash',
      // Ejemplo: usando una variable de entorno para la seguridad
      //apiKey: const String.fromEnvironment('GEMINI_API_KEY')
      apiKey: apiKey,
    );

    _messages.add(
      ChatMessage(
        text:
            '👋 ¡Hola! Soy ChefBot 🍳. ¿Qué te apetece cocinar hoy? Puedo ayudarte con recetas rápidas y deliciosas',
        sender: MessageSender.bot,
      ),
    );
  }

  @override
  void dispose() {
    // Es importante liberar los recursos cuando el widget se destruye
    _textController.dispose();
    super.dispose();
  }

  List<Content> construirContenido(List<ChatMessage> mensajes) {
    List<Content> content = [];

    // Primero el rol de sistema
    content.add(
      Content.text(
        'Sistema: Eres ChefBot, da solo recetas un poco cortas o contesta sobre ingredientes.',
      ),
    );

    for (var msg in mensajes) {
      if (msg.sender == MessageSender.user) {
        content.add(Content.text('Usuario: ${msg.text}'));
      } else {
        content.add(Content.text(msg.text));
      }
    }

    return content;
  }

  // Método para manejar el envío de mensajes (simulado por ahora)
  void sendMessage() {
    final inputText = _textController.text;

    if (inputText.isNotEmpty && !_isGenerating) {
      // Lógica para procesar el mensaje, actualizar el estado, etc.
      debugPrint('Mensaje enviado: $inputText');
      setState(() {
        _messages.add(ChatMessage(text: inputText, sender: MessageSender.user));
        _isGenerating = true; // Empieza la carga
      });
      // Limpiar el campo de texto y reconstruir el widget (si fuera necesario)
      _textController.clear();
      // Si quieres que el UI se actualice después de enviar:
      // setState(() { /* actualizar variables de estado aquí */ })
      // Empieza la carga
      obtenerRespuesta(inputText);
    }
  }

  Future<void> obtenerRespuesta(String prompt) async {
    setState(() {
      _isGenerating = true;
    });

    final content = construirContenido(_messages);

    try {
      final response = await model.generateContent(content);
      setState(() {
        _messages.add(
          ChatMessage(text: response.text!, sender: MessageSender.bot),
        );
        _isGenerating = false;
      });
    } catch (e) {
      debugPrint('Ocurrió un error: $e');
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // Ejemplo de uso:
  // obtenerRespuesta('Escribe un poema corto sobre Flutter.');

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
          'ChefBot 🍳',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_add)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Aquí más adelante irá la lista de mensajes
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return MessageBubble(message: message);
                },
              ),
            ),

            if (_isGenerating)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  // ⬅️ Nuevo: Usamos Column para apilar el indicador y el texto
                  mainAxisSize: MainAxisSize
                      .min, // Para que el Column no ocupe todo el espacio vertical disponible
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Para alinear el contenido a la izquierda (o como prefieras)
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 14.0),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              AppStrings.pathToBotImg,
                            ),
                            backgroundColor: AppColors.imgBackground,
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.all(12.0),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.85,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.botMessages,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(15),
                              bottomLeft: const Radius.circular(15),
                              bottomRight: const Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            AppStrings.botThinking,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26),

                    LinearProgressIndicator(
                      color: AppColors.userMessages,
                      backgroundColor: AppColors.sendColor,
                    ), // El indicador que ya tenías
                  ],
                ),
              ),

            // Campo de texto inferior
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border: Border(
                  top: BorderSide(color: AppColors.sendColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  // Campo de texto
                  Expanded(
                    child: TextField(
                      controller: _textController, // Asignamos el controlador
                      onSubmitted: (_) =>
                          sendMessage(), // Enviamos al presionar Enter
                      decoration: InputDecoration(
                        hintText: AppStrings.textFieldHint,
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.sendColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: AppColors.sendColor,
                            width: 2.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botón redondeado
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.sendColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: sendMessage, // Llamamos al método de envío
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
