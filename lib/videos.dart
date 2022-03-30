import 'package:app/colors.dart';
import 'package:app/controllers/videoPlayerController.dart';
import 'package:app/ux/dialog_video.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:getter/getter.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late Future<List<Media>> _videos;

  Future<List<Media>> getVideos() async {
    var videos = await Getter.get(type: GetterType.videos);
    return videos;
  }

  void refresh() {
    setState(() {
      _videos = getVideos();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videos = getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            stretch: true,
            backgroundColor: primary,
            pinned: true,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            title: Text(
              "Videos",
              style: GoogleFonts.lobster(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "images/bg_2.jpg",
                fit: BoxFit.cover,
              ),
              stretchModes: const [
                StretchMode.blurBackground,
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder(
              future: _videos,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length == 0) {
                    return Center(
                      child: Text(
                        "NO SONGS FOUND",
                        style: GoogleFonts.roboto(
                          color: primary.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                        ),
                      ),
                    );
                  }
                }
                return RefreshIndicator(
                  onRefresh: () async => refresh(),
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(
                            Entypo.video_camera,
                            size: 24.0,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Get.put(VideoPlayerController()).videoPath =
                                snapshot.data![index].path.toString();
                            dialogOpenVideo(context: context);
                          },
                          title: Text(
                            snapshot.data![index].title,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 13.0,
                              height: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
