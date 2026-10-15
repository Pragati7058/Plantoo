class WishlistItem {
  final String id;
  final String plantId;
  final String plantName;
  final String imageUrl;
  final double price;
  final DateTime createdAt;

  WishlistItem({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      plantId: json['plant']?['_id']?.toString() ?? json['plantId']?.toString() ?? '',
      plantName: json['plantName'] ?? json['plant']?['name'] ?? '',
      imageUrl: json['imageUrl'] ?? json['plant']?['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'plantName': plantName,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}