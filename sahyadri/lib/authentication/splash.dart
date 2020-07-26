import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahyadri/allUser/hodPage/hod_mainPage.dart';
import 'package:sahyadri/allUser/maintainanceDepartment/maindep_mainPage.dart';
import 'package:sahyadri/allUser/principalPage/principal.dart';
import 'package:sahyadri/menu/sidebar_layout.dart';


class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String userDesignation;
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
              if (currentUser == null)
                {Navigator.pushReplacementNamed(context, "/login")}
              else
                {
                  Firestore.instance
                      .collection("users")
                      .document(currentUser.uid)
                      .get()
                      .then((DocumentSnapshot result) =>
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) {
                                    userDesignation = result['designation'];
                                    print('###################################');
                                    print(result['designation']);
                                    if(userDesignation == 'Principal'){
                                      return PrincipalMainPage();
                                    }
                                    else if(userDesignation == 'HOD'){
                                      return HODMainPage();
                                    }
                                    else if(userDesignation == 'MainDept'){
                                      return MaintainanceDepPage();
                                    }
                                    else{
                                      return SideBarLayout();
                                    }
                                  }
                              )
                          )
                        )
                      .catchError((err) => print(err)
                  )
                }
            })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
