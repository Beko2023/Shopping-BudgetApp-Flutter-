import 'package:flutter/material.dart';

enum Categories {
  clothing,
  electronics,
  outdoor,
  health,
  food,
  hobbies,
  services,
  home,
  other,
}

class Category {
  const Category(this.title, this.emojis, this.color);

  final String title;
  final String emojis;
  final Color color;

  @override
  String toString() {
    return '$emojis $title (Color: $color)';
  }
}
