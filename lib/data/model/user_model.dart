class UserModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? registration;
  bool? status;
  String? passwordUpdate;
  String? email;
  String? phone;
  bool? emailVerification;
  bool? phoneVerification;
  bool? mfa;
  String? referralCode;
  // Prefs? prefs;
  List<Targets>? targets;
  String? accessedAt;

  UserModel(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.registration,
        this.status,
        this.passwordUpdate,
      this.email,
      this.phone,
      this.emailVerification,
      this.phoneVerification,
      this.mfa,
      this.referralCode,
      // this.prefs,
      this.targets,
      this.accessedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['\$id'];
    createdAt = json['$createdAt'];
    updatedAt = json['$updatedAt'];
    name = json['name'];
    registration = json['registration'];
    status = json['status'];
    // if (json['labels'] != null) {
    //   labels = <Null>[];
    //   json['labels'].forEach((v) {
    //     labels!.add(new Null.fromJson(v));
    //   });
    // }
    passwordUpdate = json['passwordUpdate'];
    email = json['email'];
    phone = json['phone'];
    emailVerification = json['emailVerification'];
    phoneVerification = json['phoneVerification'];
    mfa = json['mfa'];
    referralCode = json['referralCode'];
    // prefs = json['prefs'] != null ? new Prefs.fromJson(json['prefs']) : null;
    if (json['targets'] != null) {
      targets = <Targets>[];
      json['targets'].forEach((v) {
        targets!.add(new Targets.fromJson(v));
      });
    }
    accessedAt = json['accessedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['$createdAt'] = this.createdAt;
    data['$updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['registration'] = this.registration;
    data['status'] = this.status;
    // if (this.labels != null) {
    //   data['labels'] = this.labels!.map((v) => v.toJson()).toList();
    // }
    data['passwordUpdate'] = this.passwordUpdate;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['emailVerification'] = this.emailVerification;
    data['phoneVerification'] = this.phoneVerification;
    data['mfa'] = this.mfa;
    data['referralCode'] = this.referralCode;
    // if (this.prefs != null) {
    //   data['prefs'] = this.prefs!.toJson();
    // }
    if (this.targets != null) {
      data['targets'] = this.targets!.map((v) => v.toJson()).toList();
    }
    data['accessedAt'] = this.accessedAt;
    return data;
  }
}

// class Prefs {
//   List<String>? deviceTokens;
//
//   Prefs({this.deviceTokens});
//
//   Prefs.fromJson(Map<String, dynamic> json) {
//     deviceTokens = json['deviceTokens'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['deviceTokens'] = this.deviceTokens;
//     return data;
//   }
// }

class Targets {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? userId;
  Null providerId;
  String? providerType;
  String? identifier;
  bool? expired;

  Targets(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.userId,
        this.providerId,
        this.providerType,
        this.identifier,
        this.expired});

  Targets.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    createdAt = json['$createdAt'];
    updatedAt = json['$updatedAt'];
    name = json['name'];
    userId = json['userId'];
    providerId = json['providerId'];
    providerType = json['providerType'];
    identifier = json['identifier'];
    expired = json['expired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['$createdAt'] = this.createdAt;
    data['$updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['providerId'] = this.providerId;
    data['providerType'] = this.providerType;
    data['identifier'] = this.identifier;
    data['expired'] = this.expired;
    return data;
  }
}
