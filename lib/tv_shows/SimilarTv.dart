import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/TvDetailsPage.dart';

class SimilarTv extends StatefulWidget {
  final String movieId;

  SimilarTv({
    this.movieId,
  });
  @override
  _SimilarTvState createState() => _SimilarTvState();
}

class _SimilarTvState extends State<SimilarTv> {
  var apiKey = "3926dff0d2826b265d5396981f90bd1c";
  var baseUrl = "https://image.tmdb.org/t/p/w500";

  Future<dynamic> getSimilarMovies() async{
    String link = "http://api.themoviedb.org/3/tv/"+widget.movieId+"/similar?api_key=3926dff0d2826b265d5396981f90bd1c";
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
        child: Column(
          children: <Widget>[
            SizedBox(height: SizeConfig.blockSizeVertical*4),
            Container(
              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*4, right:SizeConfig.blockSizeHorizontal*4),
              alignment: Alignment.topLeft,
              child: Text(
                "Similar TV Shows ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeVertical*4
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*3,),
            FutureBuilder(
                future: getSimilarMovies(),
                builder:(BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return SizedBox(
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
                                    width: SizeConfig.blockSizeHorizontal*50,
                                    child: Column(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                                          child: snapshot.data[i]["poster_path"] == null ?
                                              Container(
                                                  width: SizeConfig.blockSizeHorizontal*35,
                                                  height: SizeConfig.blockSizeVertical*25,
                                                  color: Colors.white,
                                              ):
                                            Image(
                                              image: NetworkImage(baseUrl+snapshot.data[i]["poster_path"]),
                                              fit: BoxFit.contain,
                                              height: SizeConfig.blockSizeVertical*30,
                                            ),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical*1,),
                                        Padding(
                                          padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical*5, right: SizeConfig.blockSizeVertical*5),
                                          child: Text(
                                            snapshot.data[i]["original_name"],
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
                    );
                  }
                  return CupertinoActivityIndicator();
                }
            ),
          ],
        )
    );
  }
}
