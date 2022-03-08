import 'package:app/controllers/videoPlayerController.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getter/getter.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenVideos extends StatefulWidget {
  const ScreenVideos({Key? key}) : super(key: key);

  @override
  State<ScreenVideos> createState() => _ScreenVideosState();
}

class _ScreenVideosState extends State<ScreenVideos> {
  Future<List<Media>> getVideos() async {
    return await Getter.get(type: GetterType.videos);
  }

  _openVideo(videoPathUrl) async {
    Get.put(VideoPlayerController()).videoPath = videoPathUrl;
    Get.toNamed("/screen-video-preview");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Videos",
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Media>>(
            future: getVideos(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Nothing to show',
                    style: GoogleFonts.roboto(color: Colors.black87),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.video_stable,
                        color: Colors.black87,
                      ),
                      onTap: () {
                        _openVideo(snapshot.data![index].path.toString());
                      },
                      title: Text(snapshot.data![index].title),
                    );
                  },
                  itemCount: snapshot.data!.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
