
import 'package:bank/data/model/Login.dart';
import 'package:bank/data/model/account_model.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';

abstract class IBankRepository {

  // User login
  Future<Response> login(Login loginModel, BuildContext context);

  // Get client details
  Future<Response> getClientDetails(String token, String id, BuildContext context);

  // Get account details
  Future<Response> getAccountDetails(String token, String account, BuildContext context);

  // Update account balance
  Future<Response> updateAccountBalance(String token, String account, BuildContext context, AccountModel accountModel);

  // Update account balance
  Future<Response> updateAccountList(String token, String id, BuildContext context, List<int> accountList);
}