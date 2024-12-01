import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibez_final/consts/colors.dart';
import 'package:vibez_final/consts/text_style.dart';
import 'package:vibez_final/controllers/player_controller.dart';

class Player extends StatelessWidget {
  final List<SongModel> data;
  const Player({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController(data));
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteColor),
        backgroundColor: const Color.fromARGB(255, 62, 1, 1),
        title: Text(
          "List",
          style: ourStyle(
            size: 18,
            family: "bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 500,
                  width: 500,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteColor,
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                      id: data[controller.playIndex.value].id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: Image.asset(
                        'assets/VibezIcon.png',
                        height: 250,
                        width: 250,
                      )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: ourStyle(
                          color: bgColor,
                          family: "bold",
                          size: 24,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: ourStyle(
                          color: bgDarkColor,
                          family: "regular",
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(color: bgDarkColor),
                            ),
                            Expanded(
                              child: Slider(
                                thumbColor: sliderColor,
                                inactiveColor: bgColor,
                                activeColor: sliderColor,
                                min: const Duration(seconds: 0)
                                    .inSeconds
                                    .toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDurationToSeconds(
                                      newValue.toInt());
                                },
                              ),
                            ),
                            Text(
                              controller.duration.value,
                              style: ourStyle(color: bgDarkColor),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (controller.playIndex.value > 0) {
                                  controller.playSong(
                                      data[controller.playIndex.value - 1].uri,
                                      controller.playIndex.value - 1);
                                }
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                size: 50,
                              )),
                          Obx(
                            () => IconButton(
                                onPressed: () {
                                  if (controller.isPlaying.value) {
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  } else {
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                },
                                icon: controller.isPlaying.value
                                    ? const Icon(
                                        Icons.pause,
                                        size: 60,
                                      )
                                    : const Icon(
                                        Icons.play_arrow_rounded,
                                        size: 60,
                                      )),
                          ),
                          IconButton(
                              onPressed: () {
                                if (controller.playIndex.value <
                                    data.length - 1) {
                                  controller.playSong(
                                      data[controller.playIndex.value + 1].uri,
                                      controller.playIndex.value + 1);
                                }
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                size: 50,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
