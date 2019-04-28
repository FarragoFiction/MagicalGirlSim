import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

import "package:CommonLib/Random.dart";
import 'package:DollLibCorrect/DollRenderer.dart';

import 'BloodPriceGirl.dart';
import 'Effects.dart';
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
    Element container;
    MonsterGirl currentMonster;
    List<BloodPriceGirl> formerGirls  = <BloodPriceGirl>[];
    List<MonsterGirl> formerMonsters = <MonsterGirl>[];
    MenuHandler menuHandler = new MenuHandler();
    static const String MAGICDAMAGE = "MAGICDAMAGE";
    static const String PHYSICALDAMAGE = "PHYSICALDAMAGE";

    HealthBar healthBar;
    static BloodPriceGame instance;



    BloodPriceGame({BloodPriceGirl this.currentGirl,MonsterGirl this.currentMonster}) {
        instance = this;
    }

    Future<void> spawnNewGirl() async {
        currentGirl = await BloodPriceGirl.randomGirl();
        await currentGirl.setShitUp();
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.updateBill(currentGirl.unpaidPacts);
        await displayCurrentGirl(container);

    }

    Future<void> display(Element parent) async {
        healthBar = new HealthBar();
        container = new DivElement()..classes.add("gameBox")..id="gameBox";

        if(currentGirl == null) {
            await spawnNewGirl();
        }

        currentMonster ??= await MonsterGirl.randomGirl(currentGirl.doll);
        healthBar.updateMonsterHP(currentMonster.hp);

        healthBar.display(parent);
        parent.append(container);
        container.append(new DivElement()..className="voidGlow noIE");
        await displayMonster(container);
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
        currentGirl.canvas = dollCanvas;
    }

    Future<void> displayMonster(Element container) async {
        final CanvasElement dollCanvas = await currentMonster.doll.getNewCanvas();
        dollCanvas.classes.add("monsterDoll");
        container.append(dollCanvas);
        currentMonster.canvas = dollCanvas;

    }


    Future<Null> handleWeapon() async {
        final int damage = currentGirl.calculateWeaponDamage();
        damageMonster(damage, PHYSICALDAMAGE);
        String attackText = "(TODO have some procedural text about ${currentGirl.weapon})"; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.weapon} $attackText",0);
    }

    Future<Null> handleMagic() async {
        final int damage = currentGirl.calculateMagicDamage();
        damageMonster(damage, MAGICDAMAGE);
        String attackText = "(TODO have some procedural text about ${currentGirl.magical_attack})"; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.magical_attack} $attackText",0);
    }

    Future<void> damageMonster(int damage, String damageType) async{
        //TODO should this be on a timer?
        if(damageType == MAGICDAMAGE) {
            Effects.magicHit(950, 250);
        }else if (damageType == PHYSICALDAMAGE) {
            Effects.weaponHit(950, 250);

        }
        currentMonster.damage(damage);
        healthBar.updateMonsterHP(currentMonster.hp);
      healthBar.damageGraphicMonster(0,damage);

      //disable menu, in three seconds, have monster attack back. either physical or magical???
        hideAllMenus();
        await currentMonster.takeTurn();
        showMenu();

    }

    void hideAllMenus() {
        menuHandler.firstMenu.style.display = "none";

    }

    void showMenu() {
        menuHandler.firstMenu.style.display = "block";

    }

    void damageGirl(int damage, String damageType) {
        currentGirl.damage(damage);
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.damageGraphicGirl(0,damage);
        if(damageType == MAGICDAMAGE) {
            Effects.magicHit(150, 250);
        }else if (damageType == PHYSICALDAMAGE) {
            Effects.weaponHit(150, 250);

        }
    }

    Future<Null> handleCompanion() async {
        final int damage = currentGirl.calculateCompanionDamge();
        damageMonster(damage, PHYSICALDAMAGE);
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


