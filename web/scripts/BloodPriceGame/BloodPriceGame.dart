import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

import "package:CommonLib/Random.dart";
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
    static BloodPriceGame instance;



    BloodPriceGame({BloodPriceGirl this.currentGirl,MonsterGirl this.currentMonster}) {
        instance = this;
    }

    Future<void> display(Element parent) async {
        currentGirl ??= await BloodPriceGirl.randomGirl();
        await currentGirl.setShitUp();

        currentMonster ??= await MonsterGirl.randomGirl(currentGirl.doll);
        healthBar = new HealthBar();
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.updateMonsterHP(currentMonster.hp);

        healthBar.display(parent);
        final DivElement container = new DivElement()..classes.add("gameBox")..id="gameBox";
        parent.append(container);
        container.append(new DivElement()..className="voidGlow noIE");
        await displayMonster(container);
        await displayCurrentGirl(container);
        final Element birb = new DivElement()..id="🐥";
        container
            ..append(birb)
            ..append(new DivElement()..className="sunGlow noIE");
        menuHandler.displayMenu(container);

        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });


    }

    Future<void> displayCurrentGirl(Element container) async {
        currentGirl.doll.orientation = Doll.TURNWAYS;
        final CanvasElement cacheCanvas = await currentGirl.doll.getNewCanvas();
        const int ratio = 2;
        final CanvasElement dollCanvas = new CanvasElement(width: (cacheCanvas.width/ratio).floor(), height: (cacheCanvas.height/ratio).floor());
        dollCanvas.context2D.drawImageScaled(cacheCanvas, 0,0, dollCanvas.width, dollCanvas.height);
        dollCanvas.classes.add("bloodDoll");
        container.append(dollCanvas);
    }

    Future<void> displayMonster(Element container) async {
        final CanvasElement dollCanvas = await currentMonster.doll.getNewCanvas();
        dollCanvas.classes.add("monsterDoll");
        container.append(dollCanvas);
    }


    Future<Null> handleWeapon() async {
        final int damage = currentGirl.calculateWeaponDamage();
        damageMonster(damage);
        String attackText = "(TODO have some procedural text about ${currentGirl.weapon})"; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.weapon} $attackText",0);
    }

    Future<Null> handleMagic() async {
        final int damage = currentGirl.calculateMagicDamage();
        damageMonster(damage);
        String attackText = "(TODO have some procedural text about ${currentGirl.magical_attack})"; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.magical_attack} $attackText",0);
    }

    void damageMonster(int damage) {
        currentMonster.damage(damage);
        healthBar.updateMonsterHP(currentMonster.hp);
      healthBar.damageGraphicMonster(0,-1*damage);
    }

    void damageGirl(int damage) {
        currentGirl.damage(damage);
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.damageGraphicGirl(0,-1*damage);
    }

    Future<Null> handleCompanion() async {
        final int damage = currentGirl.calculateCompanionDamge();
        damageMonster(damage);
        String attackText = "(TODO have some procedural text about 🐥 )"; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with 🐥  $attackText",0);
    }


    static Random _birbRand = new Random();
    void birbChaos(Element birb) {
        double angle = _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble();
        angle *= 180;
        if (_birbRand.nextInt(2) == 0) {
            angle = 360 - angle;
        }

        double x = _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble();
        x = 1-x;
        x *= 2;
        if (_birbRand.nextInt(2) == 0) {
            x *= -1;
        }

        double y = _birbRand.nextDouble() * _birbRand.nextDouble() * _birbRand.nextDouble();
        y = 1-y;
        y *= -6;

        final String t = "rotate(${angle}deg) translate(${x.floor()}px,${y.floor()}px)";
        birb.style.transform = t;
    }

}


