import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  String _prevPath = ""; // Save before clearing
  String _currentPath = "";
  String _songTitle = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  void requestPermission() {
    Permission.storage.request();
  }

  void play({path, title}) async {
    setState(() {
      _currentPath = path;
      _songTitle = title;
    });

    await _audioPlayer.play(path, isLocal: true);

    if (_currentPath != path) {
      stop();
      await _audioPlayer.play(path, isLocal: true);
    }
  }

  void stop() async {
    _audioPlayer.stop();
    setState(() {
      _currentPath = "";
      _songTitle = "";
      _prevPath = "";
    });
  }

  void pause() async {
    _audioPlayer.pause();
    setState(() {
      _prevPath = _currentPath;
      _currentPath = "";
    });
  }

  void resume() async {
    _audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: const SizedBox(),
        leadingWidth: 0,
        title: Text(
          "Songs",
          style: GoogleFonts.roboto(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 20.0,
            onPressed: () {
              stop();
              Get.toNamed("/screen-videos");
            },
            icon: const Icon(
              Icons.video_stable,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No songs found"),
            );
          }
          // ignore: unrelated_type_equality_checks
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            setState(() {
              _songTitle = snapshot.data![0].displayNameWOExt;
            });
          }

          return ListView.builder(
            itemBuilder: (_, index) {
              if (snapshot.data![index].data
                  .contains("/storage/emulated/0/Music/ringtone")) {
                return const SizedBox();
              }

              return ListTile(
                title: Text(snapshot.data![index].displayNameWOExt.trim()),
                subtitle:
                    Text("Artist ${snapshot.data![index].artist.toString()}"),
                onTap: _currentPath == snapshot.data![index].data
                    ? () {
                        pause();
                      }
                    : () {
                        play(
                          path: snapshot.data![index].data,
                          title: snapshot.data![index].displayNameWOExt,
                        );
                      },
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
// This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: _songTitle.isNotEmpty
          ? BottomAppBar(
              color: Colors.black87,
              elevation: 5,
              child: Container(
                height: Get.height * 0.10,
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.70,
                      child: Text(
                        _songTitle,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 14.0,
                          height: 1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    _currentPath.isNotEmpty
                        ? IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              pause();
                            },
                            icon: const Icon(
                              Icons.pause,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          )
                        : IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              play(
                                path: _prevPath,
                                title: _songTitle,
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
