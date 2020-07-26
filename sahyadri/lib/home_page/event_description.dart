import 'package:transparent_image/transparent_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';


class EventDescription extends StatelessWidget with NavigationStates{
  // String EventName;

  final int indexValue;
  EventDescription({Key key, this.indexValue}) : super(key: key);

  // final String eventName;
  // EventDescription({Key key, this.eventName}) : super(key: key);
  String netImage;
  String eventName;
  String description;
  String eventDate;
  String eventTime;
  String imageUrl;
  String organizedBy;
  String organizerEmailid;
  String venue;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // title: Text('Sahyadri Event'),
            pinned: true,
            // floating: true,
            // snap: true,
            backgroundColor: Colors.teal,
            expandedHeight:250.0,
            flexibleSpace:  FlexibleSpaceBar(
              title: Text("Event Description"),
              background: new Image.asset(
                'images/sahyadri.jpg',
                fit: BoxFit.cover,
              ),

            )
          ),
          SliverFillRemaining(
             child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top:50.0),
          child: Flexible(

            child:StreamBuilder(
                stream:  Firestore.instance.collection("EventCollections").snapshots(),
                builder: (context, snapshot) {
                  DocumentSnapshot documentSnapshot = snapshot.data.documents[indexValue];
                  eventName = documentSnapshot["EventName"];

                  eventDate= documentSnapshot["EventDate"];
                  eventTime = documentSnapshot["EventTime"];
                  imageUrl= documentSnapshot["ImageUrl"];
                  organizedBy= documentSnapshot["OrganizedBy"];

                  organizerEmailid= documentSnapshot["OrganizerEmailid"];
                  venue= documentSnapshot["Venue"];

                  description = documentSnapshot["Description"];

                  imageUrl= documentSnapshot["ImageUrl"];



                  if(!snapshot.hasData){
                    return CircularProgressIndicator();
                  }
                  else{
                    return  Container(
                      child: Card(
                        elevation: 10.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(20.0)
                        ),
                       child: Expanded(
                        child: Column(
                          children: [
                            Stack(
                                children: [
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Center(
                                    child:FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: '$imageUrl',
                                      width: 25.0,
                                      height: 35.0,
                                                                          
                                    ),
                                  ),
                                ],

                              ),

                            // EventName
                            Container(
                              padding: EdgeInsets.all(15.0),
                              child:Center(
                              child: Text(
                                eventName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 18.0,
                                  color: Colors.teal.shade200,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            ),


                            // Venue
                             Container(
                              padding: EdgeInsets.all(15.0),
                              child:Center(
                              child: Text(
                                venue,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 18.0,
                                  color: Colors.teal.shade200,
                                  letterSpacing: 2.5
                                ),
                              ),
                            ),
                            ),

                            //  Date and time
                            Container(
                              padding: EdgeInsets.all(15.0),
                              child:Row(
                                children: [
                                  Text('Date: '),
                                  Text(eventDate),
                                  Text('Time: '),
                                  Text(eventTime),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),

                            // Description
                            Container(
                              padding: EdgeInsets.all(15.0),
                              child:Center(
                              child: Text(
                                description,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 18.0,
                                  color: Colors.teal.shade200,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),
                            ),

                            // organiser
                            Container(
                              padding: EdgeInsets.all(15.0),
                              child:Center(
                              child: Text(
                                'Organizer MailID : $organizerEmailid',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 18.0,
                                  color: Colors.teal.shade200,
                                  letterSpacing: 2.5,                                 
                                ),
                              ),
                            ),
                            ),


                            // orniser email id

                            Container(
                              padding: EdgeInsets.all(15.0),
                              child:Center(
                              child: Text(
                                'organized BY : $organizerEmailid',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 18.0,
                                  color: Colors.teal.shade200,
                                  letterSpacing: 2.5,                                 
                                ),
                              ),
                            ),
                            ),




                            
                            


                
                        ],
                      ),
                  ),
                ),
              );
              }
            }),
          ),
        )),
        ],
      ),    
    );
  }
}