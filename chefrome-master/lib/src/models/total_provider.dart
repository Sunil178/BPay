class TotalProvider {
  double _total;
  double _deliveryFee;
  String _method;
  double _subTotal;
  double _finalTax;

  void setTotal(double total) {
    _total = total;
  }

  void setSubTotal(double subTotal) {
    _subTotal = subTotal;
  }

  void setDeliveryFee(double fee) {
    _deliveryFee = fee;
  }

  void setFinalTax(double tax) {
    _finalTax = tax;
  }

  double getTotal() {
    return _total;
  }

  double getSubTotal() {
    return _subTotal;
  }

  double getDeliveryFee() {
    return _deliveryFee;
  }

  double getFinalTax() {
    return _finalTax;
  }

  void setMethod(String m) {
    _method = m;
  }

  String getMethod() {
    return _method;
  }
}
