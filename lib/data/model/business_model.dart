
class BusinessModel {
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
  String? status;
  int? minPrice;
  int? maxPrice;
  String? ownerId;
  String? referralCode;
  Null? bankDetails;

  BusinessModel(
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
        this.status,
        this.minPrice,
        this.maxPrice,
        this.ownerId,
        this.referralCode,
        this.bankDetails});

  BusinessModel.fromJson(Map<String, dynamic> json) {
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
    status = json['status'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    ownerId = json['ownerId'];
    referralCode = json['referralCode'];
    bankDetails = json['bankDetails'];
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
    data['status'] = this.status;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['ownerId'] = this.ownerId;
    data['referralCode'] = this.referralCode;
    data['bankDetails'] = this.bankDetails;
    return data;
  }
}

class ServicesPrices {
  int? weddings;
  int? birthdays;
  int? coporateMeetings;
  int? conferences;
  int? tradeShow;
  int? socialGathering;

  ServicesPrices(
      {this.weddings,
        this.birthdays,
        this.coporateMeetings,
        this.conferences,
        this.tradeShow,
        this.socialGathering});

  ServicesPrices.fromJson(Map<String, dynamic> json) {
    weddings = json['Weddings'];
    birthdays = json['Birthdays'];
    coporateMeetings = json['Coporate Meetings'];
    conferences = json['Conferences'];
    tradeShow = json['Trade Show'];
    socialGathering = json['Social gathering'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Weddings'] = this.weddings;
    data['Birthdays'] = this.birthdays;
    data['Coporate Meetings'] = this.coporateMeetings;
    data['Conferences'] = this.conferences;
    data['Trade Show'] = this.tradeShow;
    data['Social gathering'] = this.socialGathering;
    return data;
  }
}
