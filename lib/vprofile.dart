import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardianeb/login.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_animations/stateless_animation/mirror_animation.dart';
import 'package:url_launcher/url_launcher.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<ProfileScreen> {
  PageController _myPage;
  SharedPreferences sharedPreferences;
  List ads = [];
  int currentPage = 0;
  var stringResponse;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid");
    http.Response response;
    response = await (http.get(
        Uri.parse(
            'https://constant-system-370505.el.r.appspot.com/api/user/details?id=' + id),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    setState(() {
      stringResponse = json.decode(response.body);
    });

    print(stringResponse);

  }

  @override
  void initState() {
    super.initState();
    getHttp();
    _myPage = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              child: Image(

                image: AssetImage("assets/martlogo.png"),),
            ),
            Container(child:Text("Student" , style: TextStyle(color:Color(0xFFdeb887) , ) ,))
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 25,
              color: Color(0xFFdeb887),
            ),
            onPressed: () async {
              sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
        ],
      ),
      body: stringResponse == null
          ? MirrorAnimation<double>(
        tween: Tween(begin: -100.0, end: 100.0),
        // value for offset x-coordinate
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutSine,
        // non-linear animation
        builder: (context, child, value) {
          return Transform.translate(
            offset:
            Offset(value, 0), // use animated value for x-coordinate
            child: child,
          );
        },
        child: Container(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/martlogo.png"),
              height: 100,
              width: 100,
            )),
      )
          : SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 110, top: 50),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 80,
                          backgroundImage:
                          AssetImage("assets/martlogo.png"),
                          backgroundColor: Color(0xFF00b207)),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Share.share(
                        'Download the app from applink use my coupon and earn viaancoins. \n Coupon : ${stringResponse["coupon"]}');
                  },
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 5),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Share",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                      Expanded(
                        child: SizedBox(
                          width: 10,
                        ),
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 10),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(
                          color: Color(0xFF00b207),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${stringResponse["email"]}",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )),
                Divider(color: Colors.black),
                // GestureDetector(
                //     onTap: () {
                //       Navigator.of(context).push(MaterialPageRoute(
                //         builder: (context) => AddressDetails(),
                //       ));
                //     },
                //     child: Column(
                //       children: [
                //         Container(
                //             margin: EdgeInsets.only(left: 10, top: 20),
                //             alignment: Alignment.topLeft,
                //             child: Text(
                //               "Address",
                //               style: TextStyle(
                //                   color: Color(0xFF00b207),
                //                   fontWeight: FontWeight.bold,
                //                   fontSize: 18),
                //             )),
                //         Row(
                //           children: [
                //             stringResponse["currentaddress"] == null
                //                 ? Container(
                //                 margin:
                //                 EdgeInsets.only(left: 10, top: 5),
                //                 alignment: Alignment.topLeft,
                //                 child: Text(
                //                   "Add Address",
                //                   style: TextStyle(
                //                       color: Colors.grey,
                //                       fontSize: 18),
                //                 ))
                //                 : Container(
                //                 margin:
                //                 EdgeInsets.only(left: 10, top: 5),
                //                 alignment: Alignment.topLeft,
                //                 child: Text(
                //                   "${stringResponse["currentaddress"]["city"]}",
                //                   style: TextStyle(
                //                       color: Colors.grey,
                //                       fontSize: 18),
                //                 )),
                //             Expanded(
                //               child: SizedBox(
                //                 width: 10,
                //               ),
                //             ),
                //             Icon(
                //               Icons.arrow_forward_ios_sharp,
                //               color: Color(0xFF00b207),
                //             ),
                //             SizedBox(
                //               width: 15,
                //             ),
                //           ],
                //         )
                //       ],
                //     )),
                // Divider(color: Colors.black),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                          color: Color(0xFF00b207),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${stringResponse["contactno"]}",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    )),
                Divider(color: Colors.black),
                GestureDetector(
                  onTap: () async {
                    final Uri _url = Uri.parse('https://api.whatsapp.com/send?phone=+919466560786&text=Hello Vakeem Agro! Need Help');

                    if (await launchUrl(_url ,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw 'Could not launch';

                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      alignment: Alignment.topLeft,
                      child:
                      Row(
                        children: [
                          Text(
                            "Support",
                            style: TextStyle(
                                color: Color(0xFF00b207),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 10,
                            ),
                          ),
                          Icon(
                            Icons.whatsapp,
                            color: Color(0xFF00b207),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      )
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: ()=>{
                    Register()
                  },
                  child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 90),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(CupertinoIcons.delete_solid, color: Colors.red,)
                    ],
                  ),
                ),
                SizedBox(
                  height: 500,
                ),

              ],
            )),
      ));



  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.pink : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }


  Register() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString("uid");


    Map data = {
      'id': uid
    };
    var jsonResponse = null;
    var url = Uri.parse("https://vakeemagro.el.r.appspot.com/api/users/delete");
    var response =
    await http.post(url, body: data);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {

        });
        Fluttertoast.showToast(
          msg: "Account Deleted !",
          toastLength: Toast.LENGTH_SHORT,
        );


        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.clear();
        sharedPreferences.commit();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
        //     (Route<dynamic> route) => false);
      }
    } else {
      setState(() {

      });

      Fluttertoast.showToast(
        msg: "${json.decode(response.body)}",
        toastLength: Toast.LENGTH_SHORT,
      );
      print("The error message is: ${response.body}");
    }
  }

}
