

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
    final Map<String, dynamic> data = <String, dynamic>{};
    void setIfNotNull(String key, dynamic value) {
      if (value != null) data[key] = value;
    }
    // API expects phoneCountryCode without '+' (e.g. "234")
    String? stripPlus(String? s) =>
        s == null ? null : (s.replaceFirst(RegExp(r'^\+\s*'), '').trim().isEmpty ? null : s.replaceFirst(RegExp(r'^\+\s*'), '').trim());

    setIfNotNull('name', name);
    setIfNotNull('about', about);
    setIfNotNull('category', category);
    setIfNotNull('services', services);
    setIfNotNull('servicesPrices', servicesPrices);
    setIfNotNull('addressLine1', addressLine1);
    setIfNotNull('city', city);
    setIfNotNull('state', state);
    setIfNotNull('country', country);
    setIfNotNull('postalCode', postalCode);
    setIfNotNull('paymentOptions', paymentOptions);
    setIfNotNull('coordinates', coordinates);
    setIfNotNull('phoneCountryCode', stripPlus(phoneCountryCode) ?? phoneCountryCode);
    setIfNotNull('phoneNumber', phoneNumber);
    setIfNotNull('email', email);
    data['website'] = website ?? '';
    setIfNotNull('status', status);
    setIfNotNull('minPrice', minPrice);
    setIfNotNull('maxPrice', maxPrice);
    data['referralCode'] = referralCode;
    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.toJson();
    }
    if (hours != null) {
      data['hours'] = hours!.toJson();
    }
    if (images != null && images!.isNotEmpty) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    setIfNotNull('bookingFee', bookingFee);
    setIfNotNull('bookingFeeType', bookingFeeType);
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
    id = json[r'$id'] ?? json['id'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    fileId = json['fileId'];
    businessId = json['businessId'];
    isPrimary = json['isPrimary'];
    createdAt = json['createdAt'];
    uploadedBy = json['uploadedBy'];
  }

  /// Images object for createBusiness: $id, businessId, imageUrl, isPrimary, title, uploadedBy (no createdAt, no fileId)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      r'$id': id,
      'businessId': businessId,
      'imageUrl': imageUrl,
      'isPrimary': isPrimary ?? false,
      'title': title,
      'uploadedBy': uploadedBy,
    };
  }
}
