//for click listner

import 'package:bloc/bloc.dart';
import 'package:sahyadri/home_page/main_home_page.dart';
import 'package:sahyadri/avalibility_page/hall_booking.dart';
import 'package:sahyadri/avalibility_page/event_form.dart';
import 'package:sahyadri/home_page/event_description.dart';
enum NavigationEvents{
 HomePageClickedEvent,BookHallClickedEvent,EventFormClickedEvent,EventDescriptionClicked
}
abstract class NavigationStates{}
class NavigationBloc extends Bloc<NavigationEvents , NavigationStates>{
  @override
  // TODO: implement initialState
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    // TODO: implement mapEventToState
    switch(event){
      case NavigationEvents.HomePageClickedEvent:yield HomePage();
      break;
      case NavigationEvents.BookHallClickedEvent:yield VenueBook();
      break;
      case NavigationEvents.EventFormClickedEvent:yield EventFillForm();
      break;
      case NavigationEvents.EventDescriptionClicked:yield EventDescription();
      break;
//      case NavigationEvents.ContactClickedEvent:yield Contacts();
//      break;
//      case NavigationEvents.HelpClickedEvent:yield HelpDetails();
//      break;
    }
  }
}