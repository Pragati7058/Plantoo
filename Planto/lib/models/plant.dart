class Plant {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String description;
  final CareInfo careInfo;
  final bool isPetFriendly;
  final bool isInStock;

  Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.careInfo,
    this.isPetFriendly = false,
    this.isInStock = true,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      description: json['description'] ?? '',
      careInfo: CareInfo.fromJson(json['careInfo'] ?? {}),
      isPetFriendly: json['isPetFriendly'] ?? false,
      isInStock: json['isInStock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'careInfo': careInfo.toJson(),
      'isPetFriendly': isPetFriendly,
      'isInStock': isInStock,
    };
  }
}

class CareInfo {
  final String water;
  final String light;
  final String humidity;
  final String temperature;

  CareInfo({
    required this.water,
    required this.light,
    required this.humidity,
    required this.temperature,
  });

  factory CareInfo.fromJson(Map<String, dynamic> json) {
    return CareInfo(
      water: json['water'] ?? '',
      light: json['light'] ?? '',
      humidity: json['humidity'] ?? '',
      temperature: json['temperature'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'water': water,
      'light': light,
      'humidity': humidity,
      'temperature': temperature,
    };
  }
}
