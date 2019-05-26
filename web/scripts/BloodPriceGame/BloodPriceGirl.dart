import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'Amulet.dart';
import 'BloodPact.dart';
import 'BloodPriceGame.dart';
import 'Companion.dart';
import 'MonsterGirl.dart';
import 'SoundHandler.dart';

class BloodPriceGirl extends MagicalGirlCharacterObject{
    //TODO when a magic girl dies, zero out all unpaid pacts

    int hp = 113;
    CanvasElement canvas;

    //you did this. I hope it was worth it.
    MonsterGirl monstersona;

    int get pactCount => weaponPacts.length + magicPacts.length + healthPacts.length;

    int get price {
        int weapon =  weaponPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int magic =  magicPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int health =  healthPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int companion = Companion.price;
        int legacy = Amulet.price;
        return weapon + magic + health + companion + legacy;

    }

    void copyPactsFrom(BloodPriceGirl otherGirl) {
        for(int i = 0; i< otherGirl.weaponPacts.length; i++) {
            weaponPacts.add(otherGirl.weaponPacts[i]);
        }

        for(int i = 0; i< otherGirl.magicPacts.length; i++) {
            magicPacts.add(otherGirl.magicPacts[i]);
        }

        for(int i = 0; i< otherGirl.healthPacts.length; i++) {
            healthPacts.add(otherGirl.healthPacts[i]);
        }
    }

    void clearDebts() {
        weaponPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        magicPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        healthPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        Companion.clearDebts();
        Amulet.clearDebts();
    }

    //if you have a monster sona, flicker in and out of it
    Element endingScene(int x) {
        DivElement div = new DivElement()..classes.add("epilogueEntry")..id = "$name";
        canvas.style.left = "${x}px";
        canvas.style.top = "200px";
        //ghost of monster behind her
        div.append(canvas);
        if(monstersona != null) {
            monstersona.canvas.classes.add("monstersona");
            div.append(monstersona.canvas);
            monstersona.canvas.style.left = "${x -150}px";
            monstersona.canvas.style.top = "100px";
            monstersona.canvas.animate([{"opacity": 10},{"opacity": 0},{"opacity": 50},{"opacity": 0},{"opacity": 75},{"opacity": 0}], 13000);

        }


        return div;
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

    int get weaponMultiplier => Amulet.damageMultiplier *  (weaponPacts.length + 1);
    int get magicMultiplier => Amulet.damageMultiplier *(magicPacts.length + 1);



    static Future<BloodPriceGirl> randomGirl() async {
        final MagicalDoll doll = new MagicalDoll();
        await doll.setNameFromEngine();
        return new BloodPriceGirl(doll.dollName, doll.toDataBytesX());
    }

    void damage(int damagePoints) {
        hp += damagePoints;
        if(hp <= 0) {
            totallyDiePure();
        }
    }

    @override
    Future<Null> totallyDiePure() async{
        /*
        hide the menu.
        do a popup detailing your tragic but nobel death (eventually a cutscene???)
        unpaid pacts should be cleared out
        hide old girl.
        girl should be added to list of former girls
        new girl should be spawned (cutscene)
        monster HEALED
        menu shows back up
         */
        BloodPriceGame game = BloodPriceGame.instance;
        canvas.remove();
        game.hideAllMenus();
        String debts = "";
        int debtAmount = price;
        if(debtAmount > 0) {
            debts = "Their ${debtAmount} blood debt is collected from what remains of their corpse.";
        }

        String thoughts = "";
        if(debtAmount == 0) {
            thoughts = "$thoughts 🐥 knows the next girl should be more open to BLOODPACTS.";
        }
        if(game.currentMonster.pactCount  > 0) {
            thoughts = "$thoughts 🐥 knows that this monster is too powerful. 🐥 blames ${game.currentMonster.name}'s greed.";
        }
        clearDebts();
        game.retireGirl();
        await Future<void>.delayed(Duration(milliseconds: 2000));
        await game.spawnNewGirl();
        SoundHandler.monsterSound();
        await game.healthBar.cutscene("Unfortunately, ${name} has succumbed to their injuries. $debts. $thoughts <br><br>The city will be doomed without a protector. 🐥 must find someone new to take up the mantle of a Magical Girl. 🐥  finds ${game.currentGirl.name}.", await game.companionEggGirlScene());

        game.showMenu();


    }



    int calculateWeaponDamage() {
        return -1*(rawWeaponDamage()) * (weaponMultiplier);
    }

    int rawWeaponDamage() => energetic.value.abs() + external.value.abs();

    int calculateCompanionDamge() {
        return -1*(rawCompanionDamage()) * (Companion.damageMultiplier +1);
    }

    int rawCompanionDamage() => curious.value.abs() + loyal.value.abs();

    int calculateMagicDamage() {
        return -1*(rawMagicDamaage())*(magicMultiplier);
    }

    int rawMagicDamaage() => patience.value.abs() + idealistic.value.abs();



}