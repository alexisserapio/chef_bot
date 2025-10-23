import 'package:chef_bot/core/app_constants.dart';
import 'package:chef_bot/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/data/models/messages/message_struct.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  String getProfileImageUrl(MessageSender sender) {
    return sender == MessageSender.user
        ? AppConstants.pathToUserImg
        : AppConstants.pathToBotImg;
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final bubbleColor = isUser ? AppColors.userMessages : AppColors.botMessages;
    final textColor = isUser ? Colors.black : Colors.black87;

    // Define el texto a mostrar arriba de la burbuja
    final senderName = isUser
        ? AppLocalizations.of(context)!.userDisplay
        : AppLocalizations.of(context)!.botDisplay;

    return Container(
      margin: const EdgeInsets.only(
        top: 16.0,
        bottom: 16.0, // antes 12.0
        left: 2.0,
        right: 2.0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Contenido de la burbuja: Nombre y Burbuja
          Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // NOMBRE DEL REMITENTE
              Padding(
                padding: isUser
                    ? const EdgeInsets.only(right: 50.0, bottom: 4.0)
                    : const EdgeInsets.only(left: 50.0, bottom: 4.0),
                child: Text(
                  senderName,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black54, // Color de texto para el nombre
                  ),
                ),
              ),

              // BURBUJA DE MENSAJE
              Container(
                margin: isUser
                    ? const EdgeInsets.only(right: 50, left: 8)
                    : const EdgeInsets.only(left: 50, right: 8),
                padding: const EdgeInsets.all(12.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.85,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isUser ? 15 : 0),
                    topRight: Radius.circular(isUser ? 0 : 15),
                    bottomLeft: const Radius.circular(15),
                    bottomRight: const Radius.circular(15),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
              ),
            ],
          ),

          // AVATAR
          Positioned(
            top: 5, // Ajustado para que quede a la altura del nombre
            right: isUser ? -8 : null,
            left: isUser ? null : -8,
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(getProfileImageUrl(message.sender)),
              backgroundColor: AppColors.imgBackground,
            ),
          ),
        ],
      ),
    );
  }
}
