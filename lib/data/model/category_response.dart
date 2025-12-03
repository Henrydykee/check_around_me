class CategoryResponse {
  String? id;
  String? name;
  String? description;
  String? imageUrl;

  CategoryResponse({this.id, this.name, this.description, this.imageUrl});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json[r'$id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[r'$id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
