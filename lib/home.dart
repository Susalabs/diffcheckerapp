import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_data/form_data.dart';
import 'package:guardianeb/login.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_diff_text/pretty_diff_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);
  static String routeName = "/splash";

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<HomeScreen> {
  bool hidepass = true;
  bool hideconpass = true;
  List<String> list = <String>['Kg', 'Quintal'];
  String dropdownValue = 'Kg';
  String dropdownValue2 = 'Kg', _imageUrl;
  PickedFile _tempImage;

  bool isChecked = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController desController = new TextEditingController();
  TextEditingController mrpController = new TextEditingController();
  TextEditingController smrpController = new TextEditingController();
  TextEditingController mosController = new TextEditingController();
  TextEditingController dustController = new TextEditingController();
  TextEditingController gcvController = new TextEditingController();
  TextEditingController quaController = new TextEditingController();

  bool _isLoading = false;
  var errorMsg;
  double correct=0;
  double incorrect=0;
  double extra =0;
  double left=0;
  double tword=0;
  double ttype =0;
  double acc=0;
  double error =0;


  var other = "";

  List<String> cat = [];
  int currentPage = 0;
  var catdetails;
  var productdetails;
  SharedPreferences sharedPreferences;

  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Register();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid");
    http.Response aresponse;
    aresponse = await (http.get(
        Uri.parse(
            'https://constant-system-370505.el.r.appspot.com/api/unit/get'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    setState(() {
      catdetails = json.decode(aresponse.body);
      dropdownValue = json.decode(aresponse.body)[0]['tname'];
      other = json.decode(aresponse.body)[0]['name'];
      _start = json.decode(aresponse.body)[0]['time'];
    });

    print(catdetails);

    for (int i = 0; i < catdetails.length; i++) {
      setState(() {
        cat.add(catdetails[i]['tname']);
      });
    }
  }

  @override
  void initState() {
    getHttp();
    // TODO: implement initState
    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                image: AssetImage("assets/martlogo.png"),
              ),
            ),
            Container(
                child: Text(
              "Student",
              style: TextStyle(
                color: Color(0xFFdeb887),
              ),
            ))
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(child: Text("Select Test:")),
                  Container(
                    height: 65,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value;
                           correct=0;
                           incorrect=0;
                           extra =0;
                           left=0;
                           tword=0;
                           ttype =0;
                           acc=0;
                           error =0;


                        });

                        for (int i = 0; i < catdetails.length; i++) {

                          if(catdetails[i]['tname'] == value ){
                            setState(() {
                                other = catdetails[i]['name'];
                                _start = catdetails[i]['time'];
                            });
                          }

                        }


                      },
                      items: cat.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      width: 100,
                      height: 40.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[Colors.green, Colors.green],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              offset: Offset(0.0, 1.5),
                              blurRadius: 1.5,
                            ),
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () async {
                              startTimer();

                            },
                            child: Center(
                              child: Text(
                                "START TEST",
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Timer  : ",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      )),
                  Container(
                      child: Text(
                        "${_start}",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ))
                ],
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                height: 100,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(),
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: nameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Input",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Color(0xFFdeb887), Color(0xFFdeb887)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(0.0, 1.5),
                          blurRadius: 1.5,
                        ),
                      ]),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          Register();

                        },
                        child: Center(
                          child: Text(
                            "SUBMIT TEST",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              _isLoading == false? Container() :  PrettyDiffText(
                oldText: "${other}",
                newText: "${ nameController.text.trim()}",
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Total Left  : ",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      )),
                  Container(
                      child: Text(
                        "${incorrect}",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Total Extra : ",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )),
                  Container(
                      child: Text(
                        "${extra}",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Total Correct  : ",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                  Container(
                      child: Text(
                        "${correct}",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Total Words  : ",
                        style: TextStyle(
                          color: Color(0xFFdeb887),
                        ),
                      )),
                  Container(
                      child: Text(
                        "0",
                        style: TextStyle(
                          color: Color(0xFFdeb887),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                        "Total Type :",
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                        ),
                      )),
                  Container(
                      child: Text(
                        "0",
                        style: TextStyle(
                          color: Colors.lightGreenAccent,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                    "Accuracy % : ",
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  )),
                  Container(
                      child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ))
                ],
              ),
              Row(
                children: [
                  Container(
                      child: Text(
                    "Error % :",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )),
                  Container(
                      child: Text(
                    "0",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          //   ),
          // ),
          // ],
          // ),
          //  ),
        ),
      ),
    );
  }

  Register() async {
    _timer.cancel();

    String _name = nameController.text.trim();

    if (_name.isEmpty) {
      Fluttertoast.showToast(
        msg: "Fill Field",
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {





      setState((){
        _isLoading = true;

        tword=other.length/2;
        ttype =_name.length/2;
      });

      DiffMatchPatch dmp = DiffMatchPatch();
      List<Diff> diffs =
      dmp.diff(other, _name);

      final textSpans =
      List<TextSpan>.empty(growable: true);

      diffs.forEach((diff) {
        if (diff.operation == DIFF_INSERT) {
          setState(() {

          });
        }
        if (diff.operation == DIFF_DELETE) {
          setState(() {

          });
        }

        if (diff.operation == DIFF_EQUAL) {
          setState(() {
            correct++;
          });
        }
      });
    }
    setState(() {
      left = tword -correct;
      extra = ttype - correct;
      error = extra +incorrect/tword;
      acc = 100-acc;

    });


    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm');
    String formattedDate = formatter.format(now);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString('uid');
    Map data = {
      "date" : formattedDate,
      "tname" : dropdownValue,
      "left" : left,
      "extra" : extra,
      "correct" : correct,
      "tword" : tword,
      "ttype" : ttype,
      "acc" : acc,
      "error" : error,

    };
    var jsonResponse = null;
    var url = Uri.parse("https://constant-system-370505.el.r.appspot.com/api/user/addhistory?id=" + id);
    var response = await http.post(url, body: data );
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse != null) {
        Fluttertoast.showToast(
          msg: "Test Submitted !",
          toastLength: Toast.LENGTH_SHORT,
        );

      }}

  }}
