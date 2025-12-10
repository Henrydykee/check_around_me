class BusinessModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? about;
  String? category;

  List<String>? services;

  // Dynamic pricing map: service -> price
  Map<String, num>? servicesPrices;

  String? verificationStatus;

  // These can come as int or double, so use num
  num? rating;
  num? reviewCount;
  num? minPrice;
  num? maxPrice;

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
  String? status;

  String? ownerId;
  String? referralCode;

  BankDetails? bankDetails;

  BusinessModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.about,
    this.category,
    this.services,
    this.servicesPrices,
    this.verificationStatus,
    this.rating,
    this.reviewCount,
    this.minPrice,
    this.maxPrice,
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
    this.status,
    this.ownerId,
    this.referralCode,
    this.bankDetails,
  });

  BusinessModel.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    createdAt = json['$createdAt'];
    updatedAt = json['$updatedAt'];
    name = json['name'];
    about = json['about'];
    category = json['category'];

    services = json['services'] != null
        ? List<String>.from(json['services'])
        : null;

    // servicesPrices is a dynamic map with prices
    if (json['servicesPrices'] != null) {
      final raw = json['servicesPrices'] as Map<String, dynamic>;
      servicesPrices = raw.map(
            (key, value) => MapEntry(
          key,
          value is num ? value : num.tryParse(value.toString()) ?? 0,
        ),
      );
    }

    verificationStatus = json['verificationStatus'];

    // These MUST be num to avoid double→int crashes
    rating = json['rating'] is num ? json['rating'] : num.tryParse("${json['rating']}");
    reviewCount = json['reviewCount'] is num ? json['reviewCount'] : num.tryParse("${json['reviewCount']}");

    minPrice = json['minPrice'] is num ? json['minPrice'] : num.tryParse("${json['minPrice']}");
    maxPrice = json['maxPrice'] is num ? json['maxPrice'] : num.tryParse("${json['maxPrice']}");

    addressLine1 = json['addressLine1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];

    paymentOptions = json['paymentOptions'] != null
        ? List<String>.from(json['paymentOptions'])
        : null;

    coordinates = json['coordinates'];
    phoneCountryCode = json['phoneCountryCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    status = json['status'];

    ownerId = json['ownerId'];
    referralCode = json['referralCode'];

    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "\$id": id,
      "\$createdAt": createdAt,
      "\$updatedAt": updatedAt,
      "name": name,
      "about": about,
      "category": category,
      "services": services,
      "servicesPrices": servicesPrices,
      "verificationStatus": verificationStatus,
      "rating": rating,
      "reviewCount": reviewCount,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "addressLine1": addressLine1,
      "city": city,
      "state": state,
      "country": country,
      "postalCode": postalCode,
      "paymentOptions": paymentOptions,
      "coordinates": coordinates,
      "phoneCountryCode": phoneCountryCode,
      "phoneNumber": phoneNumber,
      "email": email,
      "status": status,
      "ownerId": ownerId,
      "referralCode": referralCode,
      "bankDetails": bankDetails?.toJson(),
    };
  }
}

class BankDetails {
  String? bankName;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? recipientCode;

  BankDetails({
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.recipientCode,
  });

  BankDetails.fromJson(Map<String, dynamic> json) {
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    bankCode = json['bankCode'];
    recipientCode = json['recipientCode'];
  }

  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'bankCode': bankCode,
      'recipientCode': recipientCode,
    };
  }
}
