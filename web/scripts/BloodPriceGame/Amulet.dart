import 'BloodPact.dart';

abstract class Amulet {
    static int get damageMultiplier => bloodPacts.length;
    static List<LegacyBloodPact> bloodPacts = <LegacyBloodPact>[];
    static String get sacrificesWithin => bloodPacts.map((LegacyBloodPact bp) => bp.sacrificeName).toSet().join(",");
}