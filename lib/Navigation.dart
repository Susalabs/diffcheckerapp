import 'dart:math';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardianeb/history.dart';
import 'package:guardianeb/home.dart';
import 'package:guardianeb/variable.dart';
import 'package:guardianeb/vprofile.dart';


class Navigation extends StatefulWidget {
  const Navigation({
    Key key,
  }) : super(key: key);
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Navigation> {
  String a = "anuj";
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      selected = index; //
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(254, 238, 178, 1),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container(
          child: _widgetOptions.elementAt(selected), //vvm
        ),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Colors.white,
          selectedIndex: selected,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Color(0xFFdeb887),
              textAlign: TextAlign.center,
            ),

            BottomNavyBarItem(
              icon: Icon(Icons.assignment),
              title: Text('History'),
              activeColor: Color(0xFFdeb887),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person_rounded),
              title: Text('Profile'),
              activeColor: Color(0xFFdeb887),
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: (index) {
            setState(() {
              selected = index;
            });
            //Handle button tap
          },
        ));
  }
}
