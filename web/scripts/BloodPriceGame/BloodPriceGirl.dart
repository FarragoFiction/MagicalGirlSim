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

}