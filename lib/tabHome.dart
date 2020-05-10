import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie/movies/movies_home.dart';
import 'package:movie/offlineMovies.dart';
import 'package:movie/offlineSlidingSegControl.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:movie/tv_shows/tv_shows_home.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.movie,
              size: SizeConfig.blockSizeVertical * 3,
            ),
            title: Text(
              'Movies',
              style: TextStyle(
                fontFamily: 'Google-Sans',
                fontSize: SizeConfig.blockSizeVertical * 2,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.youtubeTv,
              size: SizeConfig.blockSizeVertical * 3,
            ),
            title: Text(
              'TV Shows',
              style: TextStyle(
                fontFamily: 'Google-Sans',
                fontSize: SizeConfig.blockSizeVertical * 2,
              ),
            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.cloudDownload,
              size: SizeConfig.blockSizeVertical * 3,
            ),
            title: Text(
              'Saved',
              style: TextStyle(
                fontFamily: 'Google-Sans',
                fontSize: SizeConfig.blockSizeVertical * 2,
              ),
            ),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        assert(index >= 0 && index <= 3);
        switch (index) {
          case 0:
            return new NewHome();
            break;
          case 1:
            return TvHome();
            break;
          case 2:
            return SlidingControl();//Offline();
            break;

        }
        return null;
      },
    );
  }
}
