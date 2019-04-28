import 'Amulet.dart';
import 'BloodPact.dart';

abstract class Companion {
    static int get damageMultiplier => Amulet.damageMultiplier *bloodPacts.length + 1;
    static List<CompanionBloodPact> bloodPacts = <CompanionBloodPact>[];
}