import 'package:chef_bot/core/app_colors.dart';
import 'package:chef_bot/core/app_strings.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
            const Expanded(child: SizedBox.expand()),

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
                      onPressed: () {
                        // Aquí se manejará el envío del texto
                      },
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
