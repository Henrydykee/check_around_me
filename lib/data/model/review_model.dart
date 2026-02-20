class ReviewModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? businessId;
  String? userId;
  int? rating;
  String? title;
  String? text;
  String? recommendation;
  int? likes;
  int? dislikes;
  String? parentReviewId;

  ReviewModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.businessId,
    this.userId,
    this.rating,
    this.title,
    this.text,
    this.recommendation,
    this.likes,
    this.dislikes,
    this.parentReviewId,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json[r'$id'];
    createdAt = json[r'$createdAt'];
    updatedAt = json[r'$updatedAt'];
    businessId = json['businessId'];
    userId = json['userId'];
    rating = json['rating'];
    title = json['title'];
    text = json['text'];
    recommendation = json['recommendation'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    parentReviewId = json['parentReviewId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[r'$id'] = id;
    data['businessId'] = businessId;
    data['userId'] = userId;
    data['rating'] = rating;
    data['title'] = title;
    data['text'] = text;
    data['recommendation'] = recommendation;
    data['parentReviewId'] = parentReviewId;
    return data;
  }
}

class ReviewsResponse {
  List<ReviewModel>? reviews;
  int? total;

  ReviewsResponse({this.reviews, this.total});

  ReviewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviews = (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    total = json['total'];
  }
}
