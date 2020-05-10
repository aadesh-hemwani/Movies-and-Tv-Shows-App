import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:movie/size_config/size_config.dart';


class SeasonDetails extends StatelessWidget {
  final String poster, seasonNo, showId;
  final baseUrl = "https://image.tmdb.org/t/p/w500";
  final apiKey = "3926dff0d2826b265d5396981f90bd1c";

  SeasonDetails({this.poster, this.seasonNo, this.showId});

  Future<dynamic> getSeasonDetails() async {
    String link = "http://api.themoviedb.org/3/tv/" +
        showId +
        "/season/" +
        seasonNo +
        "?api_key=" +
        apiKey;
    var response = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var episodes = data["episodes"];
      return episodes;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        middle: Text("Season "+seasonNo),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            height: SizeConfig.blockSizeVertical * 100,
            child: poster == null
                ? Container(
                    width: double.infinity,
                    height: 500,
                    color: Theme.of(context).accentColor,
                  )
                : Image(
                    image: NetworkImage(baseUrl + poster),
                    height: SizeConfig.blockSizeVertical * 100,
                    fit: BoxFit.cover,
                  ),
          ),
          Container(
              height: SizeConfig.blockSizeVertical * 100,
              width: SizeConfig.blockSizeHorizontal * 100,
              child: ClipRRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Color.fromRGBO(31, 31, 31, 1).withOpacity(0.5),
                    ),
                  ),
                ),
              )),
          SingleChildScrollView(
            child: FutureBuilder(
              future: getSeasonDetails(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                    return Column(
                      children: <Widget>[
                        Container(
                          height: SizeConfig.blockSizeVertical*100,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i){
                                return Padding(
                                  padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*1),
                                    ),
                                    color: Colors.black.withOpacity(.5),
                                    elevation: 0,
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*1),
                                          child: Container(
                                            child: snapshot.data[i]["still_path"] != null ?
                                            Image(
                                              image: NetworkImage(baseUrl+snapshot.data[i]["still_path"]),
                                            ) :
                                            Container(
                                              height: SizeConfig.blockSizeVertical*26,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: SizeConfig.blockSizeHorizontal*100,
                                          height: 100,
                                          padding: EdgeInsets.only(left:10, top: 10, right:40),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*1),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Colors.black.withOpacity(.7), Colors.transparent]
                                            )
                                          ),
                                          child: Text(
                                            "Ep."+(i+1).toString()+": "+snapshot.data[i]["name"],
                                            style: TextStyle(
                                                fontSize: SizeConfig.blockSizeVertical*3.5,
                                                color: Colors.white,
                                              fontFamily: 'Google-Sans',
                                            ),
                                          ),
                                        ),
                                        Theme(
                                          data: ThemeData(
                                            accentColor: Colors.white,
                                            unselectedWidgetColor: Colors.white,
                                          ),
                                          child: ExpansionTile(
                                            title: SizedBox(
                                                width: double.infinity,
                                                child: SizedBox(height: SizeConfig.blockSizeVertical*24.7,)
                                            ),
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
                                                child: Text(snapshot.data[i]["overview"],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig.blockSizeVertical*2.5,
                                                      color: Colors.white,
                                                      fontFamily: 'Google-Sans',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                );
                              }
                          ),
                        ),
                      ],
                    );
                }
                return Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*50,),
                    CupertinoActivityIndicator(

                      radius: SizeConfig.blockSizeVertical*2,
                    ),
                  ],
                );
              },
            )
          )
        ],
      ),
    );
  }
}
