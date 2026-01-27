

class CreateBusinessPayload {
  String? name;
  String? about;
  String? category;
  List<String>? services;
  Map<String, int>? servicesPrices;
  String? addressLine1;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  List<String>? paymentOptions;
  String? coordinates;
  String? phoneCountryCode;
  String? phoneNumber;
  String? email;
  String? website;
  String? status;
  int? minPrice;
  int? maxPrice;
  bool? onSiteParking;
  bool? garageParking;
  bool? wifi;
  String? referralCode;
  BankDetails? bankDetails;
  Hours? hours;
  List<Images>? images;
  int? bookingFee;
  String? bookingFeeType;

  CreateBusinessPayload(
      {this.name,
        this.about,
        this.category,
        this.services,
        this.servicesPrices,
        this.addressLine1,
        this.city,
        this.state,
        this.country,
        this.postalCode,
        this.paymentOptions,
        this.coordinates,
        this.phoneCountryCode,
        this.phoneNumber,
        this.email,
        this.website,
        this.status,
        this.minPrice,
        this.maxPrice,
        this.onSiteParking,
        this.garageParking,
        this.wifi,
        this.referralCode,
        this.bankDetails,
        this.hours,
        this.images,
        this.bookingFee,
        this.bookingFeeType});

  CreateBusinessPayload.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    about = json['about'];
    category = json['category'];
    services = json['services'] != null ? List<String>.from(json['services']) : null;
    servicesPrices = json['servicesPrices'] != null
        ? Map<String, int>.from(json['servicesPrices'].map((key, value) => MapEntry(key, value is int ? value : int.tryParse(value.toString()) ?? 0)))
        : null;
    addressLine1 = json['addressLine1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
    paymentOptions = json['paymentOptions'] != null ? List<String>.from(json['paymentOptions']) : null;
    coordinates = json['coordinates'];
    phoneCountryCode = json['phoneCountryCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    website = json['website'];
    status = json['status'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    onSiteParking = json['onSiteParking'];
    garageParking = json['garageParking'];
    wifi = json['wifi'];
    referralCode = json['referralCode'];
    bankDetails = json['bankDetails'] != null
        ? new BankDetails.fromJson(json['bankDetails'])
        : null;
    hours = json['hours'] != null ? new Hours.fromJson(json['hours']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    bookingFee = json['bookingFee'];
    bookingFeeType = json['bookingFeeType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['about'] = this.about;
    data['category'] = this.category;
    data['services'] = this.services;
    if (this.servicesPrices != null) {
      data['servicesPrices'] = this.servicesPrices;
    }
    data['addressLine1'] = this.addressLine1;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['postalCode'] = this.postalCode;
    data['paymentOptions'] = this.paymentOptions;
    data['coordinates'] = this.coordinates;
    data['phoneCountryCode'] = this.phoneCountryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['website'] = this.website;
    data['status'] = this.status;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['onSiteParking'] = this.onSiteParking;
    data['garageParking'] = this.garageParking;
    data['wifi'] = this.wifi;
    data['referralCode'] = this.referralCode;
    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }
    if (this.hours != null) {
      data['hours'] = this.hours!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['bookingFee'] = this.bookingFee;
    data['bookingFeeType'] = this.bookingFeeType;
    return data;
  }
}

class BankDetails {
  String? bankName;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? recipientCode;

  BankDetails(
      {this.bankName,
        this.accountNumber,
        this.accountName,
        this.bankCode,
        this.recipientCode});

  BankDetails.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    bankCode = json['bankCode'];
    recipientCode = json['recipientCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    data['bankCode'] = this.bankCode;
    data['recipientCode'] = this.recipientCode;
    return data;
  }
}

class Hours {
  Mon? mon;
  Mon? tue;
  Mon? wed;
  Mon? thu;
  Mon? fri;
  Mon? sat;
  Mon? sun;

  Hours({this.mon, this.tue, this.wed, this.thu, this.fri, this.sat, this.sun});

  Hours.fromJson(Map<String, dynamic> json) {
    mon = json['Mon'] != null ? new Mon.fromJson(json['Mon']) : null;
    tue = json['Tue'] != null ? new Mon.fromJson(json['Tue']) : null;
    wed = json['Wed'] != null ? new Mon.fromJson(json['Wed']) : null;
    thu = json['Thu'] != null ? new Mon.fromJson(json['Thu']) : null;
    fri = json['Fri'] != null ? new Mon.fromJson(json['Fri']) : null;
    sat = json['Sat'] != null ? new Mon.fromJson(json['Sat']) : null;
    sun = json['Sun'] != null ? new Mon.fromJson(json['Sun']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mon != null) {
      data['Mon'] = this.mon!.toJson();
    }
    if (this.tue != null) {
      data['Tue'] = this.tue!.toJson();
    }
    if (this.wed != null) {
      data['Wed'] = this.wed!.toJson();
    }
    if (this.thu != null) {
      data['Thu'] = this.thu!.toJson();
    }
    if (this.fri != null) {
      data['Fri'] = this.fri!.toJson();
    }
    if (this.sat != null) {
      data['Sat'] = this.sat!.toJson();
    }
    if (this.sun != null) {
      data['Sun'] = this.sun!.toJson();
    }
    return data;
  }
}

class Mon {
  String? open;
  String? close;
  bool? closed;

  Mon({this.open, this.close, this.closed});

  Mon.fromJson(Map<String, dynamic> json) {
    open = json['open'];
    close = json['close'];
    closed = json['closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open'] = this.open;
    data['close'] = this.close;
    data['closed'] = this.closed;
    return data;
  }
}

class Images {
  String? id;
  String? imageUrl;
  String? title;
  String? fileId;
  String? businessId;
  bool? isPrimary;
  String? createdAt;
  String? uploadedBy;

  Images(
      {this.id,
        this.imageUrl,
        this.title,
        this.fileId,
        this.businessId,
        this.isPrimary,
        this.createdAt,
        this.uploadedBy});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    fileId = json['fileId'];
    businessId = json['businessId'];
    isPrimary = json['isPrimary'];
    createdAt = json['createdAt'];
    uploadedBy = json['uploadedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['fileId'] = this.fileId;
    data['businessId'] = this.businessId;
    data['isPrimary'] = this.isPrimary;
    data['createdAt'] = this.createdAt;
    data['uploadedBy'] = this.uploadedBy;
    return data;
  }
}
