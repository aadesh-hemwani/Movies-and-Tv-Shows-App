import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/season_details.dart';

class Seasons extends StatelessWidget {
  final String showId;

  Seasons({
    this.showId
  });

  final baseUrl = "https://image.tmdb.org/t/p/w500";
  final apiKey = "3926dff0d2826b265d5396981f90bd1c";

  Future<dynamic> getAdditionalDetails() async {
    String link = "http://api.themoviedb.org/3/tv/"+showId+"?api_key="+apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      print(data["seasons"]);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FutureBuilder(
      future: getAdditionalDetails(),
      builder: (context, snapshot){
        if(snapshot.hasData){

          var seasons = snapshot.data["seasons"];
          var items = seasons.length;
          if(seasons[0]["name"] == "Specials") {
              var i = 1;
              items = items-1;
          }
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                alignment: Alignment.topLeft,
                child: Text(
                  "Seasons ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.blockSizeVertical*4
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical*3,),
              Container(
                height: SizeConfig.blockSizeVertical*40,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items,
                    itemBuilder: (context, i){
                      if(seasons[0]["name"] == "Specials") {
                        i++;
                      }
                        return Container(
                          width: SizeConfig.blockSizeHorizontal*50,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => SeasonDetails(
                                      poster: seasons[i]["poster_path"],
                                      seasonNo: seasons[i]["name"].substring(7),
                                      showId: showId,
                                    ),
                                  )
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                                      child: seasons[i]["poster_path"] == null ?
                                      Container(
                                        width: SizeConfig.blockSizeHorizontal*41,
                                        height: SizeConfig.blockSizeVertical*45,
                                        color: Colors.white,
                                      ):
                                      Image(
                                        image: NetworkImage(baseUrl+seasons[i]["poster_path"]),
                                        fit: BoxFit.contain,
                                        height: SizeConfig.blockSizeVertical*30,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(SizeConfig.blockSizeVertical*1),
                                            ),
                                            color: Colors.black.withOpacity(0.5),
                                        ),
                                        padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                                        child: Text(
                                            seasons[i]["episode_count"].toString()+" Episodes",
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeVertical*2,
                                            ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                Padding(
                                  padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical*5, right: SizeConfig.blockSizeVertical*5),
                                  child: Text(
                                    seasons[i]["name"],
                                    style: TextStyle(
                                      fontSize: SizeConfig.blockSizeHorizontal*4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                    }
        ),
              ),
            ],
          );
        }
        return CupertinoActivityIndicator();
      },
    );
  }
}
