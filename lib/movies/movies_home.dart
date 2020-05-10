import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie/movies/moreMovies.dart';
import 'package:movie/movies/movie_details.dart';
import 'package:movie/movies/search_page.dart';
import 'package:movie/size_config/size_config.dart';

class NewHome extends StatefulWidget {
  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final textController = TextEditingController();
  bool textEmpty = false;

  var apiKey = "3926dff0d2826b265d5396981f90bd1c";
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getPopularMovies() async {
    String link =
        "http://api.themoviedb.org/3/movie/popular?api_key=3926dff0d2826b265d5396981f90bd1c";
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
        "http://api.themoviedb.org/3/movie/now_playing?api_key=3926dff0d2826b265d5396981f90bd1c";
    var response = await http
        .get(Uri.encodeFull(link), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      return movies;
    }
  }

  void searchMovie()  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if(currentFocus.hasPrimaryFocus){
      currentFocus.unfocus();
    }
    textController.text.length == 0
        ? null
        : Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => SearchPage(searchVal: textController.text),
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
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus(disposition: UnfocusDisposition.scope);
          print("Tap");
        },
        child: CupertinoPageScaffold(
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
                                            left:
                                                SizeConfig.blockSizeVertical * 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Latest",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                          .blockSizeVertical *
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
                                                      builder: (_) =>
                                                          MovieDetails(
                                                        description
                                                            : snapshot.data[i]
                                                            ["overview"],
                                                        backdrop: snapshot.data[i]
                                                            ["backdrop_path"],
                                                        poster: snapshot.data[i]
                                                            ["poster_path"],
                                                        title: snapshot.data[i]
                                                            ["title"],
                                                        releaseDate:
                                                            snapshot.data[i]
                                                                ["release_date"],
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
                                                        child: snapshot.data[i][
                                                                    "backdrop_path"] ==
                                                                null
                                                            ? Container(
                                                                height: SizeConfig
                                                                        .blockSizeVertical *
                                                                    30,
                                                                width: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    90,
                                                                color:
                                                                    Colors.white,
                                                                child:
                                                                    CupertinoActivityIndicator(
                                                                  radius: SizeConfig
                                                                          .blockSizeVertical *
                                                                      2,
                                                                ),
                                                              )
                                                            : Image(
                                                                image: NetworkImage(
                                                                    baseUrl +
                                                                        snapshot.data[
                                                                                i]
                                                                            [
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
                                                              ["title"],
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
                                            left:
                                                SizeConfig.blockSizeVertical * 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "POPULAR",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                          .blockSizeVertical *
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
                                          height:
                                              SizeConfig.blockSizeVertical * 40,
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
                                                        builder: (_) =>
                                                            MovieDetails(
                                                          description:
                                                              snapshot.data[i]
                                                                  ["overview"],
                                                          backdrop: snapshot
                                                                  .data[i]
                                                              ["backdrop_path"],
                                                          poster: snapshot.data[i]
                                                              ["poster_path"],
                                                          title: snapshot.data[i]
                                                              ["title"],
                                                          releaseDate: snapshot
                                                                  .data[i]
                                                              ["release_date"],
                                                          vote: snapshot.data[i]
                                                                  ["vote_average"]
                                                              .toString(),
                                                          id: snapshot.data[i]
                                                                  ["id"]
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
                                                          child: Image(
                                                            image: NetworkImage(
                                                                baseUrl +
                                                                    snapshot.data[
                                                                            i][
                                                                        "poster_path"]),
                                                            fit: BoxFit.contain,
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
                                                                ["title"],
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
                      MoreMovies(),
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
                    bottomLeft:
                        Radius.circular(SizeConfig.blockSizeVertical * 1.5),
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
                              cursorColor:
                                  Colors.black, //Theme.of(context).primaryColor,
                              enableSuggestions: true,
                              onEditingComplete: searchMovie,
                              autofocus: false,
                              controller: textController,
                              autocorrect: true,
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeVertical * 2.2,
                                  color: Colors.black),
                              prefix: SizedBox(
                                width: SizeConfig.blockSizeHorizontal * 4,
                              ),
                              placeholder: "Search",
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
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
        ),
      ),
    );
  }
}
