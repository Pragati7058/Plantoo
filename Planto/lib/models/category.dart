class Category {
  final String id;
  final String name;
  final String icon;
  final int plantCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.plantCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      plantCount: json['plantCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'plantCount': plantCount,
    };
  }
}
