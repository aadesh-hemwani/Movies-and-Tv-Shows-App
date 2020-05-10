import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/MoreTV.dart';
import 'package:movie/tv_shows/SearchTv.dart';
import 'package:movie/tv_shows/TvDetailsPage.dart';

class TvHome extends StatefulWidget {
  @override
  TvHomeState createState() => TvHomeState();
}

class TvHomeState extends State<TvHome> {
  final textController = TextEditingController();
  bool textEmpty = false;

  var apiKey = "3926dff0d2826b265d5396981f90bd1c";
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getPopularMovies() async {
    String link =
        "http://api.themoviedb.org/3/tv/popular?api_key=3926dff0d2826b265d5396981f90bd1c";
    var response = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      return movies;
    }
  }

  Future<dynamic> getNowPlayingMovies() async {
    String link =
        "https://api.themoviedb.org/3/tv/airing_today?api_key=3926dff0d2826b265d5396981f90bd1c&language=en-US&page=1";
    var response = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      return movies;
    }
  }

  void searchMovie() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    setState(() {
      textController.text.isEmpty ? textEmpty = true : textEmpty = false;
    });
    textEmpty
        // ignore: unnecessary_statements
        ? null
        : Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => SearchTv(searchVal: textController.text),
            ),
          );
  }

  Future<void> showCredits(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Made By Aadesh Hemwani"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("OKAY"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        currentFocus.unfocus();
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: SizeConfig.blockSizeVertical * 100,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 22,
                  ),
                  FutureBuilder(
                      future: getPopularMovies(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.blockSizeVertical * 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "POPULAR",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //Text("See all",style: TextStyle(color: Colors.grey, fontSize: SizeConfig.blockSizeVertical*2,),)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    height: SizeConfig.blockSizeVertical * 40,
                                    child: Swiper(
                                        viewportFraction: 0.85,
                                        scale: 0.9,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (_) => TvDetails(
                                                    description: snapshot.data[i]
                                                        ["overview"],
                                                    backdrop: snapshot.data[i]
                                                        ["backdrop_path"],
                                                    poster: snapshot.data[i]
                                                        ["poster_path"],
                                                    title: snapshot.data[i]
                                                        ["original_name"],
                                                    releaseDate:
                                                        snapshot.data[i]
                                                            ["first_air_date"],
                                                    vote: snapshot.data[i]
                                                            ["vote_average"]
                                                        .toString(),
                                                    id: snapshot.data[i]["id"]
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: Column(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            SizeConfig
                                                                    .blockSizeVertical *
                                                                1)),
                                                    child: Image(
                                                      image: NetworkImage(baseUrl +
                                                          snapshot.data[i][
                                                              "backdrop_path"]),
                                                      fit: BoxFit.cover,
                                                      height: SizeConfig
                                                              .blockSizeVertical *
                                                          30,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                            .blockSizeVertical *
                                                        1,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .blockSizeVertical *
                                                            5,
                                                        right: SizeConfig
                                                                .blockSizeVertical *
                                                            5),
                                                    child: Text(
                                                      snapshot.data[i]
                                                          ["original_name"],
                                                      style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            4,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),
                  FutureBuilder(
                      future: getNowPlayingMovies(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.blockSizeVertical * 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "AIRING TODAY",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      3,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        //Text("See all",style: TextStyle(color: Colors.grey, fontSize: SizeConfig.blockSizeVertical*2,),)
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 3,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                      height: SizeConfig.blockSizeVertical * 40,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder:
                                              (BuildContext context, int i) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (_) => TvDetails(
                                                      description: snapshot.data[i]
                                                          ["overview"],
                                                      backdrop: snapshot.data[i]
                                                          ["backdrop_path"],
                                                      poster: snapshot.data[i]
                                                          ["poster_path"],
                                                      title: snapshot.data[i]
                                                          ["original_name"],
                                                      releaseDate: snapshot
                                                              .data[i]
                                                          ["first_air_date"],
                                                      vote: snapshot.data[i]
                                                              ["vote_average"]
                                                          .toString(),
                                                      id: snapshot.data[i]["id"]
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    50,
                                                child: Column(
                                                  children: <Widget>[
                                                    ClipRRect(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                SizeConfig
                                                                        .blockSizeVertical *
                                                                    1)),
                                                        child: snapshot.data[i][
                                                                    "poster_path"] !=
                                                                null
                                                            ? Image(
                                                                image: NetworkImage(
                                                                    baseUrl +
                                                                        snapshot.data[i]["poster_path"]),
                                                                fit: BoxFit.contain,
                                                                height: SizeConfig.blockSizeVertical *
                                                                    30,
                                                              )
                                                            :
                                                            Container(
                                                                width: SizeConfig.blockSizeHorizontal*41,
                                                                height: SizeConfig.blockSizeVertical*30,
                                                                color: Colors.white,
                                                            ),
                                                    ),
                                                    SizedBox(
                                                      height: SizeConfig
                                                              .blockSizeVertical *
                                                          1,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .blockSizeVertical *
                                                              5,
                                                          right: SizeConfig
                                                                  .blockSizeVertical *
                                                              5),
                                                      child: Text(
                                                        snapshot.data[i][
                                                                    "original_name"] !=
                                                                null
                                                            ? snapshot.data[i][
                                                                "original_name"]
                                                            : "",
                                                        style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              3.5,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })),
                                )
                              ],
                            ),
                          );
                        }
                        return CupertinoActivityIndicator(
                          radius: SizeConfig.blockSizeVertical * 2,
                        );
                      }),
                  MoreTv(),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 18,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight:
                    Radius.circular(SizeConfig.blockSizeVertical * 1.5),
                bottomLeft: Radius.circular(SizeConfig.blockSizeVertical * 1.5),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      bottomRight:
                          Radius.circular(SizeConfig.blockSizeVertical * 1.5),
                      bottomLeft:
                          Radius.circular(SizeConfig.blockSizeVertical * 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: SizeConfig.blockSizeVertical * 5,
                        width: SizeConfig.blockSizeHorizontal * 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                        ),
                        child: CupertinoTextField(
                          textInputAction: TextInputAction.search,
                          cursorColor: Colors.black,
                          enableInteractiveSelection: true,
                          enableSuggestions: true,
                          onEditingComplete: searchMovie,
                          autofocus: false,
                          controller: textController,
                          autocorrect: true,
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2.2,
                              color: Colors.black),
                          placeholder: "Search",
                          prefix: SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 4,
                          ),
                          placeholderStyle: TextStyle(color: Colors.black),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all((Radius.circular(50)))),
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          searchMovie();
                        },
                        onDoubleTap: () {
                          showCredits(context);
                        },
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 5,
                          width: SizeConfig.blockSizeHorizontal * 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                            size: SizeConfig.blockSizeVertical * 3.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
