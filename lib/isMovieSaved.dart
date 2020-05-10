import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/db/database_provider.dart';
import 'package:movie/movies/movie_details.dart';

class IsSaved extends StatelessWidget {
  var savedMovies = <String, String> {};
  @override
  Widget Mov(BuildContext context) {
    var db = DatabaseHelper();
    return FutureBuilder(
      future: db.getMovie(),
      builder: (context, snap){
        if(snap.hasData){
          for(int i=0; i<snap.data.length; i++){
            print(snap.data[i].title);
            savedMovies[snap.data[i].title] = snap.data[i].poster;
          }
        }
        return Container();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
