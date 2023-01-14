import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardianeb/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simple_animations/stateless_animation/mirror_animation.dart';


class HistoryScreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<HistoryScreen> {
  PageController _myPage;
  SharedPreferences sharedPreferences;
  List ads = [] ;
  int currentPage = 0;
  var productdetails ;

  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  TextEditingController couponController = new TextEditingController();


  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id =  sharedPreferences.getString("uid");

    http.Response presponse;
    presponse = await (http
        .get(Uri.parse('https://constant-system-370505.el.r.appspot.com/api/user/gethistory?id=' +id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }));


    setState(() {
      productdetails = json.decode(presponse.body);

    });
 print(productdetails);
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
      body:
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            SizedBox(height: 10),

            Align(alignment: Alignment.topLeft, child: Text("History" , style: TextStyle(color: Color(0xFFdeb887),fontSize: 12,  fontWeight: FontWeight.bold))),
            productdetails == null ?
            MirrorAnimation<double>(
              tween: Tween(begin: -100.0, end: 100.0), // value for offset x-coordinate
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutSine, // non-linear animation
              builder: (context, child, value) {
                return Transform.translate(
                  offset: Offset(value, 0), // use animated value for x-coordinate
                  child: child,
                );
              },
              child:  Container(alignment: Alignment.center, child: Image( image: AssetImage("assets/martlogo.png"), height: 100 , width: 100,)),

            ) :
            SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: productdetails.length,
                          itemBuilder:
                              (BuildContext context, int iindex) {
                            return
                              GestureDetector(
                                  onTap: (){
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (context) => ProductDetails(index :  "${productdetails[iindex]["_id"]}"  , cate: "${productdetails[iindex]["pcat"]}" ,),
                                    // ));
                                  },
                                  child:
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          padding: EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color:  Color(0xFFdeb887),
                                            borderRadius:
                                            BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 5),
                                                blurRadius: 23,
                                                spreadRadius: -13,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: <Widget>[

                                              SizedBox(width: 5),
                                              Container(

                                                  padding: EdgeInsets.only(top:0),
                                                  child:
                                                  Row(children: [
                                                    Container(

                                                      child: Column(
                                                        children: <Widget>[
                                                          Align(
                                                              alignment : Alignment.bottomLeft ,
                                                              child:  Text(
                                                                  "Date : ${productdetails[iindex]["date"]}",
                                                                  style: TextStyle(color: Colors.white , fontSize: 15 ,fontWeight: FontWeight.bold))),
                                                          Align(
                                                              alignment : Alignment.bottomLeft ,
                                                              child:  Text(
                                                                  "Test : ${productdetails[iindex]["tname"]}",
                                                                  style: TextStyle(color: Colors.white , fontSize: 15 ))),
                                                          Row(children: [
                                                            Container(
                                                              height: 30,
                                                              child: Text("Left Word:  ${productdetails[iindex]["left"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.green)),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              child: Text(" , Extra Word:  ${productdetails[iindex]["extra"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.red)),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              child: Text(", Correct Word:  ${productdetails[iindex]["correct"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.lightGreenAccent)),
                                                            ),

                                                          ],)
                                                          ,
                                                          Row(children: [
                                                            Container(
                                                              height: 30,
                                                              child: Text("Total Word:  ${productdetails[iindex]["tword"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.blue)),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              child: Text(" , Type Word:  ${productdetails[iindex]["ttype"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.pink)),
                                                            ),


                                                          ],),
                                                          Row(children: [
                                                            Container(
                                                              height: 30,
                                                              child: Text("Accuracy %:  ${productdetails[iindex]["tword"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.yellow)),
                                                            ),
                                                            Container(
                                                              height: 30,
                                                              child: Text(" , Error %:  ${productdetails[iindex]["ttype"].toString()}" , style:TextStyle(fontWeight: FontWeight.bold , fontSize: 13 , color: Colors.teal)),
                                                            ),


                                                          ],),
                                                        ],
                                                      ),),
                                                  ],)
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                          }),
                      SizedBox(height: 15,),
                    ],
                  ),
                )),
          ]),
        ),
      )
  );
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
}
