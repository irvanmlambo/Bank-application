import 'package:bank/data/model/Login.dart';
import 'package:bank/data/model/account_model.dart';
import 'package:bank/data/remote/bank_api_service.dart';
import 'package:bank/data/repository/IBankRepository.dart';
import 'package:bank/utils/Constants.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BankRepository implements IBankRepository {

  @override
  Future<Response> login(Login loginModel, BuildContext context) async {
    return await Provider.of<BankApiService>(context, listen: false).login(loginModel, apiKey);
  }

  @override
  Future<Response> getClientDetails(String token, String id, BuildContext context) async {
    return await Provider.of<BankApiService>(context, listen: false).getClientDetails(token, id);
  }

  @override
  Future<Response> getAccountDetails(String token, String account, BuildContext context) async {
    return await Provider.of<BankApiService>(context, listen: false).getAccountDetails(account, token);
  }

  @override
  Future<Response> updateAccountBalance(String token, String account, BuildContext context, AccountModel accountModel) async {
    return await Provider.of<BankApiService>(context, listen: false).updateAccountBalance(token, account, accountModel);
  }

  @override
  Future<Response> updateAccountList(String token, String id, BuildContext context, List<int> accountList) async {
    return await Provider.of<BankApiService>(context, listen: false).updateAccountList(token, id, accountList);
  }
}