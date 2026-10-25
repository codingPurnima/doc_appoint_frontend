import 'dart:convert';

import 'package:flutter/widgets.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  RazorpayService({required this.baseUrl, required this.getToken});

  final String baseUrl;
  final Future<String?> Function() getToken;

  final Razorpay _razorpay = Razorpay();

  void Function(String message)? onMessage;
  void Function(int appointmentId)? onPaymentVerified;

  void initialize() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> payForSlot(int slotId) async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        onMessage?.call('Please log in again.');
        return;
      }

      final orderResponse = await http.post(
        Uri.parse('$baseUrl/payments/create-booking?slot_id=$slotId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (orderResponse.statusCode < 200 || orderResponse.statusCode >= 300) {
        onMessage?.call('Could not create booking. Check existing bookings.');
        return;
      }

      final order = jsonDecode(orderResponse.body);

      _razorpay.open({
        'key': order['key_id'],
        'amount': order['amount'],
        'currency': order['currency'] ?? 'INR',
        'name': 'DocAppoint',
        'description': 'Doctor appointment',
        'order_id': order['order_id'],
        'timeout': 300,
      });
    } catch (e) {
      onMessage?.call('Unable to start payment: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final token = await getToken();

      if (token == null ||
          response.orderId == null ||
          response.paymentId == null ||
          response.signature == null) {
        onMessage?.call(
          'Payment response is incomplete. Please contact support.',
        );
        return;
      }

      final result = await http.post(
        Uri.parse('$baseUrl/payments/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'razorpay_order_id': response.orderId,
          'razorpay_payment_id': response.paymentId,
          'razorpay_signature': response.signature,
        }),
      );

      if (result.statusCode >= 200 && result.statusCode < 300) {
        final data = jsonDecode(result.body);
        onPaymentVerified?.call(data['appointment_id'] as int);
        onMessage?.call('Payment verified. Appointment confirmed!');
      } else {
        onMessage?.call(
          'Payment received, but confirmation is pending. '
          'Please check your appointments before trying again.',
        );
      }
    } catch (e) {
      onMessage?.call(
        'Could not confirm payment. Please check your appointments.',
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    onMessage?.call(
      'Payment was not completed. Please try again. ',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    onMessage?.call(
      'External wallet selected: ${response.walletName ?? 'Unknown'}',
    );
  }
    
  Future<List<Map<String, dynamic>>> getPendingPayments() async {
    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/payments/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('Pending payments failed: ${response.body}');
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return (data['pending_payments'] as List)
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      debugPrint('Error fetching pending payments: $e');
      return [];
    }
  }

  
  Future<void> resumePayment(int appointmentId) async {
    try {
      final pendingPayments = await getPendingPayments();

      Map<String, dynamic>? pending;

      for (final payment in pendingPayments) {
        if (payment['appointment_id']?.toString() ==
            appointmentId.toString()) {
          pending = payment;
          break;
        }
      }

      if (pending == null) {
        onMessage?.call(
          'This payment is no longer available. '
          'Please refresh your appointments.',
        );
        return;
      }

      final orderId = pending['order_id']?.toString();
      final keyId = pending['key_id']?.toString();
      final amount = pending['amount'];

      if (orderId == null ||
          orderId.isEmpty ||
          keyId == null ||
          keyId.isEmpty ||
          amount == null) {
        onMessage?.call('Payment details are incomplete. Please try again.');
        return;
      }

      _razorpay.open({
        'key': keyId,
        'amount': amount,
        'currency': pending['currency'] ?? 'INR',
        'name': 'DocAppoint',
        'description': 'Resume appointment payment',
        'order_id': orderId,
        'timeout': 300,
      });
    } catch (e) {
      onMessage?.call('Unable to resume payment. Please try again.');
      debugPrint('Resume payment error: $e');
    }
  }



  void dispose() {
    _razorpay.clear();
  }
}
