

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../util/size_config.dart';
import 'landscape_screen.dart';

class PlayVideoFromFile extends StatefulWidget {
  const PlayVideoFromFile({Key? key}) : super(key: key);

  @override
  State<PlayVideoFromFile> createState() => _PlayVideoFromFileState();
}


class _PlayVideoFromFileState extends State<PlayVideoFromFile> {
  late VideoPlayerController _controller;
  SizeConfig _sizeConfig = SizeConfig();
  late bool play_icon;
  final picker = ImagePicker();
  late File _video;
  final File newFile = File("/storage/emulated/0/DCIM/Camera/VID20220904174100.mp4");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    play_icon = true;
    _playVideo(file:newFile);
  }


  
  @override
  Widget build(BuildContext context) {
    _sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Video From File"),
        centerTitle: true,
      ),
      body:  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            color: Colors.black,
            height: SizeConfig.screenHeight * 0.30,
            child: _controller.value.isInitialized ?
            Column(
              children: [
                Stack(
                  children:[
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.22,
                      child: GestureDetector(
                          onTap: (){

                            if(_controller.value.isPlaying ) {
                              setState(() {
                                play_icon = true;
                                _controller.pause();
                              });

                            }
                            else {
                              setState(() {
                                play_icon = false;
                                _controller.play();
                              });

                            }
                          },
                          child: VideoPlayer(_controller)),
                    ),
                    if(play_icon)
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.085,
                        left: MediaQuery.of(context).size.width * 0.4,
                        child: IconButton(onPressed: (){
                          /* videoPlayerController.value.isPlaying ?
                              videoPlayerController.pause() :
                              videoPlayerController.play();*/
                          if(_controller.value.isPlaying ) {
                            setState(() {
                              play_icon = true;
                              _controller.pause();
                            });

                          }
                          else {
                            setState(() {
                              play_icon = false;
                              _controller.play();
                            });

                          }
                        }, icon:Icon(_controller.value.isPlaying ?
                        Icons.stop : Icons.play_arrow , size: 50,color: Colors.white,)
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => (LandscapePlayerPage(controller: _controller))));
                      }, icon:Icon( Icons.fullscreen , size: 20,color: Colors.white,)
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      ValueListenableBuilder(
                        builder: (context,VideoPlayerValue value,child){
                          return Text(
                            videoDuration(value.position),
                            style: const TextStyle(color: Colors.white,fontSize: 15),
                          );
                        },
                        valueListenable: _controller,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 5,
                          child: VideoProgressIndicator(
                            _controller,
                            padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 12),
                            colors: VideoProgressColors(
                                backgroundColor: Colors.grey.withOpacity(1.0),
                                playedColor: Colors.blue),
                            allowScrubbing: true,
                          ),
                        ),
                      ),
                      Text(
                        videoDuration(_controller.value.duration),
                        style: const TextStyle(color: Colors.white,fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ) : const Center(
              child: CircularProgressIndicator(color: Colors.white,),
            ),
        ),
        ElevatedButton(
          onPressed: () async{
            final pickedFile = await pickVideoFile();
            if(pickedFile == null)
              return;
            _playVideo(file: pickedFile);
          /*  File f = await _pickVideo();
            _playVideo(file: f);*/
          },
          child: Text('Pick a video'),
          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
        ),

      ],
    ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    final hour = twoDigits(duration.inHours);
    return [if(duration.inHours>0)
      hour,
      twoDigitMinutes,
      twoDigitSeconds,
    ].join(':');
    //"${hour == '00' ? '' : hour + ':'}$twoDigitMinutes:$twoDigitSeconds";
  }


  void _playVideo({required File file}) {
    _controller = VideoPlayerController.file(file)
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((value) => _controller.play());
  }

  Future<File?> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    print("video path${result?.files.single.path}");
    if(result == null)
      return null;
    return File(result.files.single.path ?? '');
    //final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
  }

}
