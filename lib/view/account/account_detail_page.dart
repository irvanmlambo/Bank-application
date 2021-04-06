import 'dart:convert';

import 'package:bank/data/model/account_model.dart';
import 'package:bank/data/model/client_error_model.dart';
import 'package:bank/data/model/user.dart';
import 'package:bank/data/repository/BankRepository.dart';
import 'package:flutter/material.dart';

class AccountDetailPage extends StatefulWidget {

  // Declare a field that holds the account number
  final int accountNumber;

  // Declare a field that holds the use
  final User user;

  // In the constructor, require a User
  AccountDetailPage({Key key, @required this.accountNumber, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage> {

  TextStyle style = TextStyle(fontSize: 12.0);

  final _withdrawalAmount = TextEditingController();
  final _depositAmount = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _depositFormKey = GlobalKey<FormState>();

  BankRepository repo;
  AccountModel accountModel;

  double balance = 0.0;
  int overdraft = 0;

  @override
  void initState() {
    super.initState();

    repo = new BankRepository();

    // Get account details
    getDetails();
  }

  Future<void> getDetails() async {
    var response = await repo.getAccountDetails(widget.accountNumber.toString(), widget.user.idToken, context);

    if(response.isSuccessful){

      if(response == null){
        accountModel = AccountModel(balance: 0.0, overdraft: 1000);
        setAccountDetails(accountModel.balance, accountModel.overdraft);

      }else{
        accountModel = AccountModel.fromJson(response.body);
        accountModel.balance = accountModel.balance == null ? 0.0 : accountModel.balance;
        setAccountDetails(accountModel.balance, accountModel.overdraft);
      }
    }
  }

  void setAccountDetails(double balance, int overdraft){
    setState(() {
      this.balance = balance;
      this.overdraft = overdraft;
    });
  }

  @override
  Widget build(BuildContext context) {
   // final double tempHeight = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0;

    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
                            child: Text(
                              'Account details',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8, top: 16
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.accountNumber.toString()??'No account',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 22,
                                    letterSpacing: 0.27,
                                    color: Colors.grey
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                                        child: SizedBox(
                                          width: AppBar().preferredSize.height,
                                          height: AppBar().preferredSize.height,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                              BorderRadius.circular(AppBar().preferredSize.height),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(microseconds: 500),
                            opacity: 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  getAccountBalanceUI('R$balance', 'Balance'),
                                  getAccountBalanceUI('R$overdraft', 'Overdraft'),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16
                            ),
                            child: getWithdrawalUI(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getWithdrawalUI(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: _withdrawalAmount,
                      validator: (value) => (value.isEmpty) ? "Amount required" : null,
                      style: style,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Withdrawal amount",
                          border: OutlineInputBorder()
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red,
                        child: MaterialButton(
                          height: 50,
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              // Withdrawal request
                              if(double.parse(_withdrawalAmount.text) <= balance){


                                if(accountModel == null) {
                                  accountModel = AccountModel();
                                  accountModel.balance =  double.parse(_withdrawalAmount.text);
                                  accountModel.overdraft = 0;
                                }
                                else{
                                  accountModel.balance = accountModel.balance - double.parse(_withdrawalAmount.text);
                                  accountModel.overdraft = overdraft;
                                }

                                try{
                                  final response = await repo.updateAccountBalance(
                                      widget.user.idToken, widget.accountNumber.toString(), context, accountModel);

                                  if(response.isSuccessful){
                                    setState(() {
                                      accountModel = AccountModel.fromJson(response.body);
                                      balance = accountModel.balance;
                                    });

                                    final snackBar = SnackBar(content: Text('R' + _withdrawalAmount.text + ' was withdrawn from your account.'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                    // Clear the text field
                                    _withdrawalAmount.clear();
                                  }else{

                                    var error = ClientErrorModel.fromJson(jsonDecode(response.error.toString()));

                                    // Display an error message to the user
                                    final snackBar = SnackBar(content: Text(error.error));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }
                                }catch(e){
                                  final snackBar = SnackBar(content: Text("Network error"));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }else{
                                final snackBar = SnackBar(content: Text('Please enter amount below or equal to the account balance.'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Text(
                            "Withdraw",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          Form(
            key: _depositFormKey,
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      controller: _depositAmount,
                      validator: (value) => (value.isEmpty) ? "Amount required" : null,
                      style: style,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Deposit amount",
                          border: OutlineInputBorder()
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.red,
                        child: MaterialButton(
                          height: 50,
                          onPressed: () async {
                            if(_depositFormKey.currentState.validate()){
                              // deposit request
                              if(accountModel == null) {
                                accountModel = AccountModel();
                                accountModel.balance =  double.parse(_depositAmount.text);
                                accountModel.overdraft = 0;
                              }
                              else{
                                accountModel.balance = balance == null ? 0.0 : balance + double.parse(_depositAmount.text);
                                accountModel.overdraft = overdraft;
                              }

                              try{
                                final response = await repo.updateAccountBalance(
                                    widget.user.idToken, widget.accountNumber.toString(), context, accountModel);

                                if(response.isSuccessful){
                                  setState(() {
                                    accountModel = AccountModel.fromJson(response.body);
                                    balance = accountModel.balance;
                                  });

                                  final snackBar = SnackBar(content: Text('R' + _depositAmount.text + ' was loaded into your account.'));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  // Clear the text field
                                  _depositAmount.clear();
                                }else{

                                  var error = ClientErrorModel.fromJson(jsonDecode(response.error.toString()));

                                  // Display an error message to the user
                                  final snackBar = SnackBar(content: Text(error.error));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }catch(e){
                                final snackBar = SnackBar(content: Text("Network error"));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          },
                          child: Text(
                            "Deposit",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        ],
      )
    );
  }

  Widget getAccountBalanceUI(String balance, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                balance,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.redAccent,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}