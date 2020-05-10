import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/SimilarTv.dart';
import 'package:movie/tv_shows/additional_details.dart';
import 'package:movie/tv_shows/seasons.dart';
import 'package:url_launcher/url_launcher.dart';


class TvDetails extends StatefulWidget {
  final String description, backdrop, poster, title, releaseDate, vote, id;

  TvDetails({
    this.description,
    this.backdrop,
    this.poster,
    this.title,
    this.releaseDate,
    this.vote,
    this.id
  });

  @override
  _TvDetailsState createState() => _TvDetailsState();
}

class _TvDetailsState extends State<TvDetails> {
  final baseUrl = "https://image.tmdb.org/t/p/w500";
  final apiKey = "3926dff0d2826b265d5396981f90bd1c";

  Future<dynamic> getMovieCast() async{
    String link = "http://api.themoviedb.org/3/tv/"+widget.id+"/credits?api_key="+apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var cast = data["cast"] as List;
      return cast;
    }
  }

  Future<String> getVideoKey() async {
    String link = "http://api.themoviedb.org/3/tv/"+widget.id+"/videos?api_key="+apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var list = data["results"] as List;
      var key = list[0]["key"];
      return key;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CupertinoPageScaffold(
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical*100,
              child: widget.poster == null ?
              Container(
                width: double.infinity,
                height: 500,
                color: Theme.of(context).accentColor,
              ) :
              Image(
                image: NetworkImage(baseUrl+widget.poster),
                height: SizeConfig.blockSizeVertical*100,
                fit: BoxFit.cover,
              ),
            ),

            Container(
                height: SizeConfig.blockSizeVertical*100,
                width: SizeConfig.blockSizeHorizontal*100,
                child: ClipRRect(
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(31, 31, 31, 1).withOpacity(0.5)
                      ),
                    ),
                  ),
                )
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.blockSizeVertical*6,),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                        child: Container(
                          height: SizeConfig.blockSizeVertical*60,
                          child: widget.poster == null ?
                          Container(
                            width: SizeConfig.blockSizeHorizontal*80,
                            height: SizeConfig.blockSizeVertical*50,
                            color: Theme.of(context).accentColor,
                          ) :
                          Image(
                            image: NetworkImage(baseUrl+widget.poster),
                            height: SizeConfig.blockSizeVertical*100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: getVideoKey(),
                        builder: (context, snap){
                          if(snap.hasData){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white24 ,
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (await canLaunch("https://m.youtube.com/watch?v="+snap.data)) {
                                        await launch("https://m.youtube.com/watch?v="+snap.data);
                                      }
                                    },
                                    child:  Icon(
                                      MdiIcons.youtube,
                                      color: Colors.red,
                                      size: SizeConfig.blockSizeVertical*5,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*3),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.blockSizeVertical*4,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*1),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                          child: Text(
                            "Rating : " + widget.vote,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                          child: Text(
                            "Year : " + widget.releaseDate.substring(0, 4),
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
                  AdditionalDetails(showId: widget.id,),
                  SizedBox(height: SizeConfig.blockSizeVertical*3),
                  Container(
                    padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.blockSizeVertical*2
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*4),
                  Seasons(showId: widget.id),
                  FutureBuilder(
                    future: getMovieCast(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Cast ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.blockSizeVertical*4
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: SizeConfig.blockSizeVertical*35,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i){
                                    return Padding(
                                        padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
                                        child: Container(
                                          width: SizeConfig.blockSizeHorizontal*40,
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*0.5)),
                                                    child: snapshot.data[i]["profile_path"] == null ?
                                                    Image(
                                                      image: NetworkImage("https://www.searchpng.com/wp-content/uploads/2019/02/Men-Profile-Image-715x657.png"),
                                                      height: SizeConfig.blockSizeVertical*20,
                                                    ) :
                                                    Image(
                                                      image: NetworkImage(baseUrl+snapshot.data[i]["profile_path"]),
                                                      height: SizeConfig.blockSizeVertical*20,
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                              Container(
                                                padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*1, right:SizeConfig.blockSizeHorizontal*1 ),
                                                child: Text(
                                                  snapshot.data[i]["name"],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.blockSizeVertical*1.8,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal*1, right:SizeConfig.blockSizeHorizontal*1 ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "( "+snapshot.data[i]["character"]+" )",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: SizeConfig.blockSizeVertical*1.8
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    );
                                  }
                              ),
                            ),
                          ],
                        );
                      }
                      return Text("Cast Information not Available");
                    },
                  ),
                  SimilarTv(movieId: widget.id,)
                ],
              ),
            )
          ],
        )
    );
  }
}