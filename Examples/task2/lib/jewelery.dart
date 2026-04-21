import 'dart:async';
import 'dart:convert';

class Jewelery {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Jewelery({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Jewelery.fromJson(Map<String, dynamic> json) {
    return Jewelery(
        id: json['id'] as int,
        title: json['title'] as String,
        price: json['price'] as double,
        description: json['description'] as String,
        category: json['category'] as String,
        image: json['image'] as String,
        rating: Rating.fromJson(json['rating']));
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json['rate'],
        count: json['count'],
      );
}
