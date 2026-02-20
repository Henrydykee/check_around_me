class CreateReviewPayload {
  final String businessId;
  final String userId;
  final int rating;
  final String? text;
  final String? title;
  final String? recommendation;
  final String? parentReviewId;

  CreateReviewPayload({
    required this.businessId,
    required this.userId,
    required this.rating,
    this.text,
    this.title,
    this.recommendation,
    this.parentReviewId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'businessId': businessId,
      'userId': userId,
      'rating': rating,
    };
    if (text != null) data['text'] = text;
    if (title != null) data['title'] = title;
    if (recommendation != null) data['recommendation'] = recommendation;
    if (parentReviewId != null) data['parentReviewId'] = parentReviewId;
    return data;
  }
}
