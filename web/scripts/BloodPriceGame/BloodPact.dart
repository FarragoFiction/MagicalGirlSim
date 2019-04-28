import 'package:CommonLib/Random.dart';

import 'Amulet.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';
import 'Companion.dart';

abstract class BloodPact {
/*
    A magical girl can have 0 or more blood pacts running at a time, in several categories.
    Health
    Weapon
    Magic
    Companion (attacked to :hatch_chick:
    Legacy (attacked but to the amulet)

    A blood pact has a BLOOD COST associated with it. Its stable. At the end of a fight you pay all blood costs not yet zeroed out.

    If you die, all the blood pacts on you are removed. (but not on legacy/companion)
 */
    static const String WEAPON = "WEAPON";
    static const String MAGICATTACK = "MAGICATTACK";
    static const String NAME = "NAME";

    int cost = 9999;
    String name = "GLITCH";
    List<String> flavorTexts = <String>["Its' glitched."];

    String get flavorText {
        Random rand = new Random();
        String ret = rand.pickFrom(flavorTexts);
        BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
        ret = ret.replaceAll(WEAPON,girl.weapon);
        ret = ret.replaceAll(MAGICATTACK,girl.magical_attack);
        ret = ret.replaceAll(NAME,girl.name);
        return ret;

    }


}

class LegacyBloodPact extends BloodPact {
    String sacrificeName;

    LegacyBloodPact(String this.sacrificeName) {
        cost = 113;
        name = "Legacy Blood Pact";
        flavorTexts = <String>["${BloodPact.NAME} fills the AMULET with their hopes for the future. They join the ranks of ${Amulet.sacrificesWithin}."];
    }

    @override
  String toString() {
        return sacrificeName;
    }
}


class CompanionBloodPact extends BloodPact {

    @override
  String get flavorText {
        String ret = "";
        for(BloodPact b in Companion.bloodPacts) {
            ret = "$ret 🐥 ";
        }
        return ret;
    }

    MagicBloodPact() {
        cost = 13;
        name = "Companion Blood Pact";
        //TODO just loop on how many blood pacts are attached to the 🐥  and then have that many print out.
        flavorTexts = <String>["🐥 ", "🐥 🐥 ","🐥 🐥 🐥 ","🐥 🐥 🐥 🐥 "];
    }
}

class MagicBloodPact extends BloodPact {

    MagicBloodPact() {
        cost = 13;
        name = "Magic Blood Pact";
        flavorTexts = <String>["Shining in the center of the ${BloodPact.MAGICATTACK}} is the face of ${BloodPact.NAME}}, screaming. ", "You could swear you faintly hear the screams of ${BloodPact.NAME} from the ${BloodPact.MAGICATTACK}}}."];
    }
}

class WeaponBloodPact extends BloodPact {

    HealthBloodPact() {
        cost = 13;
        name = "Weapon Blood Pact";
        flavorTexts = <String>["The ${BloodPact.WEAPON}} glows ominously.", "You could swear you faintly hear the screams of ${BloodPact.NAME} from the ${BloodPact.WEAPON}}}."];
    }
}

class HealthBloodPact extends BloodPact {

    int healthToRestore = 75;

    HealthBloodPact() {
        cost = 75;
        name = "Health Blood Pact";
        flavorTexts = <String>["A terrible surge of borrowed life fills ${BloodPact.NAME}."];
    }
}