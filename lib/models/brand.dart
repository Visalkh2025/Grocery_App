// class Brand {
//   final String id;
//   final String name;
//   final String image;
//   final String orginCountry;
//   final String description;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   Brand({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.orginCountry,
//     required this.description,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory Brand.fromJson(Map<String, dynamic> json) {
//     return Brand(
//       id: json['_id'],
//       name: json['name'],
//       image: json['image'],
//       orginCountry: json['origin_country'],
//       description: json['description'] ?? '',
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }
// }
class Brand {
  final String id;
  final String name;
  final String image;
  final String originCountry;
  final String description;

  Brand({
    required this.id,
    required this.name,
    required this.image,
    required this.originCountry,
    required this.description,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    // if (json == null) {
    //   return Brand(id: '', name: 'Unknown', image: '', originCountry: '', description: '');
    // }
    return Brand(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      originCountry: json['orginCountry'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
