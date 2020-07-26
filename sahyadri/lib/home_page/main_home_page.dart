
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';
import 'package:sahyadri/compunds/displayEventList.dart';
import 'package:sahyadri/compunds/verificationWidget.dart';
import 'package:sahyadri/home_page/posts.dart';






class HomePage extends StatefulWidget with NavigationStates{
  
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

TextEditingController  editingController = TextEditingController();

List<String> venueList = [];

  String image;
  List<dynamic> validArray ;
  bool value;
  String eventName;

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [

/***************************************************** HEADER PART *************************************************************/

          Container(
            padding: EdgeInsets.only(top: 50,left:1.0),
            child: Column(
              children: [
                Text(
                  'Sahyadri ',
                  style:TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 35.0,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'EVENTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceSansPro',
                    fontSize: 18.0,
                    color: Colors.teal.shade200,
                    letterSpacing: 2.5,
                  ),
                ),

              ],
            ),
          ),

/**************************************************** EVENT PHOTO****************************************************************/

          Flexible(
            flex: 3,
            child:StreamBuilder(
              stream: Firestore.instance.collection("Events").snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData)
                {
                  return Container(
                    decoration:BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(35),
                        topRight: const Radius.circular(25),
                        bottomLeft: const Radius.circular(35),
                        bottomRight: const Radius.circular(25),),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context,index){
                        DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                        image=documentSnapshot["Url"];
                        return Container(
                          padding: EdgeInsets.all(10.0),
                          child : Image.network(
                            image,
                          ),
                        );
                      },
                    ),
                  );
                }
                else{
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),

//          Expanded(
//            child: Futur,
//          ),

/************************************************SERARCH**********************************************************/

          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom:10.0, left:22.0,right: 18.0),
            child: TextField(
              controller: editingController,
              decoration: InputDecoration(
                  
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),

              onChanged: (string) {
              },
            ),
          ),

/**************************************************** EVENT lIST****************************************************************/
          Flexible(
            flex: 5,
            child:StreamBuilder(
              stream: Firestore.instance.collection("EventCollections").snapshots(),
              builder: (context,snapshot){
                
                if(snapshot.hasData)
                {
                return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context,index){
                  DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
                  eventName = documentSnapshot['EventName'];
                  validArray = documentSnapshot['VerificationList'];
                  print( documentSnapshot['VerificationList'].runtimeType);
                  if(validArray[0] == 1 && validArray[1] == 1 && validArray[2] == 1)
                  {
                    return GestureDetector(
                        onTap:() {
                        Navigator.push(context,
                         MaterialPageRoute(builder:(context)=>VerificationWidget(indexValue: index,
                         authority: documentSnapshot['designation'],
                         eventName: eventName,
                         title: 'Event Description'
                         
                         )));
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
                else{
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }

}

