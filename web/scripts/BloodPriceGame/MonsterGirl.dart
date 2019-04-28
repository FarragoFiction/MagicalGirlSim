
//TODO make actually a monster dollset not a magical girl (its a subset tho???)
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';

class MonsterGirl extends BloodPriceGirl{
    @override
    int hp = 999;
    //TODO method to spawn a monster from a magical girl, blood pacts and all
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
        Random rand = new Random();
        rand.nextInt(); //init
        int easinessQuotient = 10;
        int damage = 0;
        String type = "";
        //companion damage now counts as monstrous strength owo
        if(rand.nextBool()) {
            damage = calculateWeaponDamage() + calculateCompanionDamge();
            type = BloodPriceGame.PHYSICALDAMAGE;
        }else {
            damage = calculateMagicDamage() + calculateCompanionDamge();
            type = BloodPriceGame.MAGICDAMAGE;
        }
        damage = (damage/easinessQuotient).ceil();
        BloodPriceGame.instance.damageGirl(damage, type);
    }

}