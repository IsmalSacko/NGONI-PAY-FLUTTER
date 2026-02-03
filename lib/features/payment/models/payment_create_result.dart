class PaymentCreateResult {
  final String? checkoutUrl;
  final int? paymentId;
  final String? status;

  const PaymentCreateResult({
    this.checkoutUrl,
    this.paymentId,
    this.status,
  });
}
