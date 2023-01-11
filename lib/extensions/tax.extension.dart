extension TaxExtension on double {
  double? addPriceTax({int taxValue = 11}) {
    double tax = taxValue / 100;
    double totalTax = this * tax;
    double totalPrice = this + totalTax;
    return totalPrice;
  }
}
