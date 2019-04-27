import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import 'BloodPriceGirl.dart';
import 'HealthBar.dart';
import 'MenuHandler.dart';
import 'MonsterGirl.dart';

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
    MonsterGirl currentMonster;
    MenuHandler menuHandler = new MenuHandler();

    HealthBar healthBar;



    BloodPriceGame({BloodPriceGirl this.currentGirl,MonsterGirl this.currentMonster});

    void display(Element parent) async {
        currentGirl ??= await BloodPriceGirl.randomGirl();

        currentMonster ??= await MonsterGirl.randomGirl();
        healthBar = new HealthBar();
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.updateMonsterHP(currentMonster.hp);

        healthBar.display(parent);
        DivElement container = new DivElement()..classes.add("gameBox");
        parent.append(container);
        await displayMonster(container);
        await displayCurrentGirl(container);
        menuHandler.displayMenu(container);




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
        CanvasElement dollCanvas = await currentMonster.doll.getNewCanvas();
        dollCanvas.classes.add("monsterDoll");
        container.append(dollCanvas);
    }



}


