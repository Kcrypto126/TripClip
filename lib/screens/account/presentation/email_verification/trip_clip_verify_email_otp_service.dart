import '../../../auth/data/trip_clip_verify_otp_service.dart';

abstract class TripClipVerifyEmailOtpService {
  Future<TripClipOtpVerifyResult> verify({
    required String emailRaw,
    required String otp,
  });
}

final class MockTripClipVerifyEmailOtpService
    implements TripClipVerifyEmailOtpService {
  const MockTripClipVerifyEmailOtpService();

  static const String validMockCode = '889234';

  static const String defaultErrorMessage =
      'Oops! Try again or resend the code below.';

  @override
  Future<TripClipOtpVerifyResult> verify({
    required String emailRaw,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (otp == validMockCode) {
      return const TripClipOtpVerifySuccess();
    }
    return const TripClipOtpVerifyFailure(defaultErrorMessage);
  }
}
