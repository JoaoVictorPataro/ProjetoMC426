class Utils {
  static String resolvePeriod(DateTime time) {
    int hour = time.hour;
    if (hour >= 0 && hour < 6) {
      return "Madrugada";
    }
    if (hour >= 6 && hour < 12) {
      return "Manhã";
    }
    if (hour >= 12 && hour < 18) {
      return "Tarde";
    }
    return "Noite";
  }
}