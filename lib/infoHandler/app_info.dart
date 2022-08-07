import 'package:flutter/cupertino.dart';
import 'package:u_user/model/directions.dart';

class AppInfo extends ChangeNotifier{
  Directions? userPickUpLocation, userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress){
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions userDropoffAddress){
    userDropOffLocation = userDropoffAddress;
    notifyListeners();
  }

}