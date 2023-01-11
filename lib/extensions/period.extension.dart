extension SubscribePeriod on String {
  String? get convertedPeriod {
    String? period;
    switch (this) {
      case 'P1W':
        period = 'Minggu';
        break;
      case 'P1M':
        period = 'Bulan';
        break;
      case 'P3M':
        period = '3 Bulan';
        break;
      case 'P6M':
        period = '6 Bulan';
        break;
      case 'P1Y':
        period = 'Tahun';
        break;
    }
    return period;
  }
}
