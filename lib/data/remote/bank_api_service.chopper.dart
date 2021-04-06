// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$BankApiService extends BankApiService {
  _$BankApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = BankApiService;

  @override
  Future<Response<dynamic>> login(Login loginModel, String key) {
    final $url = '';
    final $params = <String, dynamic>{'key': key};
    final $body = loginModel;
    final $request =
        Request('POST', $url, loginBaseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getClientDetails(String token, String id) {
    final $url = 'clients/$id.json';
    final $params = <String, dynamic>{'auth': token};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAccountDetails(String token, String account) {
    final $url = 'accounts/$account.json';
    final $params = <String, dynamic>{'auth': token};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateAccountBalance(
      String token, String account, AccountModel accountModel) {
    final $url = 'accounts/$account.json';
    final $params = <String, dynamic>{'auth': token};
    final $body = accountModel;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateAccountList(
      String token, String id, List<int> accountList) {
    final $url = 'clients/$id/accounts.json';
    final $params = <String, dynamic>{'auth': token};
    final $body = accountList;
    final $request =
        Request('PUT', $url, client.baseUrl, body: $body, parameters: $params);
    return client.send<dynamic, dynamic>($request);
  }
}
