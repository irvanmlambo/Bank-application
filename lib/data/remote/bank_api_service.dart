import 'package:bank/data/model/Login.dart';
import 'package:bank/data/model/account_model.dart';
import 'package:bank/utils/Constants.dart';
import 'package:chopper/chopper.dart';

part 'bank_api_service.chopper.dart';

@ChopperApi()
abstract class BankApiService extends ChopperService {

  @Post()
  Future<Response> login(
      @Body() Login loginModel,
      @Query("key") String key);

  @Get(path: 'clients/{id}.json')
  Future<Response> getClientDetails(
      @Query('auth') String token,
      @Path('id') String id);

  @Get(path: 'accounts/{account}.json')
  Future<Response> getAccountDetails(
      @Query('auth') String token,
      @Path('account') String account);

  @Put(path: 'accounts/{account}.json')
  Future<Response> updateAccountBalance(
    @Query('auth') String token,
    @Path('account') String account,
    @Body() AccountModel accountModel);

  @Put(path: 'clients/{id}/accounts.json')
  Future<Response> updateAccountList(
      @Query('auth') String token,
      @Path('id') String id,
      @Body() List<int> accountList);

  static BankApiService create() {
    final client = ChopperClient(
      baseUrl: baseUrl,
      services: [
        // The generated implementation
        _$BankApiService(),
      ],
      // Converts data to & from JSON an adds the application/json header.
      converter: JsonConverter(),
    );

    // The generated class with the ChopperClient passed in
    return _$BankApiService(client);
  }
}