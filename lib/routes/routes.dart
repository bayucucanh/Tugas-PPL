import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/ui/about/about_screen.dart';
import 'package:mobile_pssi/ui/academy_partner/academy_partners.dart';
import 'package:mobile_pssi/ui/academy_partner/apply_partner.dart';
import 'package:mobile_pssi/ui/academy_partner/view_partner.dart';
import 'package:mobile_pssi/ui/achievement/achievement_list.dart';
import 'package:mobile_pssi/ui/achievement/add_achievement.dart';
import 'package:mobile_pssi/ui/bank_account/add_bank_account.dart';
import 'package:mobile_pssi/ui/bank_account/bank_accounts.dart';
import 'package:mobile_pssi/ui/banners/banner_list.dart';
import 'package:mobile_pssi/ui/banners/new_banner.dart';
import 'package:mobile_pssi/ui/championships/add_championship.dart';
import 'package:mobile_pssi/ui/championships/championships.dart';
import 'package:mobile_pssi/ui/class/add_class_screen.dart';
import 'package:mobile_pssi/ui/class/add_video_class_screen.dart';
import 'package:mobile_pssi/ui/class/class_detail_screen.dart';
import 'package:mobile_pssi/ui/class/class_screen.dart';
import 'package:mobile_pssi/ui/class/coach_class_screen.dart';
import 'package:mobile_pssi/ui/class/edit_class.dart';
import 'package:mobile_pssi/ui/class/edit_video_class.dart';
import 'package:mobile_pssi/ui/class/scanned_player_class.dart';
import 'package:mobile_pssi/ui/class_category/add_class_category.dart';
import 'package:mobile_pssi/ui/class_category/class_category_management.dart';
import 'package:mobile_pssi/ui/class_category/edit_class_category.dart';
import 'package:mobile_pssi/ui/club/club_coaches.dart';
import 'package:mobile_pssi/ui/club/club_detail.dart';
import 'package:mobile_pssi/ui/club/club_list.dart';
import 'package:mobile_pssi/ui/club/club_players.dart';
import 'package:mobile_pssi/ui/club/club_promo_detail.dart';
import 'package:mobile_pssi/ui/club/vacancy_list.dart';
import 'package:mobile_pssi/ui/coach/coach_class.dart';
import 'package:mobile_pssi/ui/coach/coach_list.dart';
import 'package:mobile_pssi/ui/competitions/add_competition.dart';
import 'package:mobile_pssi/ui/competitions/all_events.dart';
import 'package:mobile_pssi/ui/competitions/competitions.dart';
import 'package:mobile_pssi/ui/consulting/add_auto_text.dart';
import 'package:mobile_pssi/ui/consulting/auto_texts.dart';
import 'package:mobile_pssi/ui/consulting/classification_detail.dart';
import 'package:mobile_pssi/ui/consulting/consult_list.dart';
import 'package:mobile_pssi/ui/consulting/consult_room.dart';
import 'package:mobile_pssi/ui/dashboard/dashboard_screen.dart';
import 'package:mobile_pssi/ui/events/add_event.dart';
import 'package:mobile_pssi/ui/events/all_events.dart';
import 'package:mobile_pssi/ui/events/edit_event.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/ui/events/event_participants.dart';
import 'package:mobile_pssi/ui/events/events.dart';
import 'package:mobile_pssi/ui/events/team_event_detail.dart';
import 'package:mobile_pssi/ui/experiences/add_experience.dart';
import 'package:mobile_pssi/ui/experiences/experiences.dart';
import 'package:mobile_pssi/ui/forgot_password/forgot_password.dart';
import 'package:mobile_pssi/ui/help/add_help.dart';
import 'package:mobile_pssi/ui/help/edit_help.dart';
import 'package:mobile_pssi/ui/help/help_detail.dart';
import 'package:mobile_pssi/ui/help/help_screen.dart';
import 'package:mobile_pssi/ui/help/helps.dart';
import 'package:mobile_pssi/ui/history/history_screen.dart';
import 'package:mobile_pssi/ui/komik/komik_detail.dart';
import 'package:mobile_pssi/ui/komik/komik_screen.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:mobile_pssi/ui/notification/notification_screen.dart';
import 'package:mobile_pssi/ui/offering/offer_list_club.dart';
import 'package:mobile_pssi/ui/offering/offer_team_coach_list.dart';
import 'package:mobile_pssi/ui/offering/offer_team_player_list.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_coach.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_player.dart';
import 'package:mobile_pssi/ui/payment/payment.dart';
import 'package:mobile_pssi/ui/payment/payment_history.dart';
import 'package:mobile_pssi/ui/premium/club_premium_store.dart';
import 'package:mobile_pssi/ui/premium/premium_join_screen.dart';
import 'package:mobile_pssi/ui/product_management/add_product.dart';
import 'package:mobile_pssi/ui/product_management/edit_product.dart';
import 'package:mobile_pssi/ui/product_management/product_management.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/profile/personal_data.dart';
import 'package:mobile_pssi/ui/profile/player/player_profile.dart';
import 'package:mobile_pssi/ui/recent_educations/add_education.dart';
import 'package:mobile_pssi/ui/recent_educations/educations.dart';
import 'package:mobile_pssi/ui/register/register_screen.dart';
import 'package:mobile_pssi/ui/reviews/reviews.dart';
import 'package:mobile_pssi/ui/scanner/scanner.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_coach_offerings.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_player_offerings.dart';
import 'package:mobile_pssi/ui/scouting/coach_scouting.dart';
import 'package:mobile_pssi/ui/scouting/offer_form_coach.dart';
import 'package:mobile_pssi/ui/scouting/offer_form_player.dart';
import 'package:mobile_pssi/ui/scouting/player_scouting.dart';
import 'package:mobile_pssi/ui/scouting/saved_coach.dart';
import 'package:mobile_pssi/ui/scouting/saved_player.dart';
import 'package:mobile_pssi/ui/scouting/scouting_club_coach_history.dart';
import 'package:mobile_pssi/ui/scouting/scouting_club_player_history.dart';
import 'package:mobile_pssi/ui/scouting/scouting_coach_history.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_history.dart';
import 'package:mobile_pssi/ui/search/search_screen.dart';
import 'package:mobile_pssi/ui/secure_documents/secure_documents.dart';
import 'package:mobile_pssi/ui/secure_documents/user_documents.dart';
import 'package:mobile_pssi/ui/security_account/change_password.dart';
import 'package:mobile_pssi/ui/security_account/security_account.dart';
import 'package:mobile_pssi/ui/skill_management/add_skill.dart';
import 'package:mobile_pssi/ui/skill_management/edit_skill.dart';
import 'package:mobile_pssi/ui/skill_management/skill_management.dart';
import 'package:mobile_pssi/ui/splash/splash_screen.dart';
import 'package:mobile_pssi/ui/statistics/detail_statistic.dart';
import 'package:mobile_pssi/ui/subscriptions/my_subscriptions.dart';
import 'package:mobile_pssi/ui/suspend/add_suspend.dart';
import 'package:mobile_pssi/ui/suspend/suspend_management.dart';
import 'package:mobile_pssi/ui/task_detail/task_detail.dart';
import 'package:mobile_pssi/ui/teams/coach_club_invite.dart';
import 'package:mobile_pssi/ui/teams/edit_team.dart';
import 'package:mobile_pssi/ui/teams/new_team.dart';
import 'package:mobile_pssi/ui/teams/player_club_detail.dart';
import 'package:mobile_pssi/ui/teams/player_club_invite.dart';
import 'package:mobile_pssi/ui/teams/team_detail.dart';
import 'package:mobile_pssi/ui/teams/team_screen.dart';
import 'package:mobile_pssi/ui/test_parameter/attack_tactic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/defend_tactic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/mental_form.dart';
import 'package:mobile_pssi/ui/test_parameter/physic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/technique_form.dart';
import 'package:mobile_pssi/ui/test_parameter/test_parameter.dart';
import 'package:mobile_pssi/ui/transfer_market/add_promo.dart';
import 'package:mobile_pssi/ui/transfer_market/detail_promotion.dart';
import 'package:mobile_pssi/ui/transfer_market/new_student_participants.dart';
import 'package:mobile_pssi/ui/transfer_market/promo_performance.dart';
import 'package:mobile_pssi/ui/transfer_market/selection_participants.dart';
import 'package:mobile_pssi/ui/transfer_market/transfer_market.dart';
import 'package:mobile_pssi/ui/users/new_user.dart';
import 'package:mobile_pssi/ui/users/user_detail.dart';
import 'package:mobile_pssi/ui/users/users.dart';
import 'package:mobile_pssi/ui/verify_performance/test_parameter_list.dart';
import 'package:mobile_pssi/ui/verify_performance/verify_test_params.dart';
import 'package:mobile_pssi/ui/verify_task/verify_task.dart';
import 'package:mobile_pssi/ui/verify_task/verify_video_detail.dart';
import 'package:mobile_pssi/ui/voucher/active_vouchers.dart';
import 'package:mobile_pssi/ui/voucher/add_voucher.dart';
import 'package:mobile_pssi/ui/voucher/vouchers.dart';
import 'package:mobile_pssi/ui/watch/watch.screen.dart';
import 'package:mobile_pssi/ui/withdraw/withdraws.dart';

List<GetPage> pages = [
  GetPage(name: SplashScreen.routeName, page: () => const SplashScreen()),
  GetPage(name: LoginScreen.routeName, page: () => const LoginScreen()),
  GetPage(name: DashboardScreen.routeName, page: () => const DashboardScreen()),
  GetPage(name: RegisterScreen.routeName, page: () => const RegisterScreen()),
  GetPage(name: ClassScreen.routeName, page: () => const ClassScreen()),
  GetPage(
      name: ClassDetailScreen.routeName, page: () => const ClassDetailScreen()),
  GetPage(
      name: CoachClassScreen.routeName, page: () => const CoachClassScreen()),
  GetPage(name: AddClassScreen.routeName, page: () => const AddClassScreen()),
  GetPage(name: EditClass.routeName, page: () => const EditClass()),
  GetPage(
      name: AddVideoClassScreen.routeName,
      page: () => const AddVideoClassScreen()),
  GetPage(
      name: EditVideoClassScreen.routeName,
      page: () => const EditVideoClassScreen()),
  GetPage(name: WatchScreen.routeName, page: () => const WatchScreen()),
  GetPage(
      name: NotificationScreen.routeName,
      page: () => const NotificationScreen()),
  GetPage(name: PlayerProfile.routeName, page: () => const PlayerProfile()),
  GetPage(name: DetailStatistic.routeName, page: () => const DetailStatistic()),
  GetPage(name: AchievementList.routeName, page: () => const AchievementList()),
  GetPage(name: ClubList.routeName, page: () => const ClubList()),
  GetPage(name: VacancyList.routeName, page: () => const VacancyList()),
  GetPage(name: OfferListClub.routeName, page: () => const OfferListClub()),
  GetPage(name: ConsultList.routeName, page: () => const ConsultList()),
  GetPage(name: PersonalData.routeName, page: () => const PersonalData()),
  GetPage(name: HelpScreen.routeName, page: () => const HelpScreen()),
  GetPage(name: AboutScreen.routeName, page: () => const AboutScreen()),
  GetPage(
      name: PremiumJoinScreen.routeName,
      transition: Transition.fade,
      page: () => const PremiumJoinScreen()),
  GetPage(name: TaskDetail.routeName, page: () => const TaskDetail()),
  GetPage(name: HistoryScreen.routeName, page: () => const HistoryScreen()),
  GetPage(name: VerifyTask.routeName, page: () => const VerifyTask()),
  GetPage(
      name: VerifyVideoDetail.routeName, page: () => const VerifyVideoDetail()),
  GetPage(name: TestParameter.routeName, page: () => const TestParameter()),
  GetPage(name: TechniqueForm.routeName, page: () => const TechniqueForm()),
  GetPage(name: PhysicForm.routeName, page: () => const PhysicForm()),
  GetPage(name: MentalForm.routeName, page: () => const MentalForm()),
  GetPage(
      name: AttackTacticForm.routeName, page: () => const AttackTacticForm()),
  GetPage(
      name: DefendTacticForm.routeName, page: () => const DefendTacticForm()),
  GetPage(
      name: TestParameterList.routeName, page: () => const TestParameterList()),
  GetPage(
      name: VerifyTestParams.routeName, page: () => const VerifyTestParams()),
  GetPage(name: CoachProfile.routeName, page: () => const CoachProfile()),
  GetPage(name: AddAchievement.routeName, page: () => const AddAchievement()),
  GetPage(name: PlayerScouting.routeName, page: () => const PlayerScouting()),
  GetPage(name: CoachScouting.routeName, page: () => const CoachScouting()),
  GetPage(
      name: ScoutingPlayerDetail.routeName,
      page: () => const ScoutingPlayerDetail()),
  GetPage(name: OfferFormPlayer.routeName, page: () => const OfferFormPlayer()),
  GetPage(
      name: OfferingJoinClubPlayer.routeName,
      page: () => const OfferingJoinClubPlayer()),
  GetPage(
      name: ScoutingPlayerHistory.routeName,
      page: () => const ScoutingPlayerHistory()),
  GetPage(name: SavedPlayer.routeName, page: () => const SavedPlayer()),
  GetPage(name: SavedCoach.routeName, page: () => const SavedCoach()),
  GetPage(name: SecurityAccount.routeName, page: () => const SecurityAccount()),
  GetPage(name: TeamScreen.routeName, page: () => const TeamScreen()),
  GetPage(name: NewTeam.routeName, page: () => const NewTeam()),
  GetPage(name: TeamDetail.routeName, page: () => const TeamDetail()),
  GetPage(
      name: PlayerClubInvite.routeName, page: () => const PlayerClubInvite()),
  GetPage(
      name: PlayerClubDetail.routeName, page: () => const PlayerClubDetail()),
  GetPage(name: Payment.routeName, page: () => const Payment()),
  GetPage(name: PaymentHistory.routeName, page: () => const PaymentHistory()),
  GetPage(
      name: ChangePasswordScreen.routeName,
      page: () => const ChangePasswordScreen()),
  GetPage(name: ForgotPassword.routeName, page: () => const ForgotPassword()),
  GetPage(name: PdfReader.routeName, page: () => const PdfReader()),
  GetPage(
      name: OfferTeamPlayerList.routeName,
      page: () => const OfferTeamPlayerList()),
  GetPage(name: OfferFormCoach.routeName, page: () => const OfferFormCoach()),
  GetPage(
      name: OfferingJoinClubCoach.routeName,
      page: () => const OfferingJoinClubCoach()),
  GetPage(
      name: ScoutingCoachHistory.routeName,
      page: () => const ScoutingCoachHistory()),
  GetPage(name: CoachClubInvite.routeName, page: () => const CoachClubInvite()),
  GetPage(
      name: OfferTeamCoachList.routeName,
      page: () => const OfferTeamCoachList()),
  GetPage(name: Users.routeName, page: () => const Users()),
  GetPage(name: UserDetail.routeName, page: () => const UserDetail()),
  GetPage(name: NewUser.routeName, page: () => const NewUser()),
  GetPage(name: ConsultRoom.routeName, page: () => const ConsultRoom()),
  GetPage(name: BannerList.routeName, page: () => const BannerList()),
  GetPage(name: NewBanner.routeName, page: () => const NewBanner()),
  GetPage(name: TransferMarket.routeName, page: () => const TransferMarket()),
  GetPage(name: KomikScreen.routeName, page: () => const KomikScreen()),
  GetPage(name: KomikDetail.routeName, page: () => const KomikDetail()),
  GetPage(name: AddPromo.routeName, page: () => const AddPromo()),
  GetPage(name: DetailPromotion.routeName, page: () => const DetailPromotion()),
  GetPage(name: ClubPromoDetail.routeName, page: () => const ClubPromoDetail()),
  GetPage(
      name: SelectionParticipants.routeName,
      page: () => const SelectionParticipants()),
  GetPage(
      name: NewStudentParticipants.routeName,
      page: () => const NewStudentParticipants()),
  GetPage(
      name: PromoPerformance.routeName, page: () => const PromoPerformance()),
  GetPage(name: Helps.routeName, page: () => const Helps()),
  GetPage(name: AddHelp.routeName, page: () => const AddHelp()),
  GetPage(name: HelpDetail.routeName, page: () => const HelpDetail()),
  GetPage(name: EditHelp.routeName, page: () => const EditHelp()),
  GetPage(name: ClubDetail.routeName, page: () => const ClubDetail()),
  GetPage(name: SecureDocuments.routeName, page: () => const SecureDocuments()),
  GetPage(name: UserDocuments.routeName, page: () => const UserDocuments()),
  GetPage(name: SkillManagement.routeName, page: () => const SkillManagement()),
  GetPage(name: AddSkill.routeName, page: () => const AddSkill()),
  GetPage(name: EditSkill.routeName, page: () => const EditSkill()),
  GetPage(
      name: ClassCategoryManagement.routeName,
      page: () => const ClassCategoryManagement()),
  GetPage(
      name: AddClassCategory.routeName, page: () => const AddClassCategory()),
  GetPage(
      name: EditClassCategory.routeName, page: () => const EditClassCategory()),
  GetPage(
      name: SuspendManagement.routeName, page: () => const SuspendManagement()),
  GetPage(name: AddSuspend.routeName, page: () => const AddSuspend()),
  GetPage(name: ApplyPartner.routeName, page: () => const ApplyPartner()),
  GetPage(
      name: ProductManagement.routeName, page: () => const ProductManagement()),
  GetPage(name: AddProduct.routeName, page: () => const AddProduct()),
  GetPage(name: EditProduct.routeName, page: () => const EditProduct()),
  GetPage(name: AcademyPartners.routeName, page: () => const AcademyPartners()),
  GetPage(name: ViewPartner.routeName, page: () => const ViewPartner()),
  GetPage(
      name: ClassificationDetail.routeName,
      page: () => const ClassificationDetail()),
  GetPage(name: CoachList.routeName, page: () => const CoachList()),
  GetPage(name: ClubCoaches.routeName, page: () => const ClubCoaches()),
  GetPage(name: ClubPlayers.routeName, page: () => const ClubPlayers()),
  GetPage(name: CoachClass.routeName, page: () => const CoachClass()),
  GetPage(
      name: ClubPremiumStore.routeName,
      transition: Transition.fade,
      page: () => const ClubPremiumStore()),
  GetPage(
      name: ScoutingClubPlayerHistory.routeName,
      page: () => const ScoutingClubPlayerHistory()),
  GetPage(
      name: ClubPlayerOfferings.routeName,
      page: () => const ClubPlayerOfferings()),
  GetPage(
      name: ScoutingClubCoachHistory.routeName,
      page: () => const ScoutingClubCoachHistory()),
  GetPage(
      name: ClubCoachOfferings.routeName,
      page: () => const ClubCoachOfferings()),
  GetPage(name: MySubscriptions.routeName, page: () => const MySubscriptions()),
  GetPage(name: SearchScreen.routeName, page: () => const SearchScreen()),
  GetPage(name: Vouchers.routeName, page: () => const Vouchers()),
  GetPage(name: AddVoucher.routeName, page: () => const AddVoucher()),
  GetPage(name: MyVouchers.routeName, page: () => const MyVouchers()),
  GetPage(name: Events.routeName, page: () => const Events()),
  GetPage(name: AddEvent.routeName, page: () => const AddEvent()),
  GetPage(name: EditEvent.routeName, page: () => const EditEvent()),
  GetPage(name: EventDetail.routeName, page: () => const EventDetail()),
  GetPage(
      name: EventParticipants.routeName, page: () => const EventParticipants()),
  GetPage(name: AllEvents.routeName, page: () => const AllEvents()),
  GetPage(name: Competitions.routeName, page: () => const Competitions()),
  GetPage(name: AddCompetition.routeName, page: () => const AddCompetition()),
  GetPage(name: AllCompetition.routeName, page: () => const AllCompetition()),
  GetPage(name: EventTeamDetail.routeName, page: () => const EventTeamDetail()),
  GetPage(name: EditTeam.routeName, page: () => const EditTeam()),
  GetPage(name: AutoTexts.routeName, page: () => const AutoTexts()),
  GetPage(name: AddAutoText.routeName, page: () => const AddAutoText()),
  GetPage(name: Experiences.routeName, page: () => const Experiences()),
  GetPage(name: AddExperience.routeName, page: () => const AddExperience()),
  GetPage(name: Educations.routeName, page: () => const Educations()),
  GetPage(name: AddEducation.routeName, page: () => const AddEducation()),
  GetPage(name: Championships.routeName, page: () => const Championships()),
  GetPage(name: AddChampionship.routeName, page: () => const AddChampionship()),
  GetPage(name: Withdraws.routeName, page: () => const Withdraws()),
  GetPage(name: BankAccounts.routeName, page: () => const BankAccounts()),
  GetPage(name: AddBankAccount.routeName, page: () => const AddBankAccount()),
  GetPage(name: Reviews.routeName, page: () => const Reviews()),
  GetPage(name: Scanner.routeName, page: () => const Scanner()),
  GetPage(
      name: ScannedPlayerClass.routeName,
      page: () => const ScannedPlayerClass()),
];
