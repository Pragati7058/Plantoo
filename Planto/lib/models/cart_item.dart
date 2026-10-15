class CartItem {
  final String id;
  final String plantId;
  final String plantName;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      plantId: json['plant']?['_id']?.toString() ?? json['plantId']?.toString() ?? '',
      plantName: json['plantName'] ?? json['plant']?['name'] ?? '',
      imageUrl: json['imageUrl'] ?? json['plant']?['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantId': plantId,
      'plantName': plantName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
