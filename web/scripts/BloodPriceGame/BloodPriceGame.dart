import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

import "package:CommonLib/Random.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'BloodPriceGirl.dart';
import 'Companion.dart';
import 'Effects.dart';
import 'HealthBar.dart';
import 'MenuHandler.dart';
import 'MonsterGirl.dart';
import 'SoundHandler.dart';

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
    static const String COMPANIONDAMAGE = "COMPANIONDAMAGE";

    HealthBar healthBar;
    static BloodPriceGame instance;
    Element birb;



    BloodPriceGame({BloodPriceGirl this.currentGirl,MonsterGirl this.currentMonster}) {
        instance = this;
    }

    void retireGirl() {
        formerGirls.add(currentGirl);
        currentGirl.canvas.remove();
        currentGirl.clearDebts();
        currentGirl = null;
        Effects.damageCity();
        SoundHandler.bumpTier();
    }

    Future<void> spawnNewGirl() async {
        currentGirl = await BloodPriceGirl.randomGirl();
        await currentGirl.setShitUp();
        healthBar.updateGirlHP(currentGirl.hp);
        healthBar.updateBill(currentGirl.unpaidPacts);
        if(currentMonster != null) {
            currentMonster.hp = Math.max(currentMonster.hp, MonsterGirl.maxHP);
            healthBar.updateMonsterHP(currentMonster.hp);
        }
        await displayCurrentGirl(container);

    }

    Future<void> spawnNewMonster([BloodPriceGirl sacrifice]) async {
        if(sacrifice != null) {
            currentMonster = await MonsterGirl.corruptGirl(sacrifice);
            retireGirl();
            await spawnNewGirl();
            //TODO have a popup you must click to explain why thers a new monster
            await healthBar.cutscene("The peaceful days do not last long. A new monster, more horrific and powerful than the last rears its ugly head. <br><br>You know you can find a way to stop the cycle of monsters. Until then, 🐥 must find a new girl to protect the city! 🐥 finds ${currentGirl.name}!", await companionEggGirlScene());
        }else {
            currentMonster = await MonsterGirl.randomGirl(new MagicalDoll());
        }
        window.console.log("goint to update monster hp with ${currentMonster.hp}");
        healthBar.updateMonsterHP(currentMonster.hp);
        await displayMonster(container);
        SoundHandler.monsterSound();
    }

    //you can pass a specific step in to get a birb of the right size
    void spreadCorruption(Element ele, [int steps = 1]) {

        String cssWidth = ele.style.width;
        String cssHeight = ele.style.height;
        String cssTop =ele.style.top;
        String cssLeft =ele.style.left;
        if(cssWidth.isEmpty) {
            cssWidth = "41px";
            cssHeight = "41px";
            cssTop ="340px";
            cssLeft = "120px";
        }
        window.console.log("css width $cssWidth");
        final int width = int.parse(cssWidth.replaceAll("px", ""));
        final int height = int.parse(cssHeight.replaceAll("px", ""));
        int top = int.parse(cssTop.replaceAll("px", ""));
        int left = int.parse(cssLeft.replaceAll("px", ""));
        top += steps * (-1*height/3).round();
        left += steps * (-1*width/3).round();

        if(steps ==1) {
            ele.style.top = "${top}px";
            ele.style.left = "${left}px";
        }
        ele.style.width = "${steps * (width*1.8).round()}px";
        ele.style.height = "${steps * (height*1.8).round()}px";
    }

    void goodEnding() async {
        SoundHandler.musicTier = 0;
        SoundHandler.playTier();

        healthBar.cutscene("${currentGirl.name} wins! The city is finally safe! All it took was the death of ${formerGirls.length} Magical Girls!<br><br> Congratulations!", await winningScene(false),true);
    }

    void badEnding() async {
        SoundHandler.musicTier = 13;
        SoundHandler.playTier();
        healthBar.cutscene("🐥 doesn't need anyone anymore. All it took was the death of ${formerGirls.length} meaningless Magical Girls, some of which were foolish enough to trade life for power, and not even keep the power! <br><br>Congratulations!", await winningScene(true),true);
    }

    Completer<void> handleStart(Element parent) {
        final Element startScreen = new DivElement()..className = "startScreen";
        parent.append(startScreen);
        final Completer<void> completer = new Completer();

        final Element startButton = new DivElement()..className = "startButton startScreenText"..text="Accept?";
        startScreen.append(startButton);

        final Element deal = new DivElement()..className="startScreenText"..text="The pact is sealed...";

        final Element barcover = new DivElement()..className="barcover";
        healthBar.container.append(barcover);

        startButton.onClick.listen((Event e){
            SoundHandler.playTier();
            startButton.remove();
            startScreen
                ..append(deal)
                ..append(new DivElement()..className="startFade");

            new Timer(Duration(seconds: 2), ()
            {
                startScreen.remove();
                completer.complete();
                barcover.remove();
            });
        });

        return completer;
    }

    Future<void> display(Element parent) async {
        Element outer = new DivElement()..className="outerBox";

        healthBar = new HealthBar();
        container = new DivElement()..classes.add("gameBox")..id="gameBox";
        //container.style.display = "none";
        Completer<void> completer = handleStart(container);

        if(currentGirl == null) {
            await spawnNewGirl();
        }

        if(currentMonster == null) {
            await spawnNewMonster();
        }

        healthBar.display(outer);
        outer.append(container);
        parent.append(outer);
        container.append(new DivElement()..className="voidGlow noIE");
        birb = new DivElement()..id="birb";
        container
            ..append(birb)
            ..append(new DivElement()..className="sunGlow noIE");
        menuHandler.displayMenu(container);
        await completer.future;
        //container.style.display = "block";
        await healthBar.cutscene("A monster is rampaging and threatening the city! 🐥 will not allow this! 🐥 recruits ${currentGirl.name}!<br><br> With the power of the GALAXY EGG, they transform into a MAGICAL GIRL and attack the terrible monster!",await companionEggGirlScene());

        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });
    }

    Future<Element> companionEggGirlScene() async{
        //TODO 🐥 on left, egg in middle, girl on right
        DivElement scene = new DivElement()..className="scene";
        final ImageElement birb = new ImageElement(src: "images/protagonist.png")..classes.add("birbCutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });

        scene.append(birb);
        final ImageElement egg = new ImageElement(src: "images/BloodPrice/egg.png")..classes.add("eggCutscene");
        scene.append(egg);
        CanvasElement canvas = await currentGirl.doll.getNewCanvas()..classes.add("girlCutscene");
        scene.append(canvas);
        return scene;
    }

    Future<Element> celebrationScene() async{
        final DivElement scene = new DivElement()..className="scene";
        final ImageElement birb = new ImageElement(src: "images/protagonist.png")..classes.add("birbCutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });

        scene.append(birb);
        final CanvasElement canvas = await currentGirl.doll.getNewCanvas()..classes.add("girlCutscene");
        scene.append(canvas);
        return scene;
    }

    Future<Element> winningScene(bool corruption) async{
        final DivElement scene = new DivElement()..classes.add("ending");
        final ImageElement cutsceneBirb = new ImageElement(src: "images/protagonist.png")..classes.add("birbCutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(cutsceneBirb); });
        if(corruption) {
            cutsceneBirb.style.left = "300px";
            cutsceneBirb.style.top = "100px";
            spreadCorruption(cutsceneBirb, 8);
        }
        scene.append(cutsceneBirb);
        final DivElement scrollyThingy = new DivElement()..classes.add("autoscroller");
        scene.append(scrollyThingy);
        currentGirl.canvas.remove();
        //TODO make this auto scroll and loop
        int startX = 0;
        formerGirls.forEach((BloodPriceGirl girl){
            scrollyThingy.append(girl.endingScene(startX));
            startX += 300;
        });
        scrollyThingy.style.width = "${startX}px";
        scrollyThingy.style.left = "0px";

        if(startX > 1280) {
            scrollThing(scrollyThingy);
        }
        scrollyThingy.append(currentGirl.endingScene(startX));
        return scene;
    }

    Future<void> scrollThing(Element thing) async {
        await window.animationFrame;
        window.console.log("left is ${thing.style.left} and if i try to get just a number i get ${thing.style.left.replaceAll("px", "")}");
        int currentX = int.parse(thing.style.left.replaceAll("px", ""));
        int width = int.parse(thing.style.width.replaceAll("px", ""));

        window.console.log("scrolling from $currentX");

        if(currentX < -1 * width) {
            currentX = 1280;
        }
        thing.style.left = "${currentX-5}px";
        await Future<void>.delayed(Duration(milliseconds:60));
        scrollThing(thing);
    }



    Future<Element> deathScene() async{
        final DivElement scene = new DivElement()..className="scene";
        final ImageElement birb = new ImageElement(src: "images/protagonist.png")..classes.add("🐥Cutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });

        scene.append(birb);
        return scene;
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
        String attackText = ""; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.weapon} $attackText",0);
    }

    Future<Null> handleMagic() async {
        final int damage = currentGirl.calculateMagicDamage();
        damageMonster(damage, MAGICDAMAGE);
        String attackText = ""; //TODO load this from text engine
        healthBar.popup("${currentGirl.name} attacks with ${currentGirl.magical_attack} $attackText",0);
    }

    Future<void> damageMonster(int damage, String damageType) async{
        int weaponBonus = 0;
        int magicBonus = 0;
        int companionBonus = 0;
        if(damageType == MAGICDAMAGE) {
            magicBonus = currentGirl.magicPacts.length;
            Effects.magicHit(950, 250);
        }else if (damageType == PHYSICALDAMAGE) {
            weaponBonus = currentGirl.weaponPacts.length;
            Effects.weaponHit(950, 250);

        }else if (damageType == COMPANIONDAMAGE) {
            companionBonus = Companion.bloodPacts.length;
            Effects.weaponHit(950, 250);

    }
      //disable menu, in three seconds, have monster attack back. either physical or magical???
        hideAllMenus();
        currentMonster.damage(damage);
        healthBar.updateMonsterHP(currentMonster.hp);
        healthBar.damageGraphicMonster(0,damage,magicBonus,weaponBonus,companionBonus);
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
        int magicBonus = 0;
        int weaponBonus = 0;
        if(damageType == MAGICDAMAGE) {
            Effects.magicHit(260, 250);
            magicBonus = currentMonster.magicPacts.length;

        }else if (damageType == PHYSICALDAMAGE) {
            Effects.weaponHit(260, 250);
            weaponBonus = currentMonster.weaponPacts.length;

        }
        healthBar.damageGraphicGirl(0,damage, magicBonus, weaponBonus);
        currentGirl.damage(damage);
        healthBar.updateGirlHP(currentGirl.hp);

    }

    Future<Null> handleCompanion() async {
        final int damage = currentGirl.calculateCompanionDamge();
        damageMonster(damage, COMPANIONDAMAGE);
        String attackText = ""; //TODO load this from text engine
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


