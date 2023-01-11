import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/bottom_bar_item.dart';
import 'package:mobile_pssi/ui/academy_partner/academy_partners.dart';
import 'package:mobile_pssi/ui/banners/banner_list.dart';
import 'package:mobile_pssi/ui/class/coach_class_screen.dart';
import 'package:mobile_pssi/ui/class/my_class_screen.dart';
import 'package:mobile_pssi/ui/class_category/class_category_management.dart';
import 'package:mobile_pssi/ui/club/club_detail.dart';
import 'package:mobile_pssi/ui/club/coach_club_detail.dart';
import 'package:mobile_pssi/ui/competitions/competitions.dart';
import 'package:mobile_pssi/ui/consulting/classification_detail.dart';
import 'package:mobile_pssi/ui/consulting/consult_list.dart';
import 'package:mobile_pssi/ui/events/events.dart';
import 'package:mobile_pssi/ui/help/helps.dart';
import 'package:mobile_pssi/ui/history/history_screen.dart';
import 'package:mobile_pssi/ui/home/home_screen.dart';
import 'package:mobile_pssi/ui/home/parts/menu.card.dart';
import 'package:mobile_pssi/ui/komik/komik_screen.dart';
import 'package:mobile_pssi/ui/product_management/product_management.dart';
import 'package:mobile_pssi/ui/profile/profile.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_coach_offerings.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_player_offerings.dart';
import 'package:mobile_pssi/ui/scouting/saved_coach.dart';
import 'package:mobile_pssi/ui/scouting/saved_player.dart';
import 'package:mobile_pssi/ui/secure_documents/secure_documents.dart';
import 'package:mobile_pssi/ui/skill_management/skill_management.dart';
import 'package:mobile_pssi/ui/suspend/suspend_management.dart';
import 'package:mobile_pssi/ui/transfer_market/transfer_market.dart';
import 'package:mobile_pssi/ui/users/users.dart';
import 'package:mobile_pssi/ui/verify_performance/test_parameter_list.dart';
import 'package:mobile_pssi/ui/verify_task/verify_task.dart';
import 'package:mobile_pssi/ui/voucher/vouchers.dart';
import 'package:mobile_pssi/ui/withdraw/withdraws.dart';
import 'package:velocity_x/velocity_x.dart';

class MenuController extends BaseController {
  final menus = <MenuCard>[].obs;

  @override
  void onInit() {
    getUserData();
    _getMenus();
    super.onInit();
  }

  refreshMenu() {
    getUserData();
    _getMenus();
  }

  static List<BottomBarItem> getPlayerBottomNavbar() {
    return [
      BottomBarItem(
        icon: Icons.home_rounded,
        label: 'Beranda',
        widget: const HomeScreen(),
      ),
      BottomBarItem(
        icon: Icons.videocam_rounded,
        label: 'Kelasku',
        widget: const MyClassScreen(),
      ),
      BottomBarItem(
          icon: Icons.history_rounded,
          label: 'Riwayat',
          widget: const HistoryScreen()),
      BottomBarItem(
        icon: Icons.person,
        label: 'Profil',
        widget: const Profile(),
      )
    ];
  }

  static List<BottomBarItem> getCoachBottomNavbar() {
    return [
      BottomBarItem(
        icon: Icons.home_rounded,
        label: 'Beranda',
        widget: const HomeScreen(),
      ),
      BottomBarItem(
        icon: Icons.groups_rounded,
        label: 'Klub Saya',
        widget: const CoachClubDetail(),
      ),
      BottomBarItem(
        icon: Icons.comment_rounded,
        label: 'Konsultasi',
        widget: const ConsultList(),
      ),
      BottomBarItem(
        icon: Icons.person,
        label: 'Profil',
        widget: const Profile(),
      )
    ];
  }

  static List<BottomBarItem> getClubBottomNavbar() {
    return [
      BottomBarItem(
        icon: Icons.home_rounded,
        label: 'Beranda',
        widget: const HomeScreen(),
      ),
      BottomBarItem(
        icon: Icons.groups_rounded,
        label: 'Klub Saya',
        widget: const ClubDetail(),
      ),
      BottomBarItem(
        icon: Icons.person,
        label: 'Profil',
        widget: const Profile(),
      )
    ];
  }

  _getMenus() {
    menus.clear();

    if (userData.value.hasRoles(['course-creator', 'administrator'])) {
      menus.add(
        MenuCard(
          icon: Icons.class_rounded,
          label: 'Kelas',
          onTap: _toClass,
        ),
      );
    }

    if (userData.value.hasRoles(['verifikator'])) {
      menus.addAll([
        MenuCard(
          icon: Icons.check,
          label: 'Verifikasi Tugas',
          onTap: _toVerifyTask,
        ),
        MenuCard(
          icon: Icons.text_snippet_rounded,
          label: 'Verifikasi Test Parameter',
          onTap: _toVerifyTestParams,
        ),
      ]);
    }

    if (userData.value.hasRoles(['administrator', 'verifikator'])) {
      menus.addAll([
        MenuCard(
          icon: Icons.verified_rounded,
          label: 'Verifikasi Partner',
          onTap: _toVerifyPartners,
        ),
        MenuCard(
          icon: Icons.verified_user_rounded,
          label: 'Verifikasi Dokumen',
          onTap: _toVerifyUserDocuments,
        ),
      ]);
    }

    if (userData.value.hasRoles(['finance'])) {
      menus.addAll([
        MenuCard(
          icon: FontAwesomeIcons.moneyCheck,
          label: 'Penarikan Dana',
          onTap: _toWithdraws,
        ),
      ]);
    }

    // if (userData.value.hasRoles(['pelatih'])) {
    //   menus.addAll([
    //     MenuCard(
    //       icon: Icons.transfer_within_a_station_rounded,
    //       label: 'Komik',
    //       onTap: _toTransfermarket,
    //     ),
    //   ]);
    // }

    if (userData.value.hasRoles(['administrator'])) {
      menus.addAll([
        MenuCard(
          icon: Icons.transfer_within_a_station_rounded,
          label: 'Transfermarket',
          onTap: _toTransfermarket,
        ),
        MenuCard(
          icon: Icons.keyboard_command_key_outlined,
          label: 'Komik',
          onTap: _toKomik,
        ),
        MenuCard(
          icon: Icons.category_rounded,
          label: 'Kategori Kelas',
          onTap: _toClassCategoryManagement,
        ),
        MenuCard(
          icon: Icons.scatter_plot_rounded,
          label: 'Topik Keahlian',
          onTap: _toSkillManagement,
        ),
        MenuCard(
          icon: Icons.image_aspect_ratio_rounded,
          label: 'Banner',
          onTap: _toBanners,
        ),
        MenuCard(
          icon: Icons.card_giftcard_rounded,
          label: 'Voucher',
          onTap: _toVouchers,
        ),
        MenuCard(
          icon: Icons.event_rounded,
          label: 'Events',
          onTap: _toEvents,
        ),
        MenuCard(
          icon: Icons.stars_outlined,
          label: 'Kompetisi',
          onTap: _toCompetitions,
        ),
        MenuCard(
          icon: Icons.scatter_plot_rounded,
          label: 'Suspend Manajemen',
          onTap: _toSuspendManagement,
        ),
        MenuCard(
          icon: Icons.supervised_user_circle_sharp,
          label: 'Pengguna',
          onTap: _toUsers,
        ),
        MenuCard(
          icon: Icons.card_membership_outlined,
          label: 'Produk',
          onTap: _toProducts,
        ),
        MenuCard(
          icon: Icons.help_center_rounded,
          label: 'FAQ',
          onTap: _toFaqs,
        ),
      ]);
    }

    if (userData.value.classificationUser != null) {
      menus.addAll([
        MenuCard(
            icon: Icons.chat_rounded,
            label: 'Detil Konsultasi',
            onTap: () => Get.toNamed(ClassificationDetail.routeName))
      ]);
    }
  }

  List<Widget> get profileMenu {
    List<Widget> menus = [];
    if (userData.value.isPlayer) {
      menus.addAll([
        ListTile(
          leading: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ),
          title: 'Setelan'.text.sm.white.make(),
          onTap: openSettings,
        ),
        ListTile(
          leading: const Icon(
            Icons.troubleshoot_rounded,
            color: Colors.white,
          ),
          title: 'Tes Parameter'.text.sm.white.make(),
          onTap: openUpdateParameter,
        ),
        ListTile(
          leading: const Icon(Icons.military_tech_rounded, color: Colors.white),
          title: 'Pengalaman'.text.sm.white.make(),
          onTap: openExperiences,
        ),
        ListTile(
          leading:
              const Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
          title: 'Riwayat Pendidikan'.text.sm.white.make(),
          onTap: openEducation,
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.award, color: Colors.white),
          title: 'Penghargaan'.text.sm.white.make(),
          onTap: openAchievements,
        ),
        ListTile(
          leading: const Icon(FontAwesomeIcons.trophy, color: Colors.white),
          title: 'Kejuaraan'.text.sm.white.make(),
          onTap: openChampionship,
        ),
        ListTile(
          leading: const Icon(Icons.stars_rounded, color: Colors.white),
          title: 'Klub'.text.sm.white.make(),
          onTap: openSearchClub,
        ),
        ListTile(
          leading: const Icon(Icons.book_rounded, color: Colors.white),
          title: 'Lowongan Tersimpan'.text.sm.white.make(),
          onTap: openVacancies,
        ),
        ListTile(
          leading: const Icon(Icons.loyalty_rounded, color: Colors.white),
          title: 'Tawaran Gabung Tim'.text.sm.white.make(),
          onTap: openTeamOffers,
        ),
        ListTile(
          leading: const Icon(Icons.loyalty_rounded, color: Colors.white),
          title: 'Tawaran Gabung Klub'.text.sm.white.make(),
          onTap: openOffersClub,
        ),
        ListTile(
          leading: const Icon(
            Icons.chat_rounded,
            color: Colors.white,
          ),
          title: 'Konsultasi'.text.sm.white.make(),
          onTap: openConsulting,
        ),
      ]);
    } else if (userData.value.isCoach) {
      menus.addAll([
        ListTile(
          leading: const Icon(Icons.military_tech_rounded, color: Colors.white),
          title: 'Pengalaman'.text.sm.white.make(),
          onTap: openExperiences,
        ),
        ListTile(
          leading: const Icon(Icons.stars_rounded, color: Colors.white),
          title: 'Klub'.text.sm.white.make(),
          onTap: openSearchClub,
        ),
        ListTile(
          leading: const Icon(Icons.loyalty_rounded, color: Colors.white),
          title: 'Tawaran Gabung Tim'.text.sm.white.make(),
          onTap: openTeamOffers,
        ),
        ListTile(
          leading: const Icon(Icons.loyalty_rounded, color: Colors.white),
          title: 'Tawaran Gabung Klub'.text.sm.white.make(),
          onTap: openOffersClub,
        ),
        ListTile(
          leading: const Icon(
            Icons.book_rounded,
            color: Colors.white,
          ),
          title: 'Lowongan Tersimpan'.text.sm.white.make(),
          onTap: openVacancies,
        ),
        ListTile(
          leading: const Icon(
            Icons.chat_rounded,
            color: Colors.white,
          ),
          title: 'Konsultasi'.text.sm.white.make(),
          onTap: openConsulting,
        ),
      ]);
    } else if (userData.value.isClub) {
      menus.addAll([
        ListTile(
          leading: const Icon(
            Icons.transfer_within_a_station_rounded,
            color: Colors.white,
          ),
          title: 'Offering Pemain Klub'.text.sm.white.make(),
          onTap: _clubPlayerOfferings,
        ),
        ListTile(
          leading: const Icon(
            Icons.transfer_within_a_station_rounded,
            color: Colors.white,
          ),
          title: 'Offering Pelatih Klub'.text.sm.white.make(),
          onTap: _clubCoachOfferings,
        ),
        ListTile(
          leading: const Icon(Icons.loyalty_rounded, color: Colors.white),
          title: 'Pelatih Tersimpan'.text.sm.white.make(),
          onTap: _savedCoach,
        ),
        ListTile(
          leading: const Icon(
            Icons.loyalty_rounded,
            color: Colors.white,
          ),
          title: 'Pemain Tersimpan'.text.sm.white.make(),
          onTap: _savedPlayer,
        ),
      ]);
    }
    menus.add(
      ListTile(
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.white,
        ),
        title: 'Logout'.text.sm.white.make(),
        onTap: logout,
      ),
    );
    return menus;
  }

  _clubPlayerOfferings() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(ClubPlayerOfferings.routeName);
  }

  _clubCoachOfferings() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(ClubCoachOfferings.routeName);
  }

  _savedPlayer() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(SavedPlayer.routeName);
  }

  _savedCoach() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(SavedCoach.routeName);
  }

  _toClass() {
    Get.toNamed(CoachClassScreen.routeName);
  }

  _toVerifyTask() {
    Get.toNamed(VerifyTask.routeName);
  }

  _toVerifyTestParams() {
    Get.toNamed(TestParameterList.routeName);
  }

  _toUsers() {
    Get.toNamed(Users.routeName);
  }

  _toProducts() {
    Get.toNamed(ProductManagement.routeName);
  }

  _toClassCategoryManagement() {
    Get.toNamed(ClassCategoryManagement.routeName);
  }

  _toTransfermarket() {
    Get.toNamed(TransferMarket.routeName);
  }

  _toKomik() {
    Get.toNamed(KomikScreen.routeName);
  }

  _toSkillManagement() {
    Get.toNamed(SkillManagement.routeName);
  }

  _toSuspendManagement() {
    Get.toNamed(SuspendManagement.routeName);
  }

  _toVerifyUserDocuments() {
    Get.toNamed(SecureDocuments.routeName);
  }

  _toVerifyPartners() {
    Get.toNamed(AcademyPartners.routeName);
  }

  _toWithdraws() {
    Get.toNamed(Withdraws.routeName);
  }

  _toBanners() {
    Get.toNamed(BannerList.routeName);
  }

  _toVouchers() {
    Get.toNamed(Vouchers.routeName);
  }

  _toEvents() {
    Get.toNamed(Events.routeName);
  }

  _toCompetitions() {
    Get.toNamed(Competitions.routeName);
  }

  _toFaqs() {
    Get.toNamed(Helps.routeName);
  }
}
