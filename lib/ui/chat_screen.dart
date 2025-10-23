import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_constants.dart';
import 'package:chef_bot/core/widget_message.dart';
import 'package:chef_bot/data/models/messages/message_struct.dart';
import 'package:chef_bot/data/repository/appRepository.dart';
import 'package:chef_bot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _textController;
  late final ChatRepository _chatRepository;

  //Lista de mensajes que se mostraran en la UI
  final List<ChatMessage> _messages = [];

  //Estado de carga para el indicador de respuesta del bot
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();

    //Inicializar el TextEditingController
    _textController = TextEditingController();

    //Se obtiene la apiKey desde tokens.env
    final apiKey =
        dotenv.maybeGet('apiKey') ??
        const String.fromEnvironment('API_KEY', defaultValue: '');

    _chatRepository = ChatRepository(apiKey: apiKey);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadMessagesUI();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  //######## Método para manejar en UI el ENVIO de mensajes ################
  void sendMessageUI() {
    final inputText = _textController.text;

    if (inputText.isNotEmpty && !_isGenerating) {
      // Lógica para procesar el mensaje, actualizar el estado, etc.
      debugPrint('Mensaje enviado: $inputText');
      setState(() {
        _messages.add(ChatMessage(text: inputText, sender: MessageSender.user));
        _isGenerating = true;
      });

      // Limpiar el campo de texto y reconstruir el widget (si fuera necesario)
      _textController.clear();

      //Se guardan los mensajes
      _chatRepository.saveMessages(_messages);

      //Se manda a recibir la resuesta
      obtenerRespuestaUI(inputText);
    }
  }

  //######## Método para manejar en UI el RECIBIR mensajes ################
  Future<void> obtenerRespuestaUI(String prompt) async {
    setState(() {
      _isGenerating = true;
    });

    final content = _chatRepository.construirContenido(_messages);

    try {
      // Comprobar conexión
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResult != ConnectivityResult.none;

      if (!hasConnection) {
        //  Mostrar SnackBar si no hay internet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.networkChatError),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        setState(() {
          _isGenerating = false;
        });
        return; // Detener ejecución
      }

      // Si hay conexión, continuar con la petición
      final response = await _chatRepository.model.generateContent(content);

      setState(() {
        _messages.add(
          ChatMessage(text: response.text!, sender: MessageSender.bot),
        );
        _isGenerating = false;
      });

      _chatRepository.saveMessages(_messages);
    } catch (e) {
      debugPrint('Ocurrió un error: $e');
      setState(() {
        _isGenerating = false;
      });

      // Mostrar error general
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.generalChatError),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  //######## Método para CARGAR en UI los mensajes si hay historial ################
  Future<void> loadMessagesUI() async {
    final mensajes = await _chatRepository.loadMessages();

    setState(() {
      _messages.clear();
      if (mensajes.isNotEmpty) {
        _messages.addAll(mensajes);
        debugPrint('Se ha restaurado el chat desde almacenamiento local');
      } else {
        // Mensaje de bienvenida si no hay historial
        _messages.add(
          ChatMessage(
            text:
                '👋 ¡Hola! Soy ChefBot 🍳. ¿Qué te apetece cocinar hoy? Puedo ayudarte con recetas rápidas y deliciosas',
            sender: MessageSender.bot,
          ),
        );
      }
    });
  }

  //######## Método para manejar en UI el borrado de mensajes ################
  Future<void> deleteHistoryUI() async {
    _chatRepository.deleteHistory();

    setState(() => _messages.clear());
    debugPrint('Historial eliminado');

    //Se vuelve a mandar el mensaje de bienvenida para evitar que el chat se encuentre vacío y que la AI genere procesamiento adicional
    setState(() {
      _messages.add(
        ChatMessage(
          text:
              '👋 ¡Hola! Soy ChefBot 🍳. ¿Qué te apetece cocinar hoy? Puedo ayudarte con recetas rápidas y deliciosas',
          sender: MessageSender.bot,
        ),
      );
    });
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
        title: const Text(
          'ChefBot 🍳',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: deleteHistoryUI,
            icon: const Icon(Icons.delete_forever, color: AppColors.red),
          ),
        ],
      ),

      //Body
      body: SafeArea(
        child: Column(
          //ListView
          children: [
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

            //UI para manejar los tiempos de respuesta de la AI
            if (_isGenerating)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Para que el Column no ocupe todo el espacio vertical disponible
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 14.0),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              //Se pasa la ruta al archivo imagen para el bot
                              AppConstants.pathToBotImg,
                            ),
                            backgroundColor: AppColors.imgBackground,
                          ),
                        ),

                        //Mensaje de "Escribiendo" cuando se esté procesando la respuesta
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
                            AppLocalizations.of(context)!.botThinking,
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26),

                    //Se añade tambien un LinearProgressIndicator para "visualizar" la carga
                    LinearProgressIndicator(
                      color: AppColors.userMessages,
                      backgroundColor: AppColors.sendColor,
                    ), // El indicador que ya tenías
                  ],
                ),
              ),

            //EditText para ingresar el texto en el chat
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
                  Expanded(
                    child: TextField(
                      controller: _textController, // Asignamos el controlador
                      onSubmitted: (_) =>
                          sendMessageUI(), // Enviamos al presionar el botón
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.textFieldHint,
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

                  // Botón redondeado de enviar
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.sendColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: sendMessageUI, // Llamamos al método de envío
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
