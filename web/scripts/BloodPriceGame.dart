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
        if(currentGirl == null) {
            currentGirl = await BloodPriceGirl.randomGirl();
        }

        if(monsterGirl == null) {
            monsterGirl = await MonsterGirl.randomGirl();
        }

        DivElement container = new DivElement()..classes.add("gameBox");
        parent.append(container);
        displayMonster(container);
        displayCurrentGirl(container);
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