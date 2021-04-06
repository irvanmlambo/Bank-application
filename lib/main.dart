import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/remote/bank_api_service.dart';
import 'package:bank/view/login/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      // The initialized BankApiService is now available down the widget tree
      create: (_) => BankApiService.create(),
      // Always call dispose on the ChopperClient to release resources
      dispose: (context, BankApiService service) => service.client.dispose(),
      child: MaterialApp(
        title: 'Momentum',
        home: LoginPage(),
      ),
    );
  }
}
