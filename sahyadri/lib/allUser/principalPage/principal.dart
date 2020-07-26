
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahyadri/compunds/displayEventList.dart';
import 'package:sahyadri/compunds/verificationWidget.dart';


class PrincipalMainPage extends StatefulWidget {
  @override
  _PrincipalMainPageState createState() => _PrincipalMainPageState();
}

class _PrincipalMainPageState extends State<PrincipalMainPage> {
  List<dynamic> validArray ;
  bool value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DashBoard"),
        // centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          FlatButton(
            child: Text("LogOut"),
            textColor: Colors.white,
            onPressed: (){
              FirebaseAuth.instance.signOut().then((res) =>
              Navigator.pushReplacementNamed(context, '/login'))
              .catchError((err) => print(err));

            },
          )
        ],
      
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder(
          stream: Firestore.instance.collection('EventCollections').snapshots(), 
          // ignore: missing_return
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
            else{
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                  validArray = documentSnapshot['VerificationList'];
                  print( documentSnapshot['VerificationList'].runtimeType);
                  if(validArray[0] == 1 && validArray[1] == 1 && validArray[2] == 0)
                  {
                    return GestureDetector(
                        onTap:() {
                        Navigator.push(context,
                         MaterialPageRoute(builder:(context)=>VerificationWidget(
                           indexValue: index,
                           authority:documentSnapshot['designation'],
                           eventName: documentSnapshot['EventName'],
                           title: 'Event Verification'
                           )
                         )
                        );
                        },
                        child: DisplayEventList(documentSnapshot: documentSnapshot),  
                  
                    );
                  
                  
                  }
                  else{
                    return Container(
                    );
                  }
                }
              );
            }
          },
        ),
      
          )
        ],
      ),
    
    );
  }
}












