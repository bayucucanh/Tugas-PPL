import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/consultation.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/quick_reply.dart';
import 'package:mobile_pssi/data/model/quick_reply_attachment.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/consult.request.dart';
import 'package:mobile_pssi/data/requests/quick_reply.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/consulting/auto_texts.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ConsultRoomController extends BaseController {
  final refreshController = RefreshController();
  final scrollController = ScrollController();
  final _consultRequest = ConsultRequest();
  final _quickReplyRequest = QuickReplyRequest();
  final StreamController<Resource<List<Message>>> streamController =
      StreamController();
  final chatMessage = TextEditingController();
  final _messageText = ''.obs;
  final _consultationDetail = Consultation().obs;
  final _chats = Resource<List<Message>>(data: []).obs;
  final page = 1.obs;
  final isSendingMessage = false.obs;
  final chatAvailable = true.obs;
  final _rating = 5.0.obs;
  final _comment = TextEditingController();
  Timer? _chatRefreshTimer;
  Timer? _refreshDetail;
  final FocusNode nodeText = FocusNode();

  ConsultRoomController() {
    _consultationDetail(Consultation.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _fetchDetail();
    _fetchChats();
    chatMessage.addListener(() {
      _messageText(chatMessage.text);
    });
    streamController.stream.listen((event) {
      _chats(event);
    });
    setRefresher();
    debounce(_messageText, (callback) => _checkQuickReply(),
        time: const Duration(milliseconds: 500));
    super.onInit();
  }

  _checkQuickReply() async {
    if (_messageText.isNotEmpty) {
      if (_messageText.matchAsPrefix('/', 0) != null) {
        if (!Get.isBottomSheetOpen!) {
          Resource<List<QuickReply>> quickReplies =
              await _quickReplyRequest.gets(option: 'select');
          getBottomSheet(
            VStack([
              ListTile(
                title: 'Auto Text'.text.sm.make(),
                trailing: const Icon(
                  Icons.edit,
                  size: 16,
                ),
                onTap: () => Get.toNamed(AutoTexts.routeName),
              ),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final reply = quickReplies.data?[index];
                  return ListTile(
                    title: '/${reply?.shortcut ?? '-'}'.text.sm.make(),
                    subtitle: reply?.attachments.isBlank == false
                        ? HStack([
                            const Icon(
                              Icons.perm_media_rounded,
                              size: 16,
                            ),
                            UiSpacer.horizontalSpace(space: 5),
                            (reply?.attachments?.length ?? 0).text.sm.make(),
                          ])
                        : (reply?.message ?? '-').text.sm.ellipsis.make(),
                    onTap: () => _sendAutoChat(reply),
                  );
                },
                itemCount: quickReplies.data?.length ?? 0,
              ),
            ]).p12().safeArea(top: false),
            isScrollControlled: true,
            isDismissible: true,
          );
        }
      }
    }
  }

  setRefresher() {
    if (_consultationDetail.value.status?.id == 1) {
      _chatRefreshTimer =
          Timer.periodic(const Duration(seconds: 5), (timer) async {
        var resp = await _consultRequest.getRoomChats(
            consultId: consultationDetail!.id!, page: page.value);
        streamController.sink.add(resp);
        _scrollToBottom();
      });
      _refreshDetail =
          Timer.periodic(const Duration(seconds: 5), (timer) async {
        await _fetchDetail();
        if (_consultationDetail.value.status?.id == 2 &&
            _consultationDetail.value.rating == null) {
          timer.cancel;
          if (Get.isDialogOpen! == false) {
            endByCoach();
          }
        }
      });
    }
  }

  @override
  void onClose() {
    _refreshDetail?.cancel();
    _chatRefreshTimer?.cancel();
    streamController.sink.close();
    streamController.close();
    super.onClose();
  }

  refreshData() {
    try {
      page(1);
      _chats.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchDetail();
      _fetchChats();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetail() async {
    try {
      _consultationDetail(await _consultRequest.getDetail(
          roomId: _consultationDetail.value.roomId!));
    } catch (_) {}
  }

  startTimer(Timer timer) async {
    //Timer Method that runs every second
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      // add event/data to stream controller using sink
      var resp = await _consultRequest.getRoomChats(
          consultId: consultationDetail!.id!, page: page.value);
      streamController.sink.add(resp);
    });
  }

  _fetchChats() async {
    try {
      EasyLoading.show();
      var resp = await _consultRequest.getRoomChats(
          consultId: consultationDetail!.id!, page: page.value);
      _chats.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      _scrollToBottom();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _scrollToBottom() {
    if (scrollController.hasClients) {
      final bottom = scrollController.position.maxScrollExtent;
      scrollController.animateTo(bottom,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  _sendAutoChat(QuickReply? quickReply) async {
    try {
      if (quickReply?.message != null) {
        await _consultRequest.chat(
          consultId: consultationDetail!.id!,
          message: quickReply?.message,
          receiverId: consultationDetail!.createdBy!.id!,
        );
      }

      if (quickReply?.attachments != null ||
          quickReply!.attachments!.isNotEmpty) {
        quickReply?.attachments?.forEach((attachment) {
          _sendMedia(attachment);
        });
      }
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      isSendingMessage(false);
      chatMessage.clear();
      Get.focusScope?.unfocus();
      refreshData();
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  void _sendMedia(QuickReplyAttachment attachment) async {
    try {
      String formatMessage = '';
      switch (attachment.extension) {
        case 'jpg':
        case 'png':
          formatMessage = '<img src="${attachment.file}"/>';
          break;
        case 'mp4':
          formatMessage =
              '<video width="320" height="240" controls><source src="="${attachment.file}" type="video/mp4"></video>';
      }
      await _consultRequest.chat(
        consultId: consultationDetail!.id!,
        message: formatMessage,
        receiverId: consultationDetail!.createdBy!.id!,
      );
    } catch (_) {}
  }

  loadMore() {
    try {
      if (page.value >= _chats.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchChats();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  chatCoach() async {
    try {
      isSendingMessage(true);
      if (userData.value.isPlayer) {
        await _consultRequest.chat(
          consultId: consultationDetail!.id!,
          message: chatMessage.text,
          receiverId: consultationDetail!.consultWith!.id!,
        );
      } else {
        await _consultRequest.chat(
          consultId: consultationDetail!.id!,
          message: chatMessage.text,
          receiverId: consultationDetail!.createdBy!.id!,
        );
      }
      isSendingMessage(false);
      chatMessage.clear();
      Get.focusScope?.unfocus();
      refreshData();
    } catch (e) {
      isSendingMessage(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  endByCoach() {
    if (userData.value.isPlayer) {
      chatAvailable(false);
      getDialog(
          ConfirmationDefaultDialog(
            title: 'Konsultasi Selesai',
            content:
                'Konsultasi anda telah selesai, berikan rating untuk pelatih.',
            showCancel: false,
            onConfirm: () {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              _rateDialog();
            },
          ),
          barrierDismissible: false);
    }
  }

  timerExpired() {
    chatAvailable(false);
    _endConsultation();

    getDialog(
        ConfirmationDefaultDialog(
          title: 'Konsultasi Selesai',
          content:
              'Konsultasi anda telah selesai, berikan rating untuk pelatih.',
          showCancel: false,
          onConfirm: () {
            if (Get.isDialogOpen!) {
              Get.back();
            }
            _rateDialog();
          },
        ),
        barrierDismissible: false);
  }

  endDialog() {
    getDialog(ConfirmationDefaultDialog(
      title: 'Selesai Konsultasi?',
      content: 'Apakah anda ingin menyelesaikan konsultasi ini?',
      onConfirm: () {
        if (Get.isDialogOpen!) {
          Get.back();
        }
        _endConsultation();
        refreshData();
      },
    ));
  }

  _endConsultation() async {
    try {
      await _consultRequest.endConsult(
          roomId: _consultationDetail.value.roomId!);
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  _rateDialog() {
    getDialog(
        ConfirmationDefaultDialog(
          title: 'Rating Konsultasi',
          showCancel: false,
          contentWidget: VStack([
            RatingBar.builder(
              initialRating: 5,
              itemCount: 5,
              minRating: 1,
              maxRating: 5,
              itemSize: 50,
              allowHalfRating: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: starColor,
              ),
              glow: true,
              onRatingUpdate: _onRate,
            ).centered(),
            TextFormField(
              controller: _comment,
              decoration: const InputDecoration(
                hintText: 'Pesan (Opsional)',
                labelText: 'Pesan',
              ),
              minLines: 3,
              maxLines: 3,
            )
          ]),
          onConfirm: _saveRating,
          confirmText: 'Simpan',
        ),
        barrierDismissible: false);
  }

  _onRate(double rate) {
    _rating(rate);
  }

  _saveRating() async {
    try {
      EasyLoading.show();
      await _consultRequest.rateConsult(
        roomId: _consultationDetail.value.roomId!,
        rating: _rating.value,
        comment: _comment.text,
      );
      EasyLoading.dismiss();

      if (Get.isDialogOpen!) {
        Get.back();
      }
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  Consultation? get consultationDetail => _consultationDetail.value;
  List<Message>? get chats => _chats.value.data;
}
