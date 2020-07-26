
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:sahyadri/avalibility_page/main_avalibility_page.dart';
import 'package:sahyadri/menu/menu_items.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';




class SideBar extends StatefulWidget {
  SideBar({Key key, this.titleSideBar, this.uidSideBar}) : super(key: key); //update this to include the uid in the constructor
  final String titleSideBar;
  final String uidSideBar;
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>  with SingleTickerProviderStateMixin<SideBar> {

//  final bool isSideBarOpened=true;
  AnimationController _animationController;
  final _animationDuration=const Duration(milliseconds:500 );
  //to get the value what stream is having
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenedSink;
  StreamController<bool> isSideBarOpenedStreamController;

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController=AnimationController(vsync: this,duration: _animationDuration);

    isSideBarOpenedStreamController=PublishSubject<bool>();
    isSideBarOpenedStream=isSideBarOpenedStreamController.stream;
    isSideBarOpenedSink=isSideBarOpenedStreamController.sink;

  }
  @override
  void dispose(){
    _animationController.dispose();
    isSideBarOpenedSink.close();
    isSideBarOpenedStreamController.close();
    super.dispose();
  }

  void onIconPressed(){
    //checking the stats of animationcontroller which is closed initial,
    final animationStatus=_animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;//if its opened thn completed
    //
    if (isAnimationCompleted)
      {
        //run in reverse direction
        //wt hapended to sink ===if it is open then we have close sink value will be flse
        isSideBarOpenedSink.add(false);
        _animationController.reverse();

      }
    else{
      //in forward direction
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth=MediaQuery.of(context).size.width;
    return StreamBuilder(

      initialData:false,
      stream: isSideBarOpenedStream,
      builder: (context,isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,


          //if isopened is true the the sidebar will be open else closed
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,//not 0:0 because we have to preserve when it is opened ,when we it is zero wehave change
          //when it is open & isSideBarOpened is flase 0

          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          //if flase the right value will be near left side of screen
          child: Row(

            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(

                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.teal,
                    child:Column(
                      children:<Widget>[
                        SizedBox(height: 90,),
                        MenuItem(
                          icon: Icons.home,
                          title: 'Home',
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
                          },
                        ),

                        Divider(
                          height: 35,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 25,
                          endIndent:25,
                        ),
                        MenuItem(
                          icon: Icons.event_available,
                          title: 'Availability',
                          onTap: (){
                            onIconPressed();
                            onShowBarOpen();
//                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.EventFormClickedEvent);

                          },
                        ),
                        Divider(
                          height: 35,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 25,
                          endIndent:25,
                        ),

                        MenuItem(
                          icon: Icons.contacts,
                          title: 'Contacts',
                          onTap: (){
                            onIconPressed();
//                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ContactClickedEvent);
                          },
                        ),
                        Divider(
                          height: 35,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 25,
                          endIndent:25,
                        ),
                        MenuItem(
                          icon: Icons.help,
                          title: 'Help',
                          onTap: (){
                            onIconPressed();
//                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HelpClickedEvent);
                          },
                        ),
                        Divider(
                          height: 35,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.3),
                          indent: 25,
                          endIndent:25,
                        ),
                        MenuItem(
                          icon: Icons.arrow_back,
                            title: 'LogOut',
                              onTap: () {
                                FirebaseAuth.instance
                                    .signOut()
                                    .then((result) =>
                                        Navigator.pushReplacementNamed(context, "/login"))
                                    .catchError((err) => print(err));
                              },
                    )
                      ],
                    ),
                  ),

              ),
              Align(
                alignment: Alignment(0, -0.91),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomeMenuClipper(),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 35,
                      height: 110,
                      color: Colors.teal,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        //if it in 1st step then it is  in menu or else in closed state
                        color: Colors.tealAccent[100],
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        );
      },



    );
  }
  void onShowBarOpen(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            color: Color(0xFF737373),
            height: 225,
            child: Container(
              child: BuildButtonNavigation(),
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(80),
                    topLeft: const Radius.circular(0),
                )
              ),
            ),
          );
        }
    );

  }

}

class CustomeMenuClipper extends CustomClipper<Path>
{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    Paint paint=Paint();
    paint.color=Colors.white;

    final width=size.width;
    final height=size.height;

    Path path=Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1,height/2-20,width,height/2);
    path.quadraticBezierTo(width+1,height/2+20,10,height-16);
    path.quadraticBezierTo(0,height-8,0,height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}