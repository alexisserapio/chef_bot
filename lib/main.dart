import 'package:flutter/material.dart';

void main() {
  runApp(const mainScreen());
}

class mainScreen extends StatelessWidget {
  const mainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Hola Mundo', home: recipeBook());
  }
}

class recipeBook extends StatelessWidget {
  const recipeBook({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 248, 226, 100),
        title: Text(
          'ChefBot 🍳',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
