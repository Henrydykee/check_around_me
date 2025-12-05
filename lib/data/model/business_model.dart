
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
  BankDetails? bankDetails;

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
    id = json['\$id'];
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
    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
        : null;
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

