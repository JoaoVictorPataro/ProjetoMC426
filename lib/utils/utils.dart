class FieldUtils {
  static const timeLabels = ["Qualquer periodo",
    "Madrugada",
    "Manhã",
    "Tarde",
    "Noite"];
  static const typesValues = ["Qualquer Tipo",
  "Roubo",
  "Furto"];
  static String resolvePeriod(int hour) {
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