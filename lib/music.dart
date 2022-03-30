import 'package:app/colors.dart';
import 'package:app/helpers/destrpy_textfield_focus.dart';
import 'package:app/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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

class _MusicPageState extends State<MusicPage> with WidgetsBindingObserver {
  late AppLifecycleState _appLifecycleState;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final _searchKey = TextEditingController();

  String _prevPath = "";
  String _currentPath = "";
  String _songTitle = "";
  //int _songLength = 0;
  late Future<List<SongModel>> _songs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _songs = getSongs();
    requestPermission();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });
    if (state == AppLifecycleState.paused) {
      print('AppLifecycleState state: Paused audio playback');
    }
    if (state == AppLifecycleState.resumed) {
      _songs = getSongs();
      print('AppLifecycleState state: Resumed audio playback');
    }
    print('AppLifecycleState state:  $state');
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

  void refresh() {
    setState(() {
      _songs = getSongs();
    });
  }

  Future<List<SongModel>> getSongs() async {
    var songs = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    // setState(() {
    //   _songLength = songs
    //       .where((element) =>
    //           !element.data.contains("/storage/emulated/0/Music/ringtone"))
    //       .length;
    // });
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                onPressed: () {
                  stop();
                  Get.toNamed("/screen-videos");
                },
                splashRadius: 20,
                icon: const Icon(
                  Entypo.video_camera,
                  color: Colors.white,
                ),
              )
            ],
            expandedHeight: 250,
            stretch: true,
            backgroundColor: primary,
            pinned: true,
            leadingWidth: 0,
            leading: const SizedBox(),
            title: Text(
              "Songs",
              style: GoogleFonts.lobster(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "images/bg_1.jpg",
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
              future: _songs,
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
                  onRefresh: () async => getSongs(),
                  child: Scrollbar(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (snapshot.data![index].data
                            .contains("/storage/emulated/0/Music/ringtone")) {
                          return const SizedBox();
                        }
                        if (!snapshot.data![index].displayNameWOExt
                            .toLowerCase()
                            .contains(_searchKey.text.trim())) {
                          return const SizedBox();
                        }
                        return ListTile(
                          tileColor: _currentPath == snapshot.data![index].data
                              ? primary
                              : secondary,
                          minLeadingWidth: 30,
                          leading: Icon(
                            Fontisto.applemusic,
                            color: _currentPath == snapshot.data![index].data
                                ? danger
                                : Colors.white,
                          ),
                          title: Text(
                            snapshot.data![index].displayNameWOExt.trim(),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0,
                            ),
                          ),
                          onTap: _currentPath == snapshot.data![index].data
                              ? () => pause()
                              : () {
                                  destroyTextFieldFocus(context);

                                  play(
                                    path: snapshot.data![index].data,
                                    title:
                                        snapshot.data![index].displayNameWOExt,
                                  );
                                },
                        );
                      },
                      itemCount: snapshot.data!.length,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: _songTitle.isNotEmpty
          ? BottomAppBar(
              color: primary,
              elevation: 10,
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
                          fontSize: 13.0,
                          height: 1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _currentPath.isNotEmpty
                        ? IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () async {
                              pause();
                            },
                            icon: const Icon(
                              AntDesign.pausecircleo,
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
                              AntDesign.playcircleo,
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
