class ReviewModel {
  final String id;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String comment;
  final bool isVerifiedPurchase;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.isVerifiedPurchase,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] ?? {};
    return ReviewModel(
      id: json['_id'] ?? '',
      userName: user['username'] ?? 'Unknown',
      userAvatar: user['picture'],
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
