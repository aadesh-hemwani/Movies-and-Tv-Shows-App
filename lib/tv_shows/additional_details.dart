import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/size_config/size_config.dart';

class AdditionalDetails extends StatelessWidget {
  final String showId;

  AdditionalDetails({
    this.showId
  });

  final baseUrl = "https://image.tmdb.org/t/p/w500";
  final apiKey = "3926dff0d2826b265d5396981f90bd1c";

  Future<dynamic> getAdditionalDetails() async {
    String link = "http://api.themoviedb.org/3/tv/"+showId+"?api_key="+apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getAdditionalDetails(),
        builder: (context, snap){
          if(snap.hasData){
            return Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                        child: Text(
                          "Status : " + snap.data["status"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeVertical*2
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                        child: Text(
                          snap.data["origin_country"].length != 0 ?
                          "Origin : " + snap.data["origin_country"][0] :
                          "Origin : not available",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeVertical*2
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*1),
                if(snap.data["genres"].length != 0)
                  getGenres(snap.data["genres"])
              ],
            );
          }
          return Container();
        },
      ),
    );
  }


  getGenres(List genre){
    if(genre.length != 0){
      return Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
        child: Wrap(
          spacing: 20,
          runSpacing: 10,
          children: <Widget>[
            for(var genre in genre)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Padding(
                  padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                  child: Text(
                    genre["name"],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.blockSizeVertical*2,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            SizedBox(width: SizeConfig.blockSizeHorizontal*10,)
          ],
        ),
      );
    }
  }
}
