import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/offlineMovies.dart';
import 'package:movie/offlineTv.dart';
import 'package:movie/size_config/size_config.dart';
import 'package:movie/tv_shows/tv_shows_home.dart';

class SlidingControl extends StatefulWidget {
  @override
  _SlidingControlState createState() => _SlidingControlState();
}

class _SlidingControlState extends State<SlidingControl> {
  int segmentControlGroupVal = 0;
  final Map<int, Widget> myTabs = const<int, Widget>{
    0: Text("Movies"),
    1: Text("Tv Shows")
  };

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: CupertinoPageScaffold(
        child: Stack(
          children: <Widget>[
            (segmentControlGroupVal == 0) ?
            Offline() :
            OfflineTv(),
            Container(
              width: SizeConfig.blockSizeHorizontal*100,
              child: CupertinoSlidingSegmentedControl(
                thumbColor: CupertinoColors.systemGrey,
                backgroundColor: CupertinoColors.secondarySystemBackground,
                padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*1.2, horizontal: SizeConfig.blockSizeHorizontal*3),
                groupValue: segmentControlGroupVal,
                children: myTabs,
                onValueChanged: (i) {
                  setState(() {
                    segmentControlGroupVal = i;
                  });
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
