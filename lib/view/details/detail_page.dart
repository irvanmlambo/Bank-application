import 'dart:math';
import 'package:bank/data/model/client_error_model.dart';
import 'package:bank/data/model/client_model.dart';
import 'package:bank/data/model/user.dart';
import 'package:bank/data/repository/BankRepository.dart';
import 'package:bank/view/account/account_detail_page.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {

  // Declare a field that holds the User
  final User user;

  // In the constructor, require a User
  DetailPage({Key key, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  BankRepository repo;
  ClientModel clientDetails;

  String name;
  int age;
  int itemCount = 0;

  @override
  void initState() {
    super.initState();

    // Instantiate repository
    repo = new BankRepository();

    // Get client details
    getDetails();
  }

  Future<void> getDetails() async {
    var response = await repo.getClientDetails(widget.user.idToken, widget.user.localId, context);

    if(response.isSuccessful){
      clientDetails = ClientModel.fromJson(response.body);


      setState(() {
        if(clientDetails.accounts != null){
          itemCount = clientDetails.accounts.length;
        }else{
          itemCount = 0;
        }
      });
      setClientData(clientDetails.name, clientDetails.age);
    }
  }

  void setClientData(String name, int age){
    setState(() {
      this.name = name;
      this.age = age;
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {

            // Generate account number
            var random = Random();
            var accountNumber = random.nextInt(1000000000) + 4000000000;

            // Check if account number already exists and regenerate
            for(int i = 0; i < clientDetails.accounts.length; i++){
              if(clientDetails.accounts[i] == accountNumber){
                // Regenerate account number
                accountNumber = random.nextInt(1000000000) + 4000000000;
              }
            }

            // Add new account
            clientDetails.accounts.add(accountNumber);
            var response = await repo.updateAccountList(widget.user.idToken, widget.user.localId, context, clientDetails.accounts);

            if(response.isSuccessful){
              setState(() {
                itemCount = clientDetails.accounts.length;
              });
            }else{
              var error = ClientErrorModel.fromJson(response.error);

              final snackBar = SnackBar(content: Text(error.error));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name??'',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.user.email??'',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            letterSpacing: 0.2,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: Image.asset('momentum.png'),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          getAgeBoxUI(age.toString(), 'Age'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Accounts',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            letterSpacing: 0.27,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  child: Wrap(
                    children: <Widget>[
                      Container(
                        child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemCount,
                          itemBuilder: (BuildContext context, int index){
                            return _buildItems(index);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItems(int index){
    return new Container(
      padding: const EdgeInsets.all(10),
      child: new Row(
        children: [
          new Row(
            children: [
              new MaterialButton(
                onPressed: () {

                  // Navigate to account detail page and pass the account number and user object as parameters
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountDetailPage(accountNumber: clientDetails.accounts[index], user: widget.user)
                      )
                  );
                },
                child: new Text(clientDetails.accounts != null ? clientDetails.accounts[index].toString() : ''),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget getAgeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
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
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.white,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
