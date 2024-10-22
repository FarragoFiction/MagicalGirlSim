
//TODO make actually a monster dollset not a magical girl (its a subset tho???)
import 'dart:html';
import 'package:CreditsLib/src/StatObject.dart';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'BloodPact.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';
import 'SoundHandler.dart';

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
        monster.name = girl.name;
        print("after copying ${girl.pactCount} pacts from the girl, the monster has ${monster.pactCount}");
        monster.healthPacts.forEach((HealthBloodPact pact) => monster.hp += 113);
        print("after getting hp for ${monster.healthPacts.length} healtpacts, my hp is ${monster.hp}");
        girl.monstersona = monster;
        return monster;
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
        await Future<void>.delayed(Duration(milliseconds: 2000));
        String butWaitTheresMore = "";
        bool spawnMonster = false;
        Element scene;
        if(girl.price > girl.hp) {
            butWaitTheresMore = "<br><br>But it is too soon for happiness. There is a sickening crack. ${girl.name} falls over, dead, from the weight of their Blood Debt of ${girl.price}. The 🐥 continues celebrating... The city is safe!";
            spawnMonster = true;
            scene = await game.deathScene();
        }else if(girl.price > 0) {
            butWaitTheresMore = "<br><br>They wince with the pain of the their ${girl.price} Blood Debt being collected, but know in their heart it was worth it.";
            scene = await game.celebrationScene();

        }else {
            butWaitTheresMore = "They bask in the knowledge they never gave in to corruption.";
            scene = await game.celebrationScene();
        }
        await game.healthBar.cutscene("The horrific monster is finally defeated. ${girl.name} celebrates! $butWaitTheresMore",scene);

        if(spawnMonster) {
            SoundHandler.monsterSound();
            await game.spawnNewMonster(girl);
        }else {
            game.goodEnding();
        }

    }



    //wait three seconds and then do physical or magical damage to your opponent
    Future<void> takeTurn() async {
        if(hp <= 0) return; //stop making phyric victories that also glitch shit out plz
        await Future.delayed(Duration(milliseconds: 2000));
        Random rand = new Random();
        rand.nextInt(); //init
        int easinessQuotient = 10; //8 is good
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




    @override
    int rawWeaponDamage() => energetic.value.abs() + external.value.abs() + rawCompanionDamage();


    @override
    int rawCompanionDamage() => curious.value.abs() + loyal.value.abs();


    @override
    int rawMagicDamaage() => patience.value.abs() + idealistic.value.abs() + rawCompanionDamage();


    @override
    void initializeStats() {
        stats.clear();
        magicDoll = doll as MonsterGirlDoll;
        stats.add(new StatObject(this, StatObject.PATIENCE,StatObject.IMPATIENCE,85));
        stats.add(new StatObject(this, StatObject.ENERGETIC,StatObject.CALM,85));
        stats.add(new StatObject(this, StatObject.IDEALISTIC,StatObject.REALISTIC,85));
        stats.add(new StatObject(this, StatObject.CURIOUS,StatObject.ACCEPTING,85));
        stats.add(new StatObject(this, StatObject.LOYAL,StatObject.FREE,85));
        stats.add(new StatObject(this, StatObject.EXTERNAL,StatObject.INTERNAL,85));
    }

}