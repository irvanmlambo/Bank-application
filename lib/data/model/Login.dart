class Login {
  String email;
  String password;
  bool returnSecureToken = true;

  Login({this.email, this.password, this.returnSecureToken});

  Map<String , dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
      'returnSecureToken': returnSecureToken
    };

    return map;
  }
}