import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Signup.dart';
import '../widget/auth.dart';

class Login extends StatefulWidget {
  Login({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _passval = "Password";
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

   validateGoogleSignIn() async{
    GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    try {
          await widget.auth.signInWithCredential(gSA.accessToken, gSA.idToken);
      widget.onSignedIn();
    } catch (e) {
      print("error $e");
    }
  }


  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
            await widget.auth.signInWithEmailAndPassword(_email, _password);
        widget.onSignedIn();
      } catch (e) {
        print("error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _loginitems(),
            ),
          ),
        ),
      );

  List<Widget> _loginitems() => <Widget>[
        Image(
          image: AssetImage("assets/images/logo.png"),
          width: 100.0,
          fit: BoxFit.contain,
        ),
        Text(
          "\"The best Photographers in town\"\n–now just a fingertip away–",
          style: TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
          textAlign: TextAlign.center,
        ),
        Image(
          image: AssetImage("assets/images/login_vector.png"),
          width: 250.0,
          fit: BoxFit.contain,
        ),
        Text(
          "Sign in",
          style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico'),
        ),
        Form(
          key: formKey,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "Email can't be empty" : null,
                    onSaved: (value) => _email = value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "Enter E-mail or phone number",
                      contentPadding: EdgeInsets.all(8),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'Pacifico'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "Password can't be empty" : null,
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: _passval,
                      contentPadding: EdgeInsets.all(8),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'Pacifico'),
                      suffixIcon: _passval == "Password"
                          ? IconButton(
                              onPressed: _toggleVisibility,
                              icon: _isHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            )
                          : null,
                    ),
                    obscureText: _passval == "Password" ? _isHidden : false,
                  ),
                ),
                RaisedButton(
                    onPressed: validateAndSubmit,
                    color: Color(0xff03a9f4),
                    elevation: 0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: 'Pacifico'),
                    )),
              ],
            ),
          ),
        ),
        Text("or", style: TextStyle(fontSize: 20.0, fontFamily: 'Pacifico')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: _loginbutton(),
        ),
        InkWell(
          onTap: () {
            Route route = MaterialPageRoute(
                builder: (context) => Signup(
                      auth: Auth(),
                    ));
            Navigator.pushReplacement(context, route);
          },
          child: Text(
            "Create an account",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 20.0,
                fontFamily: 'Pacifico'),
          ),
        ),
      ];

  List<Widget> _loginbutton() => <Widget>[
        SafeArea(
            child: Column(children: <Widget>[
          // MaterialButton(
          //   onPressed: (){},
          //   color: Color(0xff8190dd),
          //   elevation: 0,
          //   textColor: Colors.white,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Padding(
          //         padding: const EdgeInsets.only(right: 4.0),
          //         child: SvgPicture.asset("assets/images/facebook.svg",
          //             width: 20.0),
          //       ),
          //       Text(
          //         "Continue with Facebook",
          //         style: TextStyle(color: Colors.white, fontSize: 12),
          //       ),
          //     ],
          //   ),
          // ),
          MaterialButton(
            onPressed: () => validateGoogleSignIn(),
            color: Color(0xff03a9f4),
            elevation: 0,
            textColor: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Continue with Google",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ]))
      ];
}
