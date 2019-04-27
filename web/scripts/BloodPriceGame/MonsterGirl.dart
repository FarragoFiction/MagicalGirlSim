
//TODO make actually a monster dollset not a magical girl (its a subset tho???)
import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'BloodPriceGirl.dart';

class MonsterGirl extends BloodPriceGirl{
    @override
    int hp = 9999;
    MonsterGirl(String name, String dollString) : super(name, dollString);

    static Future<MonsterGirl> randomGirl() async {
        final MagicalDoll doll = new MagicalDoll();
        await doll.setNameFromEngine();
        return new MonsterGirl(doll.dollName, doll.toDataBytesX());
    }

}