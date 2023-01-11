import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/video_player.spacebar.dart';
import 'package:mobile_pssi/ui/watch/controller/watch.controller.dart';
import 'package:mobile_pssi/ui/watch/parts/class.detail.dart';
import 'package:mobile_pssi/ui/watch/parts/practice.upload.dart';
import 'package:mobile_pssi/ui/watch/parts/video.list.dart';
import 'package:mobile_pssi/ui/watch/parts/watch.header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class WatchScreen extends GetView<WatchController> {
  static const routeName = '/watch';
  const WatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WatchController());
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
        ),
        resizeToAvoidBottomInset: true,
        body: SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: VStack([
                  ZStack([
                    Obx(
                      () => VideoPlayerSpaceBar(
                        disableVideo: controller.videoDisabled.value,
                        loadVideo: controller.isLoadingVideo.value,
                        playerController: controller.podPlayerController,
                      ).h(260).wFull(context).px8(),
                    ),
                    const BackButton(
                      color: Colors.white,
                    ),
                  ]).box.black.make(),
                  const VStack([
                    WatchHeader(),
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          text: 'Daftar Video',
                        ),
                        Tab(
                          text: 'Detail Kelas',
                        ),
                        Tab(
                          text: 'Upload Tugas',
                        ),
                      ],
                    )
                  ]).p12()
                ]),
              ),
              const SliverFillRemaining(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    VideoList(),
                    ClassDetail(),
                    PracticeUpload(),
                  ],
                ),
              )
              // SliverList(
              //   delegate: SliverChildListDelegate([
              //     const TabBarView(
              //       physics: NeverScrollableScrollPhysics(),
              //       children: [
              //         VideoList(),
              //         ClassDetail(),
              //         PracticeUpload(),
              //       ],
              //     ).h(300),
              //   ]),
              // )
            ],
          ).safeArea(),
        ),
      ),
    );
  }
}
