class PracticeFeature {
  const PracticeFeature._();

  static const route = '/practice';
  static const modeRoute = '/practice/:mode';
  static String modePath(String mode) => '/practice/$mode';
}
