
class BusinessDetailsResponse {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? about;
  String? category;
  List<String>? services;
  ServicesPrices? servicesPrices;
  String? verificationStatus;
  int? rating;
  int? reviewCount;
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
  String? ownerId;
  String? referralCode;
  BankDetails? bankDetails;

  BusinessDetailsResponse(
      {this.id,
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
        this.ownerId,
        this.referralCode,
        this.bankDetails});

  BusinessDetailsResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    createdAt = json['$createdAt'];
    updatedAt = json['$updatedAt'];
    name = json['name'];
    about = json['about'];
    category = json['category'];
    services = json['services'].cast<String>();
    servicesPrices = json['servicesPrices'] != null
        ? new ServicesPrices.fromJson(json['servicesPrices'])
        : null;
    verificationStatus = json['verificationStatus'];
    rating = json['rating'];
    reviewCount = json['reviewCount'];
    addressLine1 = json['addressLine1'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    postalCode = json['postalCode'];
    paymentOptions = json['paymentOptions'].cast<String>();
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
    ownerId = json['ownerId'];
    referralCode = json['referralCode'];
    bankDetails = json['bankDetails'] != null
        ? new BankDetails.fromJson(json['bankDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['$createdAt'] = this.createdAt;
    data['$updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['about'] = this.about;
    data['category'] = this.category;
    data['services'] = this.services;
    if (this.servicesPrices != null) {
      data['servicesPrices'] = this.servicesPrices!.toJson();
    }
    data['verificationStatus'] = this.verificationStatus;
    data['rating'] = this.rating;
    data['reviewCount'] = this.reviewCount;
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
    data['ownerId'] = this.ownerId;
    data['referralCode'] = this.referralCode;
    if (this.bankDetails != null) {
      data['bankDetails'] = this.bankDetails!.toJson();
    }
    return data;
  }
}

class ServicesPrices {
  int? additionalProp1;
  int? additionalProp2;
  int? additionalProp3;

  ServicesPrices(
      {this.additionalProp1, this.additionalProp2, this.additionalProp3});

  ServicesPrices.fromJson(Map<String, dynamic> json) {
    additionalProp1 = json['additionalProp1'];
    additionalProp2 = json['additionalProp2'];
    additionalProp3 = json['additionalProp3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['additionalProp1'] = this.additionalProp1;
    data['additionalProp2'] = this.additionalProp2;
    data['additionalProp3'] = this.additionalProp3;
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
