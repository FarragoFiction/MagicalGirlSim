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

    BloodPriceGame({BloodPriceGirl this.currentGirl});

    void display(Element parent) async {
        if(currentGirl == null) {
            currentGirl = await BloodPriceGirl.randomGirl();
        }

        DivElement container = new DivElement()..classes.add("gameBox");
        parent.append(container);
        displayCurrentGirl(container);
    }

    void displayCurrentGirl(Element container) async {
        //TODO draw magical girl turnways on the left and half size
        currentGirl.doll.orientation = Doll.TURNWAYS;
        CanvasElement cacheCanvas = await currentGirl.doll.getNewCanvas();
        int ratio = 2;
        CanvasElement dollCanvas = new CanvasElement(width: (cacheCanvas.width/ratio).floor(), height: (cacheCanvas.height/ratio).floor());
        dollCanvas.context2D.drawImageScaled(cacheCanvas, 0,0, dollCanvas.width, dollCanvas.height);
        dollCanvas.classes.add("bloodDoll");
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