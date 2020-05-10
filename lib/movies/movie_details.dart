import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie/db/database_provider.dart';
import 'package:movie/model/movies_model.dart';
import 'package:movie/movies/similarMovies.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/isMovieSaved.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MovieDetails extends StatefulWidget {
  final String description, backdrop, poster, title, releaseDate, vote, id;
  final Map movies;

  MovieDetails(
      {this.description,
      this.backdrop,
      this.poster,
      this.title,
      this.releaseDate,
      this.vote,
      this.id,
      this.movies,
      });

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final baseUrl = "https://image.tmdb.org/t/p/w500";
  final apiKey = "3926dff0d2826b265d5396981f90bd1c";
  var mov = <String, String> {};
  var db = DatabaseHelper();

  Future<dynamic> getMovieCast() async {
    String link = "http://api.themoviedb.org/3/movie/" + widget.id + "/credits?api_key=" + apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var cast = data["cast"] as List;
      return cast;
    }
  }

  Future<String> getVideoKey() async {
    String link = "http://api.themoviedb.org/3/movie/" + widget.id + "/videos?api_key=" + apiKey;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var list = data["results"] as List;
      var key = list[0]["key"];
      return key;
    }
    return null;
  }

  Future saveMovie() async{
    var movie = new Movie(widget.title, widget.releaseDate.substring(0, 4), widget.vote, widget.description, widget.poster);
    var db = new DatabaseHelper();
    await db.saveMovie(movie);
  }

  void initState(){
    super.initState();
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
          height: SizeConfig.blockSizeVertical * 100,
          child: widget.poster == null
              ? Container(
                  width: double.infinity,
                  height: 500,
                  color: Theme.of(context).accentColor,
                )
              : CachedNetworkImage(
                  imageUrl: baseUrl + widget.poster,
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
                      color: Color.fromRGBO(31, 31, 31, 1).withOpacity(0.5)),
                ),
              ),
            )),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: SizeConfig.blockSizeVertical * 6,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.blockSizeVertical * 1)),
                    child: Container(
                      height: SizeConfig.blockSizeVertical * 60,
                      child: widget.poster == null
                          ? Container(
                              width: SizeConfig.blockSizeHorizontal * 80,
                              height: SizeConfig.blockSizeVertical * 50,
                              color: Colors.white,
                            )
                          : CachedNetworkImage(
                              imageUrl: baseUrl + widget.poster,
                              height: SizeConfig.blockSizeVertical * 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  FutureBuilder(
                    future: getVideoKey(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(
                                      "https://m.youtube.com/watch?v=" +
                                          snap.data)) {
                                    await launch(
                                        "https://m.youtube.com/watch?v=" +
                                            snap.data);
                                  }
                                },
                                child: Icon(
                                  MdiIcons.youtube,
                                  color: Colors.red,
                                  size: SizeConfig.blockSizeVertical * 5,
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
              SizedBox(height: SizeConfig.blockSizeVertical * 3),
              Card(
                color: Colors.transparent,
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.blockSizeHorizontal*80,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical * 4,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FutureBuilder(
                      future: db.getMovie(),
                      builder: (context, snapshot){
                        bool isThere = false;
                        int currentMovie;
                        if(snapshot.hasData){
                          for(int i=0; i< snapshot.data.length; i++){
                            if(widget.title == snapshot.data[i].title){
                              currentMovie = i;
                              isThere = true;
                              break;
                            }
                          }
                          return isThere ?
                          IconButton(
                            icon: Icon(MdiIcons.deleteForever, color: Colors.white,size: SizeConfig.blockSizeVertical*3,),
                            onPressed: (){
                              db.deleteMovie(snapshot.data[currentMovie]);
                              setState(() {
                              });
                            },
                          )
                          : IconButton(
                            icon: Icon(MdiIcons.cloudDownload, color: Colors.white,size: SizeConfig.blockSizeVertical*3,),
                            onPressed: (){
                              saveMovie();
                              setState(() {
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4),
                      child: Text(
                        "Rating : " + widget.vote,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical * 2),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 4,
                          right: SizeConfig.blockSizeHorizontal * 4),
                      child: Text(
                        "Year : " + widget.releaseDate,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical * 2),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 4),
              Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 4,
                    right: SizeConfig.blockSizeHorizontal * 4),
                child: Text(
                  widget.description,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.blockSizeVertical * 2),
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 4),
              FutureBuilder(
                future: getMovieCast(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 4,
                              right: SizeConfig.blockSizeHorizontal * 4),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Cast ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical * 4),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: SizeConfig.blockSizeVertical * 35,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                    padding: EdgeInsets.all(
                                        SizeConfig.blockSizeVertical * 2),
                                    child: Container(
                                      width: SizeConfig.blockSizeHorizontal * 40,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(SizeConfig
                                                            .blockSizeVertical *
                                                        0.5)),
                                                child: snapshot.data[i]
                                                            ["profile_path"] ==
                                                        null
                                                    ? Image(
                                                        image: NetworkImage(
                                                            "https://www.searchpng.com/wp-content/uploads/2019/02/Men-Profile-Image-715x657.png"),
                                                        height: SizeConfig
                                                                .blockSizeVertical *
                                                            20,
                                                      )
                                                    : Image(
                                                        image: NetworkImage(baseUrl +
                                                            snapshot.data[i]
                                                                ["profile_path"]),
                                                        height: SizeConfig
                                                                .blockSizeVertical *
                                                            20,
                                                      )),
                                          ),
                                          SizedBox(
                                            height:
                                                SizeConfig.blockSizeVertical * 1,
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left:
                                                    SizeConfig.blockSizeHorizontal *
                                                        1,
                                                right:
                                                    SizeConfig.blockSizeHorizontal *
                                                        1),
                                            child: Text(
                                              snapshot.data[i]["name"],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.blockSizeVertical *
                                                          1.8,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left:
                                                    SizeConfig.blockSizeHorizontal *
                                                        1,
                                                right:
                                                    SizeConfig.blockSizeHorizontal *
                                                        1),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "( " +
                                                  snapshot.data[i]["character"] +
                                                  " )",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.blockSizeVertical *
                                                          1.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              SimilarMovies(
                movieId: widget.id,
              )
            ],
          ),
        )
      ],
    ));
  }
}
