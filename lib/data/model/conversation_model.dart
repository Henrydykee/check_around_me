class ConversationModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  List<String>? participants;
  String? bookingId;
  String? lastMessageId;

  ConversationModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.participants,
    this.bookingId,
    this.lastMessageId,
  });

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    createdAt = json['\$createdAt'];
    updatedAt = json['\$updatedAt'];
    if (json['participants'] != null) {
      participants = (json['participants'] as List).cast<String>();
    }
    bookingId = json['bookingId'];
    lastMessageId = json['lastMessageId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['\$id'] = id;
    data['\$createdAt'] = createdAt;
    data['\$updatedAt'] = updatedAt;
    if (participants != null) data['participants'] = participants;
    data['bookingId'] = bookingId;
    data['lastMessageId'] = lastMessageId;
    return data;
  }
}
