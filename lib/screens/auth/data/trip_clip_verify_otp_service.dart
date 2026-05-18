/// Result of submitting an SMS OTP for the given mobile number.
sealed class TripClipOtpVerifyResult {
  const TripClipOtpVerifyResult();
}

class TripClipOtpVerifySuccess extends TripClipOtpVerifyResult {
  const TripClipOtpVerifySuccess();
}

class TripClipOtpVerifyFailure extends TripClipOtpVerifyResult {
  const TripClipOtpVerifyFailure(this.message);

  final String message;
}

abstract class TripClipVerifyOtpService {
  Future<TripClipOtpVerifyResult> verify({
    required String mobileRaw,
    required String otp,
  });
}

final class MockTripClipVerifyOtpService implements TripClipVerifyOtpService {
  const MockTripClipVerifyOtpService();

  static const String validMockCode = '889234';

  static const String defaultErrorMessage =
      'Oops! Try again or resend the code below.';

  @override
  Future<TripClipOtpVerifyResult> verify({
    required String mobileRaw,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (otp == validMockCode) {
      return const TripClipOtpVerifySuccess();
    }
    return const TripClipOtpVerifyFailure(defaultErrorMessage);
  }
}
