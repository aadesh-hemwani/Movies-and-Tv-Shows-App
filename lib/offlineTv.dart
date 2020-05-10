import 'package:flutter/cupertino.dart';
import 'package:movie/size_config/size_config.dart';

class OfflineTv extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
        child: Container(
          child: Text("Coming Soon", style: TextStyle(fontSize: SizeConfig.blockSizeVertical*3),),
        ),
    );
  }
}
