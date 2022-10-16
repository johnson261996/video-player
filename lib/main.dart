import 'package:demo_video_player/screen/video_player_from_file.dart';
import 'package:demo_video_player/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'model/video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Video player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late List<Video> videos;
  late VideoPlayerController videoPlayerController;
  int currentindex = 0;
  SizeConfig _sizeConfig = SizeConfig();
  late bool play_icon;
  bool isMusicOn = true;

  @override
  void initState() {
    super.initState();
   play_icon = true;
    videos  = [
      Video(
          name: 'Elephant Dream',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          thumnail: 'https://png.pngtree.com/png-vector/20190703/ourlarge/pngtree-baby-elephant-sleep-on-the-moon-png-image_1531574.jpg'
      ),
      Video(
          name: 'Big Buck Bunny',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          thumnail: 'https://peach.blender.org/wp-content/uploads/bbb-splash.png'
      ),
      Video(
          name: 'For Bigger Blazes',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          thumnail: 'https://png.pngitem.com/pimgs/s/205-2052666_blaze-and-the-monster-machines-clipart-hd-png.png'
      ),
      Video(
          name: 'For Bigger Joyrides',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
          thumnail: 'https://gamerbraves.sgp1.cdn.digitaloceanspaces.com/2022/08/jetpackjoyright.jpg'
      ),
      Video(
          name: 'Sintel',
          url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
          thumnail: 'https://i.ytimg.com/vi/unb-gGE_dhg/maxresdefault.jpg'
      )

    ];
    _playVideo(0, true);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sizeConfig.init(context);
    print("vcontroller: ${videoPlayerController.value.isInitialized}");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.black,
              height: SizeConfig.screenHeight * 0.30,
              child: videoPlayerController.value.isInitialized ?
                  Column(
                    children: [
                      Stack(
                        children:[
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.22,
                          child: GestureDetector(
                              onTap: (){
                                
                                if(videoPlayerController.value.isPlaying ) {
                                  setState(() {
                                    play_icon = true;
                                    videoPlayerController.pause();
                                  });

                                }
                                else {
                                  setState(() {
                                    play_icon = false;
                                    videoPlayerController.play();
                                  });

                                }
                              },
                              child: VideoPlayer(videoPlayerController)),
                        ),
                          if(play_icon)
                          Positioned(
                            top: MediaQuery.of(context).size.height * 0.085,
                            left: MediaQuery.of(context).size.width * 0.4,
                            child: IconButton(onPressed: (){
                             /* videoPlayerController.value.isPlaying ?
                              videoPlayerController.pause() :
                              videoPlayerController.play();*/
                              if(videoPlayerController.value.isPlaying ) {
                                setState(() {
                                  play_icon = true;
                                  videoPlayerController.pause();
                                });

                              }
                              else {
                                setState(() {
                                  play_icon = false;
                                  videoPlayerController.play();
                                });

                              }
                            }, icon:Icon(videoPlayerController.value.isPlaying ?
                            Icons.stop : Icons.play_arrow , size: 50,color: Colors.white,)
                            ),
                          )
                      ],
                      ),
                      const SizedBox(height: 12,),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  [
                            IconButton(
                                onPressed: () {
                                  soundToggle();
                                },
                                icon: Icon(
                                  isMusicOn == true ? Icons.volume_off : Icons.volume_up,
                                  color: Colors.white,
                                  size:20,
                                )),
                            ValueListenableBuilder(
                              builder: (context,VideoPlayerValue value,child){
                              return Text(
                                videoDuration(value.position),
                                style: const TextStyle(color: Colors.white,fontSize: 15),
                              );
                            },
                              valueListenable: videoPlayerController,
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 5,
                                child: VideoProgressIndicator(
                                videoPlayerController,
                                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 12),
                                colors: VideoProgressColors(
                                    backgroundColor: Colors.grey.withOpacity(1.0),
                                    playedColor: Colors.blue),
                               allowScrubbing: true,
                              ),
                             ),
                            ),
                            Text(
                              videoDuration(videoPlayerController.value.duration),
                              style: const TextStyle(color: Colors.white,fontSize: 15),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ) : const Center(
                child: CircularProgressIndicator(color: Colors.white,),
              )
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (PlayVideoFromFile())),
                );
              },
              child: Text('Video Player Using File System'),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
           Expanded(
               child: ListView.builder(
               itemCount:videos.length,
               itemBuilder: (context,index){
                 return GestureDetector(
                   onTap :() => _playVideo(index,true),
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 10.0,
                     color: Colors.black.withOpacity(0.5),
                     child: Row(
                       children: [
                         SizedBox(
                           height: 100,
                           width: 100,
                           child: Image.network(videos[index].thumnail,fit: BoxFit.contain,),
                         ),
                         const SizedBox(width: 10,),
                         Text(videos[index].name,style: const TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'Raleway',fontWeight: FontWeight.w400),)
                       ],
                     ),
                   ),
                 );
               },
           )
           )
          ],
        ),
      ),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _playVideo(index,init) {
    if(index < 0 || index >= videos.length) {
      return;
    }
    for (var element in videos) { print("video url:${element.url}");}

    videoPlayerController = VideoPlayerController.network(videos[index].url)
    ..addListener(() {
      setState(() {});
    })
    ..setLooping(true)
    ..initialize().then((value) => videoPlayerController.play());
  }

  void soundToggle() {
    setState(() {
      isMusicOn == false
          ? videoPlayerController.setVolume(0.0)
          : videoPlayerController.setVolume(1.0);
      isMusicOn = !isMusicOn;
    });
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
}
