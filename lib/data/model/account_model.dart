import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  double balance;
  int overdraft;

  AccountModel({this.balance, this.overdraft});

  AccountModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    overdraft = json['overdraft'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['overdraft'] = this.overdraft;
    return data;
  }
}