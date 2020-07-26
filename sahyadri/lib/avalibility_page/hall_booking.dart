
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sahyadri/menu/sidebar.dart';
import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';

import 'package:file_picker/file_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
// import 'dart:html';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VenueBook extends StatefulWidget with NavigationStates {
  @override
  _VenueBookState createState() => _VenueBookState();
}

class _VenueBookState extends State<VenueBook> {


  TextEditingController _textFieldController =TextEditingController();
  var verification = [0,0,0];
  //verification[0]=> Hod;; verification[1]=> Management;;   verification[2]=>principal
  // verification;[0] = true;




  /*form key*/
  final formKey = new GlobalKey<FormState>();
/*WORKING WITH DROPDOWN FORM FILED*/
  String EventName;
  String _venuActivity;
  String _departmentActivity;
  String _designationActivity;
  String _description;
  String _organiser;
  // String _venuResult;
  // String _departmentResult;
  // String _designationResult;
  String _imgUrl;
  String _fileUrl;
  String _emialId;
  String imageUrl;
  String fileUrl;


  @override
  void initState(){
    super.initState();
    /*Drop down activity */
    _venuActivity = '';
    // _venuResult = '';
    _departmentActivity='';
    // _departmentResult = '';
    _designationActivity = '';
    // _designationResult='';
  }

  /* image from galary */
  File sampleImage;

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage=tempImage;
    });
  }

  /*pdf from phone document*/
  File pdfFile ;
  Future getPdf() async{
    var tempPdf = await FilePicker.getFile();
    setState((){
      pdfFile=tempPdf;
    });
  }





  /* PICKER DATE  and TIME*/
  DateTime _currentDate =new DateTime.now();
  TimeOfDay _currentTime =new TimeOfDay.now();

  String _dateValue;
  String _timeValue;
//Date
  Future<Null> _selectdate(BuildContext context)async{
    final DateTime _seldate = await showDatePicker(
      context:context,
      initialDate: _currentDate,
      firstDate:DateTime(2019),
      lastDate: DateTime(2030),
      builder: (context, child){
        return SingleChildScrollView(child: child,);
      }
    );
    if(_seldate !=null){
      setState(() {
        _currentDate = _seldate;
      });
    }
  }
//Time
  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay _selTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
      builder: (context, child){
        return SingleChildScrollView(child: child,);

      }
    );
    if(_selTime != null)
    {
      setState(() {
        _currentTime = _selTime;
        _timeValue =formatTimeOfDay(_currentTime);
      });
    }
  }


  //formating the time
  String formatTimeOfDay(TimeOfDay tod){
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

/************* VALIDATION AND SAVING IN DATABAE***************************************************/ 
  bool validateAndSave(){
    final form= formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }


/******************************* uplading the Image to storage *************************************/ 
  uploadStatus() async 
  {
    if(validateAndSave()){
      final StorageReference postImageRef =FirebaseStorage.instance.ref().child("Post Image");
      final StorageReference postFileRef = FirebaseStorage.instance.ref().child("Post File");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTaskImage = postImageRef.child("$EventName.jpg").putFile(sampleImage);
      StorageTaskSnapshot taskSnapshotImage = await uploadTaskImage.onComplete;
     
      final StorageUploadTask uploadTaskFile = postFileRef.child("$EventName.pdf").putFile(pdfFile);
      StorageTaskSnapshot taskSnapshotFile = await uploadTaskFile.onComplete;
     
      setState(() {
        print("uploaded");
      });
      var ImageUrl = await(await uploadTaskImage.onComplete).ref.getDownloadURL();
      _imgUrl = ImageUrl.toString();
      var fUrl = await(await uploadTaskFile.onComplete).ref.getDownloadURL();
      _fileUrl = fUrl.toString();
      print(_imgUrl);
      saveToDatabase(_imgUrl,_fileUrl);
      goToHomepage();
    }
  }
    /*******************************************sAVING DATA TO DATABASE*************************************************/ 
    saveToDatabase(imageUrl, fileUrl){
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      DocumentReference documentReference =Firestore.instance.collection("EventCollections").document(EventName);
      Map<String,dynamic> eventDetails = {
      "EventName" : EventName,
      "Venue" : _venuActivity,
      "EventDate" : _dateValue,
      "EventTime" : _timeValue,
      "OrganizedBy" : _organiser,
      "OrganizerEmailid" : _emialId,
      "Department" : _departmentActivity,
      
      "ImageUrl" : imageUrl,
      "FileUrl"  : fileUrl,
      "Description" : _description,
      "VerificationList": verification,
      
     };
     documentReference.setData(eventDetails).whenComplete(() {
      print("$EventName created************");
      });
     }
     void goToHomepage(){
       showDialog(
         context: context,
         builder:(BuildContext context){
           return(AlertDialog(
             title: Text("Submission"),
             content: Text("Form is Submited"),
             actions: [
               FlatButton(
                 child: Text("close"),
                 onPressed: (){
                   Navigator.of(context).pop();
                 },
               )
            ],
          ));
         }
       );
       Navigator.pop(context);
       Navigator.pop(context);
     }
  @override
  Widget build(BuildContext context) {
    String _formatedDate = new DateFormat.yMMMd().format(_currentDate);
    _dateValue = _formatedDate;
    print('$_dateValue');
    return Scaffold(
      backgroundColor: Colors.teal.shade100,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title:Text(
            'EVENT FORM',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 25.0, right: 12.0, left: 12.0),
            child: Card(
              margin: EdgeInsets.only(top: 25.0),
              elevation: 15.0,
              shape: RoundedRectangleBorder(
                  borderRadius:BorderRadius.circular(20.0)
              ),
              color: Colors.white,
              child: Center(
                  child: Form(
                    key: formKey,
                    child:Column(

                      children: <Widget>[
                        /* EVENT NAME --- TEXT FORMAT */
                        Container(
                          padding: EdgeInsets.only(bottom:10.0,top:15.0,left:15.0,right:15.0),
                          child: Text(
                            'Event Name :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
                          child : TextFormField(
                            decoration: new InputDecoration(
                              fillColor: Colors.teal[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.teal[100],
                                  width: 5.0,
                                ),

                              ),
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'Event name is Required';
                              }
                              else{
                                return null;
                              }
                            },
                            onSaved: (value){
                              return EventName = value;
                            },
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),

                        /*VENUE --- DROPDOWN LIST TO CHOICE*/

                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Venue :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom:20.0,right: 25.0,left: 10.0),
                          child: DropDownFormField(
                            titleText:null,
                            hintText: 'Choose Avaliable venue',
                            value: _venuActivity,
                            onSaved:(value){
                              setState((){
                                _venuActivity=value;
                              });
                            },
                            onChanged:(value){
                              setState((){
                                _venuActivity=value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "Ground-Floor Seminar Hall",
                                "value": "Ground-Floor Seminar Hall",
                              },
                              {
                                "display": "First-Floor Seminar Hall",
                                "value": "First-Floor Seminar Hall",
                              },
                              {
                                "display": "Second-Floor Seminar Hall",
                                "value": "Second-Floor Seminar Hall",
                              },
                              {
                                "display": "Netravati hall",
                                "value": "Netravati hall",
                              },
                              {
                                "display": "Main Auditorium",
                                "value": "Main Auditorium",
                              },
                              {
                                "display": "Class Room",
                                "value": "Class Room",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),

                        /*DATE --- DATE PICKER*/
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Pick Date :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:<Widget>[
                            Container(
                              child: FloatingActionButton(
                                // onPressed: null,
                                backgroundColor: Colors.teal,
                                tooltip: 'Add Date',
                                child: new Icon(Icons.date_range),
                                onPressed:(){
                                  _selectdate(context);

                                },
                              ),
                            ),
                            Text("  $_formatedDate  "),
                            SizedBox(
                              width:3.0,
                            ),
                            
                            Container(
                              child: FloatingActionButton(
                                onPressed: (){
                                  _selectTime(context);
                                },
                                backgroundColor: Colors.teal,
                                tooltip: 'Add Time',
                                child: new Icon(Icons.access_time),
                              ),
                            ),
                            Text("  $_timeValue ")
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),

                        /*  DETAILS OF THE PRESON WHO IS  WHO IS CONDUCTING EVENT --- TEXT FORMAT*/
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Presonal Details :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),


                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Name :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
                          child : TextFormField(
                            decoration: new InputDecoration(
                              fillColor: Colors.teal[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.teal[100],
                                  width: 5.0,
                                ),
                              ),
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return 'Your Name is Requried';
                              }
                              else{
                                return null;
                              }
                            },
                            onSaved: (value) {
                              return _organiser = value;
                            },

                          ),
                        ),


                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Email ID :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
                          child : TextFormField(
                            decoration: new InputDecoration(
                              fillColor: Colors.teal[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.teal[100],
                                  width: 5.0,
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
                        ),

                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Department :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
//                    Container(
//                      padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
//                      child : TextFormField(
//                        decoration: new InputDecoration(
//                          fillColor: Colors.teal[100],
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(10.0),
//                            borderSide: BorderSide(
//                              color: Colors.teal[100],
//                              width: 5.0,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
                        Container(
                          padding: EdgeInsets.only(bottom:20.0,right: 25.0,left: 10.0),
                          child: DropDownFormField(
                            hintText: 'Select',
                            titleText: null,
                            value: _departmentActivity,
                            onSaved:(value){
                              setState((){
                                _departmentActivity=value;
                              });
                            },
                            onChanged:(value){
                              setState((){
                                _departmentActivity=value;
                              });
                            },
                            dataSource: [
                              {
                                "display": "CSE",
                                "value": "CSE",
                              },
                              {
                                "display": "CIVIL",
                                "value": "CIVIL",
                              },
                              {
                                "display": "MECH",
                                "value": "MECH",
                              },
                              {
                                "display": "EC",
                                "value": "EC",
                              },
                              {
                                "display": "MBA",
                                "value": "MBA",
                              },
                              {
                                "display": "CHEMISTRY",
                                "value": "CHEMISTRY",
                              },
                              {
                                "display": "PHYSICS",
                                "value": "PHYSICS",
                              },
                              {
                                "display": "MATHS",
                                "value": "MATHS",
                              },

                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Designation :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
//                    Container(
//                      padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
//                      child : TextFormField(
//                        decoration: new InputDecoration(
//                          fillColor: Colors.teal[100],
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(10.0),
//                            borderSide: BorderSide(
//                              color: Colors.teal[100],
//                              width: 5.0,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
                        Container(
                          padding: EdgeInsets.only(bottom:20.0,right: 25.0,left: 10.0),
                          child: DropDownFormField(
                            hintText: 'Select',
                            titleText: null,

                            value: _designationActivity,
                            onSaved:(value){
                              setState((){
                                _designationActivity=value;
                              });
                            },
                            onChanged:(value){
                              setState((){
                                _designationActivity=value;
                              });
                            },

                            dataSource: [
                              {
                                "display": "STUDENT",
                                "value": "STUDENT",
                              },
                              {
                                "display": "FACULTY",
                                "value": "FACULTY",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),

                        /* DETAILED PDF OF THE EVENT --- TO CHOOSE THE DOCUMENT */

                        Container(
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Event letter :',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  width:3.0,
                                ),
                                Text(
                                  '(in pdf form with eventname.pdf)',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color:  Colors.black54,
                                  ),
                                )
                              ],
                            )
                        ),
                        Container(
                          child: FloatingActionButton(
                            onPressed: getPdf,
                            backgroundColor: Colors.teal,
                            tooltip: 'Add file',
                            child: new Icon(Icons.file_upload),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(8.0),
                            child: pdfFile==null?
                            Center(
                              child: Text("Select pdf"),
                            ):
                            Center(
                              child: Text("Selected pdf $pdfFile"),
                            )
                        ),
                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),


                        /*ADDING EVENT POSTER --- IMAGE FROM GALARY*/
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Add Event Poster :',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                width:5.0,
                              ),
                              Container(
                                child: FloatingActionButton(
                                  onPressed: getImage,
                                  backgroundColor: Colors.teal,
                                  tooltip: 'Add image',
                                  child: new Icon(Icons.add_a_photo),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child:sampleImage==null?
                          Center(
                            child: Text("SELECT AN IMAGE OF EVENT"),
                          ):
                          Container(
                            child: Image.file(sampleImage,height: 30.0,width: 250.0,),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width,//pixel
                          child: Divider(
                            color: Colors.black54,
                          ),),


                        /* DESCRIPTION*/
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Event Description :',
                            style: TextStyle(
//                      fontFamily: 'Pacifico',
                              fontSize: 20.0,
                              color: Colors.black54,
//                      fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top:5.0,bottom:15.0,left:25.0,right:25.0),
                          child : TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: new InputDecoration(
                              fillColor: Colors.teal[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.teal[100],
                                  width: 5.0,
                                ),
                              ),
                            ),
                            onSubmitted: (val){
                              return _description = val;
                            },
                            onChanged: (value){
                              return _description = value;
                            },
                          ),
                        ),


                        /*SUBMIT BUTTON --- RASIEDBUTTON*/
                        Padding(
                          padding:EdgeInsets.only(top:5.0,bottom: 5.0,right:5.0,left:5.0),
                          child: FlatButton(
                              onPressed:(){
                                uploadStatus();
                              },

                              child:Text("Submit",
                                style: TextStyle(
                                  color: Colors.teal,
                                ),
                              ),

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color:Colors.teal,
                                  )
                              )
                          ),
                        ),

                      ],
                    ),
                  )
              ),
            )
        ),
      ),
    );
  }
}
