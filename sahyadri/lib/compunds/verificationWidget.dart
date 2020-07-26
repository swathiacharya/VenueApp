
import 'package:flutter/material.dart';

import 'package:sahyadri/compunds/streambuilder.dart';


class VerificationWidget extends StatelessWidget {
  final int indexValue;
  final  String authority;
  final String eventName;
  final String title;

  const VerificationWidget({Key key, this.indexValue, this.authority, this.eventName, this.title}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.teal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.teal,
            expandedHeight:220.0,
            flexibleSpace:  FlexibleSpaceBar(
              title: Text("$title"),
              background: Image.asset(
              'images/sahyadri.jpg',
              fit: BoxFit.cover,),
            )
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: StreamBuilderPage(indexValue1: indexValue,authorityValue:authority, eventNameDb: eventName,),
          ),
        ],
      ),
    );
  }
}