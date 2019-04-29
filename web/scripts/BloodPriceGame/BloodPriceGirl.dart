import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'Amulet.dart';
import 'BloodPact.dart';
import 'BloodPriceGame.dart';
import 'Companion.dart';

class BloodPriceGirl extends MagicalGirlCharacterObject{
    //TODO when a magic girl dies, zero out all unpaid pacts

    int hp = 113;
    Element canvas;

    int get price {
        int weapon =  weaponPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int magic =  magicPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int health =  healthPacts.map((BloodPact pact) =>pact.cost ).fold(0,(int value, int element) => value + element);
        int companion = Companion.price;
        int legacy = Amulet.price;
        return weapon + magic + health + companion + legacy;

    }

    void copyPactsFrom(BloodPriceGirl otherGirl) {
        for(int i = 0; i< weaponPacts.length; i++) {
            weaponPacts[i] = otherGirl.weaponPacts[i];
        }

        for(int i = 0; i< magicPacts.length; i++) {
            magicPacts[i] = otherGirl.magicPacts[i];
        }

        for(int i = 0; i< weaponPacts.length; i++) {
            healthPacts[i] = otherGirl.healthPacts[i];
        }
    }

    void clearDebts() {
        weaponPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        magicPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        healthPacts.where((BloodPact pact) =>pact.cost != 0 ).forEach((BloodPact pact) => pact.cost = 0);
        Companion.clearDebts();
        Amulet.clearDebts();
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
        clearDebts();
        game.healthBar.popup("Unfortunately, ${name} has succumbed to her injuries. $debts. The city will be doomed without a protector. The 🐥 must find someone new to take up the mantle of a Magical Girl.",0);
        await Future.delayed(Duration(milliseconds: 2000));
        game.retireGirl();
        game.spawnNewGirl();
        game.showMenu();


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