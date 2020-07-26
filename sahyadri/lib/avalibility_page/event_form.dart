import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sahyadri/menu/sidebar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';
import 'dart:convert';
class EventFillForm extends StatefulWidget  with NavigationStates{

  @override
  _EventFillFormState createState() => _EventFillFormState();
}

class _EventFillFormState extends State<EventFillForm> {

  TextEditingController _textFieldController =TextEditingController();

  final formKey = new GlobalKey<FormState>();
  File sampleImage;



  DateTime _currentDate = new DateTime.now();
  TimeOfDay _currentTime = new TimeOfDay.now();

  String url;
  String EventName;
  String _description;
  String _venue;
  String _organiser;
  String _dateValue;
  String _timevalue;
  String _url;

  Future<Null> _selectdate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(

        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2050),
        builder: (context, child) {
          return SingleChildScrollView(child: child,);
        }
    );
    if (_seldate != null) {
      setState(() {
        _currentDate = _seldate;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay _selTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return SingleChildScrollView(child: child,);
        }
    );
    if (_selTime != null) {
      setState(() {
        _currentTime = _selTime;
        _timevalue = formatTimeOfDay(_currentTime);
      });
    }
  }

  Future getImage() async{
    var tempImage =  await ImagePicker.pickImage(
        source: ImageSource.gallery
    );

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave(){
    final form =formKey.currentState;
    if(form.validate())
      {
        form.save();
        return true;
      }
    else{
      return false;
    }
  }

 uploadStatus() async
  {
    if(validateAndSave())
      {
        final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Image");
        var timekey = new DateTime.now();
        final StorageUploadTask uploadTask = postImageRef.child("$EventName.jpg").putFile(sampleImage);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        setState(() {
          print("uploated");
        });
        var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
        _url = ImageUrl.toString();
        print(_url);

        saveToDtabase(_url);
        gotoHomepage();
      }
  }

  saveToDtabase(url)
  {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    DocumentReference documentReference =Firestore.instance.collection("Events").document(EventName);
    Map<String,dynamic> eventDetails = {
      "EventName" : EventName,
      "Venue" : _venue,
      "OrganizedBy" : _organiser,
      "Description" : _description,
      "EventDate" : _dateValue,
      "EventTime" : _timevalue,
      "Url" : _url,

     };
    documentReference.setData(eventDetails).whenComplete(() {
      print("$EventName created");
    });
  }

  void gotoHomepage(){
    Navigator.pop(context);
    Navigator.pop(context);

  }




  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }


  @override
  Widget build(BuildContext context) {
    String _formatedDate = new DateFormat.yMMMd().format(_currentDate);

    _dateValue = _formatedDate;
    print('$_dateValue');
     return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Event Form'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
         child:Card(
           color:Colors.teal[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
          elevation:15.0,
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 25.0, bottom: 25.0, right: 8.0, left: 8.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Event Name',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),

                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Event name is Required';
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      return EventName = value;
                    },

                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Venue',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),

                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Venue is Required';
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      return _venue = value;
                    },

                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: 'Organized By',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),

                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Organizers name is Required';
                      }
                      else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      return _organiser = value;
                    },

                  ),
                  SizedBox(
                    height: 15.0,
                  ),

                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines:null,
                    decoration: new InputDecoration(
                      labelText: 'Description',
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),

                    onSubmitted: (val){
                      return _description=val;
                    },
                    onChanged: (value){
                      return _description=value;

                    },
                  ),
                  SizedBox(
                    height: 35.0,
                  ),

                  Column(
                    children: [

                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _selectdate(context);
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('$_formatedDate'),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(

                        children: [
                          FloatingActionButton(
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _selectTime(context);
                            },
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('$_timevalue'),

                        ],

                      ),

                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: FloatingActionButton(
                      onPressed: getImage,
                      backgroundColor: Colors.teal,
                      tooltip: 'Add Image',
                      child: new Icon(Icons.add_a_photo,),
                    ),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),



                  Container(
                    child: sampleImage == null?
                    Center(
                        child:Text('Select An Image')):
                    Container(
                      child: Image.file(sampleImage,height: 300.0,width: 500.0,),
                    ),

                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        top: 25.0, bottom: 25.0, right: 8.0, left: 8.0),

                    child: FlatButton(



                      child: Text("Submit",
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                      onPressed:(){
                        uploadStatus();
                      },

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),

                ],
              ),



            ),
          ),

        ),
        ),
      ),

    );
  }
}
