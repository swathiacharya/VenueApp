


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';


class DisplayEventList extends StatelessWidget {
  const DisplayEventList({
    Key key,
    @required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot documentSnapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:20.0,left:15.0,right: 15.0,bottom: 10.0),
    child: Card(
      
      color:Colors.teal[50],

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      elevation:15.0,

      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: new Image.network(
              documentSnapshot["ImageUrl"],
              height: 200.0,
              width: 250.0,

              alignment: Alignment.bottomLeft,
              fit: BoxFit.fill,

            ),


          ),
          Expanded(
            child:Column(
              children: [

                Text(
                  documentSnapshot["EventName"].toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SourceSansPro',
                    color: Colors.black87 ,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 5.0,
                ),

                Text(
                  "Venue: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SourceSansPro',
                    color: Colors.black ,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                Text(
                  documentSnapshot["Venue"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'SourceSansPro',
                    color: Colors.grey[600] ,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                Text(
                  "Date: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SourceSansPro',
                    color: Colors.black ,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                Text(
                  documentSnapshot["EventDate"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'SourceSansPro',
                    color: Colors.grey[600] ,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                Text(
                  "Time: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SourceSansPro',
                    color: Colors.black,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                Text(
                  documentSnapshot["EventTime"],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'SourceSansPro',
                    color: Colors.grey[600] ,
                    fontWeight:FontWeight.bold,
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}