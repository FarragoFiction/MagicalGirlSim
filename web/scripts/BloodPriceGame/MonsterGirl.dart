
//TODO make actually a monster dollset not a magical girl (its a subset tho???)
import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'BloodPriceGirl.dart';

class MonsterGirl extends BloodPriceGirl{
    @override
    int hp = 999;
    MonsterGirl(String name, String dollString) : super(name, dollString);

    static Future<MonsterGirl> randomGirl(MagicalDoll origin) async {
        final MonsterGirlDoll doll = origin.hatch();
        doll.orientation = Doll.TURNWAYS;
        await doll.setNameFromEngine();
        return new MonsterGirl(doll.dollName, doll.toDataBytesX());
    }

    //wait three seconds and then do physical or magical damage to your opponent
    Future<void> takeTurn() async {
        await Future.delayed(Duration(milliseconds: 2000));
        window.alert("???");
    }

}