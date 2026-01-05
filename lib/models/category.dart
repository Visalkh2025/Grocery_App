// class Category {
//   final String id;
//   final String name;
//   final String image;
//   final bool? status;
//   final String description;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   Category({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.description,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       image: json['image'] ?? '',
//       description: json['description'] ?? '',
//       status: json['isActive'] ?? false,
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
// }
class Category {
  final String id;
  final String name;
  final String image;
  final String description;
  final bool status;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // if (json == null) {
    //   return Category(id: '', name: 'Unknown', image: '', description: '', status: false);
    // }
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] is bool
          ? json['status']
          : (json['status']?.toString().toLowerCase() == 'true'),
    );
  }
}
