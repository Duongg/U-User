import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:u_user/assistants/request_assistant.dart';
import 'package:u_user/global/global.dart';
import 'package:u_user/infoHandler/app_info.dart';
import 'package:u_user/model/direction_details_info.dart';
import 'package:u_user/model/user_model.dart';

import '../global/map_key.dart';
import '../model/directions.dart';

class AssistantMethods{
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async{
    String urlAPI =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.longitude},${position.latitude}&key=${mapKey}";
    String humanAddress = "";
    var requestResponse = await RequestAssistant.receiveRequest(urlAPI);
    if (requestResponse != "Error Occurred, Failed. No response.") {
      humanAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

    }
    return humanAddress;
  }
  static void readCurrentOnlineUserInfo() async{
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);
    userRef.once().then((snap) {
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapShot(snap.snapshot);
        print("name" + userModelCurrentInfo!.name.toString());
      }
    });
  }
  static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No response."){
      return null;
    }
      DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
      directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

      directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"]["distance"]["text"];
      directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"]["distance"]["value"];

      directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"]["duration"]["value"];
      directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"]["duration"]["value"];

      return directionDetailsInfo;

  }
}