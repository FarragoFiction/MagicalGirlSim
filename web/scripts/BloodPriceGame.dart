import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import 'MagicalGirlCharacterObject.dart';

class BloodPriceGame {
    /*TODO
        each blood price game has :
        * an array of past girls
        * array of past monsters
        * current monster
        * current girl
            *extends MagicalGirlCharacterObjects with shit like hp
            * doesn't use wider stat system YET
        * menu shit???
     */
    BloodPriceGirl currentGirl;
    MonsterGirl monsterGirl;


    BloodPriceGame({BloodPriceGirl this.currentGirl,MonsterGirl this.monsterGirl});

    void display(Element parent) async {
        currentGirl ??= await BloodPriceGirl.randomGirl();

        monsterGirl ??= await MonsterGirl.randomGirl();

        DivElement container = new DivElement()..classes.add("gameBox");
        parent.append(container);
        await displayMonster(container);
        await displayCurrentGirl(container);
        displayMenu(container);
        displayBloodPriceSub1(container);

    }

    void displayCurrentGirl(Element container) async {
        currentGirl.doll.orientation = Doll.TURNWAYS;
        CanvasElement cacheCanvas = await currentGirl.doll.getNewCanvas();
        int ratio = 2;
        CanvasElement dollCanvas = new CanvasElement(width: (cacheCanvas.width/ratio).floor(), height: (cacheCanvas.height/ratio).floor());
        dollCanvas.context2D.drawImageScaled(cacheCanvas, 0,0, dollCanvas.width, dollCanvas.height);
        dollCanvas.classes.add("bloodDoll");
        container.append(dollCanvas);
    }

    void displayMonster(Element container) async {
        CanvasElement dollCanvas = await monsterGirl.doll.getNewCanvas();
        dollCanvas.classes.add("monsterDoll");
        container.append(dollCanvas);
    }

    //defaults to hidden
    void displayBloodPriceSub1(Element container) {
        DivElement menu = new DivElement()..classes.add("bloodMenu1")..classes.add("menuHolder");

        container.append(menu);
        displayHealthBargainOpt(menu);
        displayWeaponBargainOpt(menu);
        displayMagicBargainOpt(menu);
        displayCompanionBargainOpt(menu);
        displayLegacyBargainOpt(menu);
    }

    void displayMenu(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuHolder");
        displayWeapon(menu);
        displayMagic(menu);
        displayCompanion(menu);
        displayBloodPrice(menu);

        container.append(menu);
    }



    void displayWeapon(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Weapon";
        container.append(menu);
    }

    void displayMagic(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Magic";
        container.append(menu);
    }

    void displayCompanion(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Companion";
        container.append(menu);
    }

    void displayBloodPrice(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Blood Price >";
        container.append(menu);
    }

    void displayHealthBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Health Pact >";
        container.append(menu);
    }

    void displayWeaponBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Weapon Pact >";
        container.append(menu);
    }

    void displayMagicBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Magic Pact >";
        container.append(menu);
    }

    void displayCompanionBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Companion Pact >";
        container.append(menu);
    }

    void displayLegacyBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Legacy Pact >";
        container.append(menu);
    }

}

class BloodPriceGirl extends MagicalGirlCharacterObject{
  BloodPriceGirl(String name, String dollString) : super(name, dollString);

  static Future<BloodPriceGirl> randomGirl() async {
      MagicalDoll doll = new MagicalDoll();
      await doll.setNameFromEngine();
      return new BloodPriceGirl(doll.dollName, doll.toDataBytesX());
  }

}

//TODO make actually a monster dollset not a magical girl (its a subset tho???)
class MonsterGirl extends MagicalGirlCharacterObject{
    MonsterGirl(String name, String dollString) : super(name, dollString);

    static Future<MonsterGirl> randomGirl() async {
        MagicalDoll doll = new MagicalDoll();
        await doll.setNameFromEngine();
        return new MonsterGirl(doll.dollName, doll.toDataBytesX());
    }

}