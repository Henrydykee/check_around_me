import 'create_booking_payload.dart';

class BookingListResponse {
  List<BookingModel>? bookings;
  int? total;

  BookingListResponse({this.bookings, this.total});

  BookingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['bookings'] != null) {
      bookings = <BookingModel>[];
      json['bookings'].forEach((v) {
        bookings!.add(BookingModel.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class BookingModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  int? sequence;
  String? tableId;
  String? databaseId;
  List<String>? permissions;
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
  String? resolutionReason;
  String? cancelledBy;
  String? cancellationReason;
  Map<String, dynamic>? metadata;
  UserDetails? userDetails;

  BookingModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.sequence,
    this.tableId,
    this.databaseId,
    this.permissions,
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
    this.resolutionReason,
    this.cancelledBy,
    this.cancellationReason,
    this.metadata,
    this.userDetails,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    createdAt = json['\$createdAt'];
    updatedAt = json['\$updatedAt'];
    sequence = json['\$sequence'];
    tableId = json['\$tableId'];
    databaseId = json['\$databaseId'];
    if (json['\$permissions'] != null) {
      permissions = <String>[];
      json['\$permissions'].forEach((v) {
        permissions!.add(v.toString());
      });
    }
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
    resolutionReason = json['resolutionReason'];
    cancelledBy = json['cancelledBy'];
    cancellationReason = json['cancellationReason'];
    metadata = json['metadata'] != null
        ? Map<String, dynamic>.from(json['metadata'])
        : null;
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$id'] = id;
    data['\$createdAt'] = createdAt;
    data['\$updatedAt'] = updatedAt;
    data['\$sequence'] = sequence;
    data['\$tableId'] = tableId;
    data['\$databaseId'] = databaseId;
    if (permissions != null) {
      data['\$permissions'] = permissions;
    }
    data['userId'] = userId;
    data['businessId'] = businessId;
    data['type'] = type;
    data['serviceName'] = serviceName;
    data['message'] = message;
    data['amount'] = amount;
    data['fee'] = fee;
    data['currency'] = currency;
    data['status'] = status;
    data['chatEnabled'] = chatEnabled;
    data['acceptedAt'] = acceptedAt;
    data['expiresAt'] = expiresAt;
    data['scheduledAt'] = scheduledAt;
    data['completedAt'] = completedAt;
    data['disputedAt'] = disputedAt;
    data['cancelledAt'] = cancelledAt;
    data['disputedBy'] = disputedBy;
    data['disputedReason'] = disputedReason;
    data['resolutionReason'] = resolutionReason;
    data['cancelledBy'] = cancelledBy;
    data['cancellationReason'] = cancellationReason;
    if (metadata != null) {
      data['metadata'] = metadata;
    }
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    return data;
  }
}
