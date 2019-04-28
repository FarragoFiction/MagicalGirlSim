import 'Amulet.dart';
import 'BloodPact.dart';

abstract class Companion {

    static int get price {
        return bloodPacts.map((CompanionBloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
    }

    static int get unpaidPacts {
        return bloodPacts.where((CompanionBloodPact pact) =>pact.cost != 0 ).length;
    }

    static void clearDebts() {
        bloodPacts.where((CompanionBloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
    }

    static int get damageMultiplier => Amulet.damageMultiplier *bloodPacts.length + 1;
    static List<CompanionBloodPact> bloodPacts = <CompanionBloodPact>[];
}