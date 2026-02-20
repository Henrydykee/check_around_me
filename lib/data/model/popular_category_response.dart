class PopularCategoryResponse {
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  int? businessCount;

  PopularCategoryResponse({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.businessCount,
  });

  PopularCategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json[r'$id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    businessCount = json['businessCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[r'$id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['businessCount'] = businessCount;
    return data;
  }
}
