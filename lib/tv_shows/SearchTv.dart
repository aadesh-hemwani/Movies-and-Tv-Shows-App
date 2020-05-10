import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/TvDetailsPage.dart';

class SearchTv extends StatefulWidget {
  final String searchVal;

  SearchTv({
    this.searchVal,
  });

  @override
  _SearchTvState createState() => _SearchTvState();
}

class _SearchTvState extends State<SearchTv> {
  var listLength = 0;
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getSearchedMovies() async{
    String link = "https://api.themoviedb.org/3/search/tv?api_key=3926dff0d2826b265d5396981f90bd1c&query="+widget.searchVal;
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      listLength = movies.length-1;
      return movies;
    }
  }
  void initState(){
    super.initState();
    getSearchedMovies();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    getSearchedMovies();
    return CupertinoPageScaffold(
      navigationBar:  CupertinoNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.1),
        middle: Text(widget.searchVal, style: TextStyle(color: Colors.white),),
      ),
      child: FutureBuilder(
          future: getSearchedMovies(),
          builder:(BuildContext context, snapshot){
            if(snapshot.hasData){
              return GridView.count(
                crossAxisCount: 2,
                childAspectRatio: (SizeConfig.blockSizeHorizontal/SizeConfig.blockSizeVertical),
                children: List.generate(listLength, (i) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                        CupertinoPageRoute(
                          builder: (_) => TvDetails(
                            description: snapshot.data[i]["overview"],
                            backdrop: snapshot.data[i]["backdrop_path"],
                            poster: snapshot.data[i]["poster_path"],
                            title: snapshot.data[i]["original_name"],
                            releaseDate: snapshot.data[i]["first_air_date"],
                            vote: snapshot.data[i]["vote_average"].toString(),
                            id: snapshot.data[i]["id"].toString(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                              child: snapshot.data[i]["poster_path"] == null ?
                              Image(
                                image: NetworkImage("https://i.pinimg.com/736x/38/6e/c3/386ec3fa8240ced20078d1f39600b1e5.jpg"),
                              ) :
                              Image(
                                image: NetworkImage(baseUrl+snapshot.data[i]["poster_path"]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical*2, right: SizeConfig.blockSizeVertical*1),
                            child: Text(
                              snapshot.data[i]["original_name"],
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal*4,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }
            return Center(child: CupertinoActivityIndicator(radius: SizeConfig.blockSizeVertical*2, animating: true,));
          }
      ),
    );
  }
}
