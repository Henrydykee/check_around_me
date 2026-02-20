class NotificationModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? title;
  String? body;
  String? type;
  Map<String, dynamic>? data;
  bool? isRead;

  NotificationModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.title,
    this.body,
    this.type,
    this.data,
    this.isRead,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json[r'$id'];
    createdAt = json[r'$createdAt'];
    updatedAt = json[r'$updatedAt'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    data = json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null;
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[r'$id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['body'] = body;
    data['type'] = type;
    data['isRead'] = isRead;
    return data;
  }
}

class NotificationsResponse {
  List<NotificationModel>? notifications;
  int? total;

  NotificationsResponse({this.notifications, this.total});

  NotificationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    total = json['total'];
  }
}
