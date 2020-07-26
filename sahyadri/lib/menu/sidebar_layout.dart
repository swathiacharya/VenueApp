import 'package:flutter/material.dart';
import 'package:sahyadri/menu/sidebar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sahyadri/bloc_navigation/navigation_bloc.dart';






class SideBarLayout extends StatefulWidget {
  SideBarLayout({Key key, this.title, this.uid}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid;


  @override
  _SideBarLayoutState createState() => _SideBarLayoutState();
}

class _SideBarLayoutState extends State<SideBarLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context)=>NavigationBloc(),
        child: Stack(
          children: [
            BlocBuilder<NavigationBloc,NavigationStates>(
              builder: (context,navigationState)
              {
                return navigationState as Widget;
              },

            ),
            SideBar(),
          ],
        ),
      ),
    );
  }
}