import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/db/database_provider.dart';
import 'package:movie/movies/movie_details.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Offline extends StatefulWidget {
  @override
  _OfflineState createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  var db = new DatabaseHelper();
  final baseUrl = "https://image.tmdb.org/t/p/w500";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: FutureBuilder(
        future: db.getMovie(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var movie = snapshot.data;
            return snapshot.data.length == 0
                ? Center(
                    child: Text("No Movies Saved Yet !",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical * 2)))
                : Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*5,),
                    Container(
                        height: SizeConfig.blockSizeVertical*85.5,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio:6/9,// (SizeConfig.blockSizeHorizontal/(SizeConfig.blockSizeVertical)),
                            children: List.generate(snapshot.data.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              background: Container(
                                padding:
                                EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                                color: Colors.red,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeVertical * 3,
                                    )),
                              ),
                              secondaryBackground: Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.blockSizeVertical * 3),
                                color: Colors.red,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete_sweep,
                                      color: Colors.white,
                                      size: SizeConfig.blockSizeVertical * 3,
                                    )),
                              ),
                              key: Key(movie[i].title),
                              onDismissed: (directions) {
                                db.deleteMovie(movie[i]);
                                snapshot.data.removeAt(i);
                                setState(() {
                                });
                              },
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => MovieDetails(
                                                title: movie[i].title,
                                                vote: movie[i].rating,
                                                releaseDate: movie[i].year,
                                                description: movie[i].description,
                                                poster: movie[i].poster,
                                              )));
                                },
                                child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeVertical*1)),
                                          child: CachedNetworkImage(
                                            imageUrl: baseUrl + movie[i].poster,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                      ))),
                  ],
                );
          }
          return Center(child: Text("No Movies Saved Yet"));
        },
      ),
    );
  }
}

//Padding(
//padding: EdgeInsets.all(SizeConfig.blockSizeVertical*2),
//child: Column(
//children: <Widget>[
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//CachedNetworkImage(
//imageUrl: baseUrl + movie[i].poster,
//width: SizeConfig.blockSizeHorizontal*20,
//fit: BoxFit.cover,
//),
//Text(
//movie[i].title,
//style: TextStyle(
//fontSize: SizeConfig.blockSizeVertical*2.8,
//fontWeight: FontWeight.bold,
//),
//),
//Padding(
//padding: EdgeInsets.only(right:18.0),
//child: Text(
//movie[i].rating,
//style: TextStyle(
//fontSize: SizeConfig.blockSizeVertical*2,
//),
//),
//),
//],
//),
//Row(
//mainAxisAlignment: MainAxisAlignment.spaceBetween,
//children: <Widget>[
//Text(
//movie[i].year,
//style: TextStyle(
//fontSize: SizeConfig.blockSizeVertical*2,
//),
//),
////                                  IconButton(
////                                    onPressed: (){
////                                      db.deleteMovie(movie[i]);
////                                      setState(() {});
////                                    },
////                                    icon: Icon(Icons.delete_outline, color:Colors.black),
////                                  )
//],
//),
//],
//),
//)
