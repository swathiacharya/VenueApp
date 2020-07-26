
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class StreamBuilderPage extends StatelessWidget {
  final int indexValue1;
  final  String authorityValue;
  final  String eventNameDb;

  const StreamBuilderPage({Key key, this.indexValue1, this.authorityValue, this.eventNameDb}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    List<dynamic> validArray ;
    return StreamBuilder(
                stream:  Firestore.instance.collection("EventCollections").snapshots(),
                builder: (context, snapshot) {
                  DocumentSnapshot documentSnapshot = snapshot.data.documents[indexValue1];
                  // ignore: unused_element
                  String imageUrl= documentSnapshot["ImageUrl"];
                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  else{
                    return  Container(
                          child:Card(
                        elevation: 15.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(20.0)
                        ),
                      child: Column(
                        padding: EdgeInsets.only(top:8.0,bottom:8.0,left:5.0),
                        children: [
                          Column(
                            children: [
                           
                           /*******************  Image ************************/
                           SizedBox(
                             height:25.0,
                           ),

                           Stack(
                                children: [
                                  Center(
                                    child:FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: '$imageUrl',
                                      width: 325.0,
                                      height: 345.0,
                                    ),
                                  ),
                                ],

                              ),
                            /****************  Event Name  ********************/
                            Center(
                              child: Text(documentSnapshot["EventName"],
                                style:TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontSize: 30.0,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              height:10.0,
                              width: 225.0,
                              child: Divider(
                                color: Colors.teal,
                                thickness: 4.0,                           
                              ),
                            ),
                          /****************  VENUE ********************/
                            Container(
                              
                              child:Row(
                                children: [
                                  Text("VENUE:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 20.0,
                                      // letterSpacing: 1.6,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0
                                  ),
                                  Text(documentSnapshot['Venue'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                 )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                          /****************  DATE TIME ********************/

                            Container(
                              child: Row(
                                children:[
                                  SizedBox(
                                    width: 18.0,
                                  ),
                                  Text("Date:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 20.0,
                                    
                                      letterSpacing: 1.6,
                                    ),
                                  ),

                                  Text(documentSnapshot['EventDate'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 20.0,
                                      letterSpacing: 1.6,
                                    ),
                                 ),

                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(" Time:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 20.0,
                                      // letterSpacing: 1.6,
                                    ),
                                  ),
                                  
                                  Text(documentSnapshot['EventTime'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      
                                    ),                     
                                 ),
                                ],
                              ) ,
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            

                            

                      ],
                      ),
                          Container(
                              child: Text('Description:',
                              style:TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro',
                                // fontSize: 20.0,
                              ),
                              )
                            ),
                          Container(
                              child:Text(documentSnapshot['Description']),
                            ),

                            SizedBox(height: 25.0,),

                            Container(
                              child: RaisedButton(
                                color: Colors.teal,
                                child: Text('ACCEPT'),
                                onPressed: (){
                                  print('$authorityValue ');
                                  print(documentSnapshot['VerificationList'][0] );
                                  if(authorityValue == 'HOD'){
                                    documentSnapshot['VerificationList'][0] =1;
                                  }
                                  else if (authorityValue == 'MainDept') {
                                    documentSnapshot['VerificationList'][1] =1;
                                  } else {
                                    documentSnapshot['VerificationList'][2] =1;
                                  }
                                }
                                
                                )
                              ),
                           SizedBox(height: 25.0,),
                            Expanded(
                              child: RaisedButton(
                                color: Colors.red,
                                child: Text('Reject'),
                                onPressed: (){
                                  // return AlertDialog(
                                  //   title: Text('Rejected'),
                                  //   content: SingleChildScrollView(
                                  //     child: ListBody(
                                  //       children: [
                                  //         Text('$eventNameDb has been Rejected.'),
                                  //         Text('Please do email for Rejection of  $eventNameDb Event!')
                                  //       ]
                                  //     ),
                                  //   ),
                                  //   actions: [
                                  //     FlatButton(
                                  //       child: Text('OKAY'),
                                  //       onPressed: () {
                                  //         DocumentReference documentReference = Firestore.instance.collection('users').document(eventNameDb);
                                  //         documentReference.delete().whenComplete(() {
                                  //             print("$eventNameDb Deleted");
                                  //             Navigator.of(context).pop();
                                  //           }
                                  //         );
                                  //       } 
                                  //     )
                                  //   ],

                                  // );
                                }
                              )
                              SizedBox(height: 75.0,),
                            ),
                        ],
                    ), 
                ),
            );
        }
      }
    );
  }
}