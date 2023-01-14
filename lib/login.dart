import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardianeb/Navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;

  String _verificationId;
  int _code;
  String _status;
  bool otpsend = false;
  bool verified = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:

      SingleChildScrollView(

        child:
        Container(

          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height/2 -110,) ,
                      Center(
                          child:Row(children: [
                            Container(
                              child:  Image(
                                height: 100,
                                width: 320 ,
                                image: AssetImage("assets/martlogo.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],)
                      ),

                      Container(
                        height: 65,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Email ID ",
                              hintStyle: TextStyle(color: Colors.grey[400] ,
                                //   shadows: [
                                //   Shadow(
                                //     blurRadius: 2.0,
                                //     color: Colors.teal,
                                //     offset: Offset(1.0, 1.0),
                                //   ),
                                // ],
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold, )),
                        ),
                      ),


                      Container(
                        height: 65,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(),
                        child: TextField(
                          controller: passController,
                          obscureText: hideconpass,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Confirm Password",
                              suffixIcon: InkWell(
                                onTap: () {
                                  if (hideconpass == true) {
                                    hideconpass = false;
                                  } else {
                                    hideconpass = true;
                                  }
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.visibility,
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.grey[400] ,
                                  fontSize: 12,

                                  fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child:
                        Container(
                          width: 200,
                          height: 40.0,
                          decoration: BoxDecoration(gradient:  LinearGradient(
                            colors: <Color>[Color(0xFFdeb887), Color(0xFFdeb887)],
                          ), boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: (){
                                  String _email = emailController.text.trim();
                                  String _pass = passController.text.trim();
                                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  //   builder: (context) =>
                                  //       Navigation(),
                                  // ));
                                  signIn(_email, _pass);
                                },
                                child: Center(
                                  child:  Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )),
                          ),
                        ),


                      ),
                      SizedBox(height: 10,),

                      SizedBox(height: 110,),
                    ],
                  ),
                ),
              ),
            ],
          ),

        )
        ,
      ),
    );

  }

  signIn(String mobile, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': mobile,
      'password': pass
    };
    var jsonResponse = null;
    var url = Uri.parse("https://constant-system-370505.el.r.appspot.com/api/user/login");
    var response = await http.post(url, body: data );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Welcome to Vakeem Agro",
          toastLength: Toast.LENGTH_SHORT,
        );
        sharedPreferences.setString("email",  mobile );
        sharedPreferences.setString("type",  'seller' );

        sharedPreferences.setString("uid",  json.decode(response.body)['_id'] );
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Navigation()), (Route<dynamic> route) => false);

        // http.Response aresponse;
        // aresponse = await (http.get(
        //     Uri.parse(
        //         'https://vakeemagro.el.r.appspot.com/api/users/active?id=' + sharedPreferences.getString("uid")),
        //     headers: {
        //       'Content-Type': 'application/json',
        //       'Accept': 'application/json',
        //     }));
        // if(aresponse.statusCode==200){
        //
        // }else{
        //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SubcriptionScreen()), (Route<dynamic> route) => false);
        //
        // }
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      Fluttertoast.showToast(
        msg: "${json.decode(response.body)['message']}",
        toastLength: Toast.LENGTH_SHORT,
      );
      print("The error message is: ${json.decode(response.body)['message']}");
    }
  }

}


