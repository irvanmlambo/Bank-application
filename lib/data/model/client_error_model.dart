import 'package:json_annotation/json_annotation.dart';

part 'client_error_model.g.dart';

@JsonSerializable()
class ClientErrorModel {
  String error;

  ClientErrorModel({this.error});

  ClientErrorModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}