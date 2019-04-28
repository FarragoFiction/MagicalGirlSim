import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'Amulet.dart';
import 'BloodPact.dart';
import 'Companion.dart';

class BloodPriceGirl extends MagicalGirlCharacterObject{
    //TODO when a magic girl dies, zero out all unpaid pacts

    int hp = 113;

    int get price {
        int weapon =  weaponPacts.map((BloodPact pact) =>pact.cost ).reduce((int value, int element) => value + element);
        int magic =  magicPacts.map((BloodPact pact) =>pact.cost ).reduce((int value, int element) => value + element);
        int health =  healthPacts.map((BloodPact pact) =>pact.cost ).reduce((int value, int element) => value + element);
        int companion = Companion.price;
        int legacy = Amulet.price;
        return weapon + magic + health + companion + legacy;

    }

    int get unpaidPacts {
        int weapon = weaponPacts.where((BloodPact pact) =>pact.cost != 0 ).length;
        int magic = magicPacts.where((BloodPact pact) =>pact.cost != 0 ).length;
        int health = healthPacts.where((BloodPact pact) =>pact.cost != 0 ).length;
        int companion = Companion.unpaidPacts;
        int legacy = Amulet.unpaidPacts;
        return weapon + magic + health + companion + legacy;

    }

    BloodPriceGirl(String name, String dollString) : super(name, dollString);

    List<WeaponBloodPact> weaponPacts = <WeaponBloodPact>[];
    List<MagicBloodPact> magicPacts = <MagicBloodPact>[];
    //applies immediately so just for the eventual bill
    List<HealthBloodPact> healthPacts = <HealthBloodPact>[];

    int get weaponMultiplier => Amulet.damageMultiplier *  weaponPacts.length + 1;
    int get magicMultiplier => Amulet.damageMultiplier *magicPacts.length + 1;



    static Future<BloodPriceGirl> randomGirl() async {
        final MagicalDoll doll = new MagicalDoll();
        await doll.setNameFromEngine();
        return new BloodPriceGirl(doll.dollName, doll.toDataBytesX());
    }

    void damage(int damagePoints) {
        hp += damagePoints;
        //TODO if dead do thing
    }

    @override
    void totallyDiePure() {
        /*
        TODO: hide the menu.
        do a popup detailing your tragic but nobel death (eventually a cutscene???)
        unpaid pacts should be cleared out
        girl should be added to list of former girls
        new girl should be spawned (cutscene)
        monster HEALED
        menu shows back up
         */
    }

    int calculateWeaponDamage() {
        return -1*(energetic.value.abs() + external.value.abs()) * (weaponMultiplier);
    }

    int calculateCompanionDamge() {
        return -1*(curious.value.abs() + loyal.value.abs()) * (Companion.damageMultiplier +1);
    }

    int calculateMagicDamage() {
        return -1*(patience.value.abs() + idealistic.value.abs())*(magicMultiplier);
    }



}