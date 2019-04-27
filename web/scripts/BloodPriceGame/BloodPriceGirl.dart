import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';

class BloodPriceGirl extends MagicalGirlCharacterObject{
    int hp = 113;
    BloodPriceGirl(String name, String dollString) : super(name, dollString);


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
        return energetic.value.abs() + external.value.abs();
    }

    int calculateCompanionDamge() {
        return curious.value.abs() + loyal.value.abs();
    }

    int calculateMagicDamage() {
        return patience.value.abs() + idealistic.value.abs();
    }



}