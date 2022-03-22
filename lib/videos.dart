import 'package:app/controllers/videoPlayerController.dart';
import 'package:app/ux/dialog_video.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:getter/getter.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenVideos extends StatefulWidget {
  const ScreenVideos({Key? key}) : super(key: key);

  @override
  State<ScreenVideos> createState() => _ScreenVideosState();
}

class _ScreenVideosState extends State<ScreenVideos> {
  int _videoLength = 0;
  late Future<List<Media>> _listFuture;

  Future<List<Media>> getVideos() async {
    var videos = await Getter.get(type: GetterType.videos);
    setState(() {
      _videoLength = videos.length;
    });
    return videos;
  }

  void refresh() {
    setState(() {
      _listFuture = getVideos();
    });
  }

  _openVideo(videoPathUrl) async {
    Get.toNamed("/screen-video-preview");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listFuture = getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
        title: Text(
          "Videos ($_videoLength)",
          style: GoogleFonts.roboto(
            color: Colors.black87,
            fontSize: 16.0,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Media>>(
            future: _listFuture,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.none) {
                print("ConnectionState.none");
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                print("snapshot.data == null");
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => refresh(),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: const Icon(
                          Entypo.video,
                          color: Colors.black87,
                        ),
                        onTap: () {
                          Get.put(VideoPlayerController()).videoPath =
                              snapshot.data![index].path.toString();
                          dialogOpenVideo(context: context);
                        },
                        title: Text(snapshot.data![index].title),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
