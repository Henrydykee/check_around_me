class BusinessModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? userId;
  String? businessId;
  String? type;
  String? serviceName;
  String? message;
  int? amount;
  int? fee;
  String? currency;
  String? status;
  bool? chatEnabled;
  String? acceptedAt;
  String? expiresAt;
  String? scheduledAt;
  String? completedAt;
  String? disputedAt;
  String? cancelledAt;
  String? disputedBy;
  String? disputedReason;
  String? cancelledBy;
  String? cancellationReason;

  BusinessModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.businessId,
        this.type,
        this.serviceName,
        this.message,
        this.amount,
        this.fee,
        this.currency,
        this.status,
        this.chatEnabled,
        this.acceptedAt,
        this.expiresAt,
        this.scheduledAt,
        this.completedAt,
        this.disputedAt,
        this.cancelledAt,
        this.disputedBy,
        this.disputedReason,
        this.cancelledBy,
        this.cancellationReason});

  BusinessModel.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    createdAt = json['$createdAt'];
    updatedAt = json['$updatedAt'];
    userId = json['userId'];
    businessId = json['businessId'];
    type = json['type'];
    serviceName = json['serviceName'];
    message = json['message'];
    amount = json['amount'];
    fee = json['fee'];
    currency = json['currency'];
    status = json['status'];
    chatEnabled = json['chatEnabled'];
    acceptedAt = json['acceptedAt'];
    expiresAt = json['expiresAt'];
    scheduledAt = json['scheduledAt'];
    completedAt = json['completedAt'];
    disputedAt = json['disputedAt'];
    cancelledAt = json['cancelledAt'];
    disputedBy = json['disputedBy'];
    disputedReason = json['disputedReason'];
    cancelledBy = json['cancelledBy'];
    cancellationReason = json['cancellationReason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['$createdAt'] = this.createdAt;
    data['$updatedAt'] = this.updatedAt;
    data['userId'] = this.userId;
    data['businessId'] = this.businessId;
    data['type'] = this.type;
    data['serviceName'] = this.serviceName;
    data['message'] = this.message;
    data['amount'] = this.amount;
    data['fee'] = this.fee;
    data['currency'] = this.currency;
    data['status'] = this.status;
    data['chatEnabled'] = this.chatEnabled;
    data['acceptedAt'] = this.acceptedAt;
    data['expiresAt'] = this.expiresAt;
    data['scheduledAt'] = this.scheduledAt;
    data['completedAt'] = this.completedAt;
    data['disputedAt'] = this.disputedAt;
    data['cancelledAt'] = this.cancelledAt;
    data['disputedBy'] = this.disputedBy;
    data['disputedReason'] = this.disputedReason;
    data['cancelledBy'] = this.cancelledBy;
    data['cancellationReason'] = this.cancellationReason;
    return data;
  }
}
