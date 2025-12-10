class CreateBookingPayload {
  String? businessId;
  String? userId;
  String? type;
  String? serviceName;
  String? status;
  UserDetails? userDetails;

  CreateBookingPayload(
      {this.businessId,
        this.userId,
        this.type,
        this.serviceName,
        this.status,
        this.userDetails});

  CreateBookingPayload.fromJson(Map<String, dynamic> json) {
    businessId = json['businessId'];
    userId = json['userId'];
    type = json['type'];
    serviceName = json['serviceName'];
    status = json['status'];
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessId'] = this.businessId;
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['serviceName'] = this.serviceName;
    data['status'] = this.status;
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? name;
  String? address;
  String? note;

  UserDetails({this.name, this.address, this.note});

  UserDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['note'] = this.note;
    return data;
  }
}
