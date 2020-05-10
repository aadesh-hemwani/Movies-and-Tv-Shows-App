import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie/movies/movie_details.dart';
import 'package:movie/size_config/size_config.dart';

class SearchPage extends StatefulWidget {
  final String searchVal;

  SearchPage({
    this.searchVal,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var listLength = 0;
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getSearchedMovies() async{
    String link = "https://api.themoviedb.org/3/search/movie?api_key=3926dff0d2826b265d5396981f90bd1c&query="+widget.searchVal;
    final response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
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
                            builder: (_) => MovieDetails(
                              description: snapshot.data[i]["overview"],
                              backdrop: snapshot.data[i]["backdrop_path"],
                              poster: snapshot.data[i]["poster_path"],
                              title: snapshot.data[i]["title"],
                              releaseDate: snapshot.data[i]["release_date"],
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
                                snapshot.data[i]["title"],
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
      ),
    );
  }
}
