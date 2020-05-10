import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie/movies/movie_details.dart';
import 'package:movie/size_config/size_config.dart';

class SimilarMovies extends StatefulWidget {
  final String movieId;

  SimilarMovies({
    this.movieId,
  });
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  var apiKey = "3926dff0d2826b265d5396981f90bd1c";
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getSimilarMovies() async{
    String link = "http://api.themoviedb.org/3/movie/"+widget.movieId+"/similar?api_key=3926dff0d2826b265d5396981f90bd1c";
    var response = await http.get(Uri.encodeFull(link), headers: {"Accept": "application/json"});

    if(response.statusCode == 200){
      var data = json.decode(response.body);
      var movies = data["results"] as List;
      return movies;
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: FutureBuilder(
          future: getSimilarMovies(),
          builder:(BuildContext context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data.length != 0){
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Similar Movies ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical*4
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical*1,),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                          height: SizeConfig.blockSizeVertical*40,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder:(BuildContext context, int i){
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
                                    width: SizeConfig.blockSizeHorizontal*50,
                                    child: Column(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                                          child: Image(
                                            image: NetworkImage(baseUrl+snapshot.data[i]["poster_path"]),
                                            fit: BoxFit.contain,
                                            height: SizeConfig.blockSizeVertical*30,
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                        Padding(
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical*5, right: SizeConfig.blockSizeVertical*5),
                                          child: Text(
                                            snapshot.data[i]["title"],
                                            style: TextStyle(
                                              fontSize: SizeConfig.blockSizeHorizontal*3.5,
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
                          )
                      ),
                    ),
                  ],
                );
              }
            }
            return Container();
          }
      )
    );
  }
}
