import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'Amulet.dart';
import 'BloodPact.dart';
import 'Companion.dart';

class BloodPriceGirl extends MagicalGirlCharacterObject{
    int hp = 113;
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
        hp += -1 * damagePoints;
        //TODO if dead do thing
    }

    int calculateWeaponDamage() {
        return (energetic.value.abs() + external.value.abs()) * (weaponMultiplier);
    }

    int calculateCompanionDamge() {
        return (curious.value.abs() + loyal.value.abs()) * (Companion.damageMultiplier +1);
    }

    int calculateMagicDamage() {
        return (patience.value.abs() + idealistic.value.abs())*(magicMultiplier);
    }



}