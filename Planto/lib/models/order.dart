class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final Map<String, dynamic> shippingAddress;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['user']?['_id']?.toString() ?? json['userId']?.toString() ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      shippingAddress: json['shippingAddress'] ?? {},
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class OrderItem {
  final String plantId;
  final String plantName;
  final String imageUrl;
  final double price;
  final int quantity;

  OrderItem({
    required this.plantId,
    required this.plantName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      plantId: json['plant']?['_id']?.toString() ?? json['plantId']?.toString() ?? '',
      plantName: json['plantName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plantId': plantId,
      'plantName': plantName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  double get total => price * quantity;
}