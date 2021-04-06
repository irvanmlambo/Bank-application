import 'dart:convert';
import 'package:bank/data/model/Login.dart';
import 'package:bank/data/model/error_model.dart';
import 'package:bank/data/model/user.dart';
import 'package:bank/data/repository/BankRepository.dart';
import 'package:bank/view/details/detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextStyle style = TextStyle(fontSize: 12.0);

  final _email = TextEditingController();
  final _password = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Login loginModel;
  User userModel;
  BankRepository repo;

  bool _loading = false;

  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loginModel = new Login();
    repo = new BankRepository();
  }

  void showLoading(bool loading){
    setState(() {
      _loading = loading;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      body: ModalProgressHUD(child: Container(
        child: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset('momentum.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _email,
                  validator: (value) => (value.isEmpty) ? "Email required" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Email",
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (value) =>
                  (value.isEmpty) ? "Password is required" : null,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Password",
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.red,
                  child: MaterialButton(
                    height: 50,
                    onPressed: () async {
                      if(_formKey.currentState.validate()){

                        showLoading(true);

                        loginModel.email = _email.text;
                        loginModel.password = _password.text;
                        loginModel.returnSecureToken = true;

                        try{
                          final response = await repo.login(loginModel, context);

                          if(response.isSuccessful){

                            showLoading(false);

                            var user = User.fromJson(response.body);

                            // Navigate to client details page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(user: user)
                                )
                            );

                          }else{
                            showLoading(false);

                            var error = ErrorModel.fromJson(jsonDecode(response.error.toString()));

                            // Display an error message to the user
                            final snackBar = SnackBar(content: Text(error.error.message));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }catch(e){
                          final snackBar = SnackBar(content: Text("Network error"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: Text(
                      "Login",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ), inAsyncCall: _loading),
    );
  }
}