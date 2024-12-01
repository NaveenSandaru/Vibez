import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibez_final/consts/colors.dart';
import 'package:vibez_final/consts/text_style.dart';
import 'package:vibez_final/controllers/player_controller.dart';
import 'package:vibez_final/views/player.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 1, 1),
        leading: Image.asset(
          'assets/VibezIcon.png',
        ),
        title: Text(
          "Vibez",
          style: ourStyle(
            family: "bold",
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: OnAudioQuery().querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              "No songs found.",
              style: ourStyle(),
            ));
          } else {
            Get.put(PlayerController(snapshot.data!));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Obx(
                      () => ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        tileColor: bgColor,
                        title: Text(
                          snapshot.data![index].displayNameWOExt,
                          style: ourStyle(
                            family: "bold",
                            size: 15,
                          ),
                        ),
                        subtitle: Text(
                          "${snapshot.data![index].artist}",
                          style: ourStyle(
                            family: "regular",
                            size: 12,
                          ),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),
                        ),
                        trailing:
                            Get.find<PlayerController>().playIndex.value ==
                                        index &&
                                    Get.find<PlayerController>().isPlaying.value
                                ? const Icon(
                                    Icons.play_arrow,
                                    color: whiteColor,
                                    size: 26,
                                  )
                                : null,
                        onTap: () {
                          Get.to(
                            () => Player(
                              data: snapshot.data!,
                            ),
                            transition: Transition.downToUp,
                          );
                          Get.find<PlayerController>()
                              .playSong(snapshot.data![index].uri, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
