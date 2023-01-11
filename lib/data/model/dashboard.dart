class Dashboard {
  int? totalPlayers;
  int? totalCoaches;
  int? totalClub;
  int? totalTasks;
  int? verifiedTaskCount;
  int? verifiedPlayerCount;
  int? verifiedPartnerCount;
  int? verifiedAccountCount;

  Dashboard({
    this.totalClub,
    this.totalCoaches,
    this.totalPlayers,
    this.totalTasks,
    this.verifiedAccountCount,
    this.verifiedPartnerCount,
    this.verifiedPlayerCount,
    this.verifiedTaskCount,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    totalClub: json['total_club'] as int?,
    totalCoaches: json['total_coach'] as int?,
    totalPlayers: json['total_players'] as int?,
    totalTasks: json['total_task'] as int?,
    verifiedAccountCount: json['verified_account_count'] as int?,
    verifiedPartnerCount: json['verified_partner_count'] as int?,
    verifiedPlayerCount: json['verified_player_count'] as int?,
    verifiedTaskCount: json['verified_task_count'] as int?,
  );

  Map<String, dynamic> toJson() {
    return {
      'total_club': totalClub,
      'total_coach': totalCoaches,
      'total_players': totalPlayers,
      'total_task': totalTasks,
      'verified_account_count': verifiedAccountCount,
      'verified_partner_count': verifiedPartnerCount,
      'verified_player_count': verifiedPlayerCount,
      'verified_task_count': verifiedTaskCount,
    };
  }
}
