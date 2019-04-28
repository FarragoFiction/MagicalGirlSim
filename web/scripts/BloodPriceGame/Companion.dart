import 'Amulet.dart';
import 'BloodPact.dart';

abstract class Companion {

    static int get price {
        return bloodPacts.map((CompanionBloodPact pact) =>pact.cost ).reduce((int value, int element) => value + element);
    }

    static int get unpaidPacts {
        return bloodPacts.where((CompanionBloodPact pact) =>pact.cost != 0 ).length;
    }

    static int get damageMultiplier => Amulet.damageMultiplier *bloodPacts.length + 1;
    static List<CompanionBloodPact> bloodPacts = <CompanionBloodPact>[];
}