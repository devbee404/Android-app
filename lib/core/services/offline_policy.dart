/// Keep optional network integrations isolated from learning features.
///
/// AdMob and Play Billing may need connectivity. A failed request must never
/// prevent bundled lessons, Quran text, duas, or quizzes from opening.
class OfflinePolicy {
  const OfflinePolicy();

  bool get coreContentRequiresNetwork => false;
  bool get adsRequireNetwork => true;
  bool get billingMayRequireNetwork => true;
}
