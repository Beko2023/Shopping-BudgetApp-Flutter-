import 'package:flutter/material.dart';
import 'package:shopping_cart/models/category.dart';

const categories = {
  Categories.clothing: Category(
    'Apparel',
    "👕",
    Color.fromARGB(255, 74, 189, 59),
  ),
  Categories.electronics: Category(
    'Electronics',
    "📱",
    Color.fromARGB(255, 175, 49, 49),
  ),
  Categories.outdoor: Category(
    'Outdoor',
    "🚴‍♀️",
    Color.fromARGB(255, 175, 165, 72),
  ),
  Categories.health: Category(
    'Health',
    "🩺",
    Color.fromARGB(255, 73, 161, 63),
  ),
  Categories.food: Category(
    'Food',
    "🍲",
    Color.fromARGB(255, 126, 60, 156),
  ),
  Categories.hobbies: Category(
    'Hobbies',
    "🕹️",
    Color.fromARGB(255, 53, 85, 46),
  ),
  Categories.services: Category(
    'Services',
    "🛎️",
    Color.fromARGB(255, 131, 45, 45),
  ),
  Categories.home: Category(
    'Home',
    "🏠",
    Color.fromARGB(255, 145, 158, 46),
  ),
  Categories.other: Category(
    'Others',
    "🛍️",
    Color.fromARGB(255, 58, 152, 165),
  ),
};
