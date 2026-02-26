class MessageModel {
  String? id;
  String? conversationId;
  String? senderId;
  String? text;
  String? imageUrl;
  String? imageName;
  String? imageSize;
  bool? isRead;
  String? type;
  String? createdAt;

  MessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.text,
    this.imageUrl,
    this.imageName,
    this.imageSize,
    this.isRead,
    this.type,
    this.createdAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    conversationId = json['conversationId'];
    senderId = json['senderId'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    imageName = json['imageName'];
    imageSize = json['imageSize'];
    isRead = json['isRead'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['\$id'] = id;
    data['conversationId'] = conversationId;
    data['senderId'] = senderId;
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    data['imageName'] = imageName;
    data['imageSize'] = imageSize;
    data['isRead'] = isRead;
    data['type'] = type;
    data['createdAt'] = createdAt;
    return data;
  }
}
