/*this page has 3 buttun
* booking hall ==take to hall_booking page
* event form ====take to eveny_form dart file
*upload event photo
* */

import 'package:sahyadri/avalibility_page/event_form.dart';
import 'package:sahyadri/avalibility_page/upload_event_image.dart';
import 'package:sahyadri/avalibility_page/hall_booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri/menu/sidebar_layout.dart';

class BuildButtonNavigation extends StatefulWidget {
  @override
  _BuildButtonNavigationState createState() => _BuildButtonNavigationState();
}

class _BuildButtonNavigationState extends State<BuildButtonNavigation> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        activity('Booking Hall'),
        activity('Event Fill Form'),
        activity('Upload Event Image'),
      ],
    );
  }

  ListTile activity(String val)
  {
    String activityName=val;
    return ListTile(
      focusColor:Colors.tealAccent,
      hoverColor:Colors.tealAccent,
      leading: Icon(Icons.label_important),
      title: Text('$val'),
      onTap: (){
        if(activityName=='Booking Hall')
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>new VenueBook(),
//            MaterialPageRoute(builder: (context)=>new CarouselDemo(),
            ),
          );

        }
        else if(activityName=='Event Fill Form'){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=>new EventFillForm(),
              ),
          );

        }
        else{

        }
      },
    );
  }
}
