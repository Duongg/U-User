import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_user/assistants/request_assistant.dart';
import 'package:u_user/global/map_key.dart';
import 'package:u_user/model/directions.dart';
import 'package:u_user/model/predicted_places.dart';
import 'package:u_user/widgets/progress_dialog.dart';

import '../infoHandler/app_info.dart';

class PlacePredictionTileDesign extends StatelessWidget {

  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  getPlaceDirectionDetails(String? placesId, context) async{
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting up Drop off, please wait...",
        ),
    );

    String placeDirectionDetails = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placesId&key=$mapKey";

    var responseApi  = await RequestAssistant.receiveRequest(placeDirectionDetails);

    Navigator.pop(context);

    if(responseApi == "Error Occurred, Failed. No response."){
      return;
    }
    if(responseApi["status"] == "OK"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placesId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      Navigator.pop(context, "obtainedDropoff");


    }


  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          getPlaceDirectionDetails(predictedPlaces!.place_id, context);
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white24,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(
                Icons.add_location,
                color: Colors.grey,
              ),
              const SizedBox(width: 14,),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8,),
                      Text(
                        predictedPlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 2,),
                      Text(
                        predictedPlaces!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
    );
  }
}
