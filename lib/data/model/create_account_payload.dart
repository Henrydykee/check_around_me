class CreateAccountModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? captchaToken;
  bool? login;
  String? referralCode;
  bool? optInMailingList;

  CreateAccountModel(
      {this.name,
        this.email,
        this.password,
        this.phone,
        this.captchaToken,
        this.login,
        this.referralCode,
        this.optInMailingList});

  CreateAccountModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    captchaToken = json['captchaToken'];
    login = json['login'];
    referralCode = json['referralCode'];
    optInMailingList = json['optInMailingList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['captchaToken'] = this.captchaToken;
    data['login'] = this.login;
    data['referralCode'] = this.referralCode;
    data['optInMailingList'] = this.optInMailingList;
    return data;
  }
}
