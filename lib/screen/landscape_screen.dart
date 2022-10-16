

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LandscapePlayerPage extends StatefulWidget {
  final VideoPlayerController controller;
  const LandscapePlayerPage({Key? key,required  this.controller, }) : super(key: key);

  @override
  State<LandscapePlayerPage> createState() => _LandscapePlayerPageState();
}


class _LandscapePlayerPageState extends State<LandscapePlayerPage> {
  @override
  Widget build(BuildContext context) {
    return VideoPlayer(widget.controller);
  }

  @override
  void initState() {
    super.initState();
    _landscapeMode();
  }


  @override
  void dispose() {
    super.dispose();
    _setAllOrientation();
    widget.controller.dispose();
  }

  Future _landscapeMode()async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  Future _setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

  }
}
