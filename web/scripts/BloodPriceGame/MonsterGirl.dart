
//TODO make actually a monster dollset not a magical girl (its a subset tho???)
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'BloodPact.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';

class MonsterGirl extends BloodPriceGirl{
    @override
    int hp = 999;
    static int maxHP = 999;
    //TODO method to spawn a monster from a magical girl, blood pacts and all
    MonsterGirl(String name, String dollString) : super(name, dollString);

    //i'm so sorry
    static Future<MonsterGirl> corruptGirl(BloodPriceGirl girl) async {
        MonsterGirl monster = await randomGirl(girl.doll);
        monster.copyStatsFrom(girl);
        monster.copyPactsFrom(girl);
        monster.healthPacts.forEach((HealthBloodPact pact) => monster.hp += 113);
    }

    static Future<MonsterGirl> randomGirl(MagicalDoll origin) async {
        final MonsterGirlDoll doll = origin.hatch();
        doll.orientation = Doll.TURNWAYS;
        await doll.setNameFromEngine();
        return new MonsterGirl(doll.dollName, doll.toDataBytesX());
    }

    @override
    Future<Null> totallyDiePure() async{
        /** it is removed from the screen
         * A POPUP (eventually cutscene) describing the BLOOD BILL happens
         * magical girl either DIES FROM BLOOD DEBT or WINNING SCREEN (wtf does this look like? at least should list what your score is. )
         * if the magical girl DIES FROM BLOOD DEBT, a new monster based on their design is spawned (with the same blood pacts). this nulls out the current girl.
         * the :hatched_chick:  goes recruiting for a new magical girl.
         *
         */
        BloodPriceGame game = BloodPriceGame.instance;
        BloodPriceGirl girl = game.currentGirl;
        canvas.remove();
        game.hideAllMenus();
        String butWaitTheresMore = "";
        bool spawnMonster = false;
        if(girl.price > girl.hp) {
            butWaitTheresMore = "But it is too soon for happiness. There is a sickening crack. ${girl.name} falls over, dead, from the weight of their Blood Debt of ${girl.price}. The 🐥 continues celebrating... The city is safe!";
            spawnMonster = true;
        }else if(girl.price > 0) {
            butWaitTheresMore = "They wince with the pain of the their ${girl.price} Blood Debt being collected, but know in their heart it was worth it.";
        }else {
            butWaitTheresMore = "They bask in the knowledge they never gave in to corruption.";
        }
        await game.healthBar.cutscene("The horrific monster is finally defeated. ${girl.name} celebrates! $butWaitTheresMore",await game.celebrationScene());

        if(spawnMonster) {
            await game.spawnNewMonster(girl);
        }else {
            game.goodEnding();
        }

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