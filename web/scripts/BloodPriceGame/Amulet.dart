import 'BloodPact.dart';

abstract class Amulet {

    static int get price {
        return bloodPacts.map((LegacyBloodPact pact) =>pact.cost ).reduce((int value, int element) => value + element);
    }

    //if a pact is in play and its cost is not zero, its unpaid
    static int get unpaidPacts {
        return bloodPacts.where((LegacyBloodPact pact) =>pact.cost != 0 ).length;
    }

    static int get damageMultiplier => bloodPacts.length;
    static List<LegacyBloodPact> bloodPacts = <LegacyBloodPact>[];
    static String get sacrificesWithin => bloodPacts.map((LegacyBloodPact bp) => bp.sacrificeName).toSet().join(",");
}