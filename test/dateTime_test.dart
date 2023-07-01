import 'package:flutter_test/flutter_test.dart';
import 'package:safe_neighborhood/models/utils.dart';

Future main() async {
  group("Analise valor limite - horario", () {
    test("Manhã - Tarde", () {
      DateTime time = DateTime(2023, 1, 1, 11, 59, 59); // 01/01/2023 - 11:59:59
      String period = Utils.resolvePeriod(time);
      expect(period, "Manhã");

      time = DateTime(2023, 1, 1, 12, 00, 00); // 01/01/2023 - 12:00:00
      period = Utils.resolvePeriod(time);
      expect(period, "Tarde");

      time = DateTime(2023, 1, 1, 12, 00, 01); // 01/01/2023 - 12:00:01
      period = Utils.resolvePeriod(time);
      expect(period, "Tarde");
    });

    test("Tarde - Noite", () {
      DateTime time = DateTime(2023, 1, 1, 17, 59, 59); // 01/01/2023 - 17:59:59
      String period = Utils.resolvePeriod(time);
      expect(period, "Tarde");

      time = DateTime(2023, 1, 1, 18, 00, 00); // 01/01/2023 - 18:00:00
      period = Utils.resolvePeriod(time);
      expect(period, "Noite");

      time = DateTime(2023, 1, 1, 18, 00, 01); // 01/01/2023 - 18:00:01
      period = Utils.resolvePeriod(time);
      expect(period, "Noite");
    });
  });
}