import 'package:app/controllers/videoPlayerController.dart';
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
  playVideo() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Media>> getVideos() async {
    return await Getter.get(type: GetterType.videos);
  }

  _getImage(videoPathUrl) async {
    //return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.pink,
      ),
      body: FutureBuilder<List<Media>>(
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
          return ListView.builder(
            itemBuilder: (_, index) {
              return ListTile(
                leading: const Icon(Icons.videocam_sharp),
                onTap: () {
                  Get.put(VideoPlayerController()).videoPath =
                      snapshot.data![index].path.toString();
                  Get.toNamed("/screen-video-preview");
                },
                title: Text(snapshot.data![index].title),
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
