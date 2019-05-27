import 'dart:async';
import 'dart:html';
import "dart:math" as Math;

import "package:CommonLib/Random.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'Amulet.dart';
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
    Element monsterStats;
    Element girlStats;
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

    Future<BloodPriceGirl> spawnNewGirl([nerf = false]) async {

        BloodPriceGirl girl  = await BloodPriceGirl.randomGirl(nerf);
        if(currentGirl == null) {
            currentGirl = girl;
        }
        await girl.setShitUp();
        healthBar.updateGirlHP(girl.hp);
        healthBar.updateBill(girl.unpaidPacts);
        if(currentMonster != null) {
            currentMonster.hp = Math.max(currentMonster.hp, MonsterGirl.maxHP);
            healthBar.updateMonsterHP(currentMonster.hp);
        }
        return girl;

    }

    Future<void> spawnNewMonster([BloodPriceGirl sacrifice]) async {
        if(sacrifice != null) {
            currentMonster = await MonsterGirl.corruptGirl(sacrifice);
            retireGirl();
            await healthBar.pickGirlCutscene("The peaceful days do not last long. A new monster, more horrific and powerful than the last rears its ugly head. <br><br>You know you can find a way to stop the cycle of monsters. Until then, 🐥 must find a new girl to protect the city! <br><br>Which does 🐥 pick?", await pickNewGirlScene());
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
        healthBar.cutscene("🐥 doesn't need anyone anymore. ${currentGirl.name} is dead.  All it took was the death of ${formerGirls.length +1} meaningless Magical Girls, some of which were foolish enough to trade life for power, and not even keep the power! <br><br>Congratulations!", await winningScene(true),true);
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
           currentGirl =  await spawnNewGirl(true);
            await displayCurrentGirl(container);

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

    void syncStats() {
        updateStats(girlStats, currentGirl);
        updateStats(monsterStats,currentMonster);
    }

    Element getGirlStats(BloodPriceGirl char) {
        final DivElement ret = new DivElement()..classes.add("girlStats");
        updateStats(ret, char);
        return ret;
    }

    void updateStats(Element ret, BloodPriceGirl char) {
        ret.text = "";
        final DivElement label = new DivElement()..classes.add("girlStat")..text = "${char.name}"..style.textDecoration="underline";
        ret.append(label);
        ret.append(new DivElement()..text = "${char.healthPacts.length} x 🚑  Pacts"..classes.add("girlStat"));
        final int weaponDamage = (char.rawWeaponDamage()/100).ceil();
        final int weaponPacts = char.weaponPacts.length;
        ret.append(new DivElement()..text ="${weaponPacts} x ⚔️Pacts (${weaponDamage} base stat)"..classes.add("girlStat"));

        final int magicDamage = (char.rawMagicDamaage()/100).ceil();
        final int magicPacts = char.magicPacts.length;
        ret.append(new DivElement()..text= "${magicPacts} x ✨ Pacts (${magicDamage} base stat)"..classes.add("girlStat"));


        final int companionDamage = (char.rawCompanionDamage()/100).ceil();
        final int companionPacts = Companion.bloodPacts.length;
        ret.append(new DivElement()..text = "${companionPacts} x 🐥️  Pacts (${companionDamage} base stat)"..classes.add("girlStat"));
        ret.append(new DivElement()..text ="${Amulet.bloodPacts.length} x 🥚  Pacts"..classes.add("girlStat"));
    }

    Future<Element> pickNewGirlScene() async {
        DivElement scene = new DivElement()..className="scene";
        //        await game.spawnNewGirl();
        /*
        TODO pick fromm three possible girls, stats displayed, plus the stats of the monster.
         */
        for(int i = 0; i <2; i++) {
            BloodPriceGirl girl = await spawnNewGirl();
            DivElement girlWrapper = new DivElement()..classes.add("pickGirl");
            girlWrapper.onClick.listen((MouseEvent e) async {
               bool result = await healthBar.twoOptionPopup("🐥 chooses ${girl.name}?","Yes","No");
               if(result) {
                   currentGirl = girl;
                   await displayCurrentGirl(container);
                   scene.parent.remove();
               }else {
                   print("better choose soon");
               }
            });
            CanvasElement canvas = await girl.doll.getNewCanvas();
            girlWrapper.append(canvas);

            DivElement stat = getGirlStats(girl);
            girlWrapper.append(stat);

            scene.append(girlWrapper);

        }
        return scene;

    }

    Future<Element> companionEggGirlScene() async{
        //TODO 🐥 on left, egg in middle, girl on right
        DivElement scene = new DivElement()..className="scene";
        final ImageElement birb = new ImageElement(src: "images/protagonist.png")..classes.add("birbCutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });

        scene.append(birb);
        final ImageElement egg = new ImageElement(src: "images/BloodPrice/egg.png")..classes.add("eggCutscene");
        scene.append(egg);
        DivElement girlWrapper = new DivElement()..classes.add("girlCutscene");
        CanvasElement canvas = await currentGirl.doll.getNewCanvas()..classes.add("girlCanvasCutscene");
        girlWrapper.append(canvas);

        DivElement stat = getGirlStats(currentGirl);
        girlWrapper.append(stat);

        scene.append(girlWrapper);
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
        final ImageElement birb = new ImageElement(src: "images/protagonist.png")..classes.add("birbCutscene");
        new Timer.periodic(Duration(milliseconds: 50), (Timer t) { birbChaos(birb); });

        scene.append(birb);
        return scene;
    }

    Future<void> displayCurrentGirl(Element container) async {
        final DivElement wrapper = new DivElement()..classes.add("girlFightWrapper");
        currentGirl.doll.orientation = Doll.TURNWAYS;
        final CanvasElement cacheCanvas = await currentGirl.doll.getNewCanvas();
        const int ratio = 2;
        final CanvasElement dollCanvas = new CanvasElement(width: (cacheCanvas.width/ratio).floor(), height: (cacheCanvas.height/ratio).floor());
        dollCanvas.context2D.drawImageScaled(cacheCanvas, 0,0, dollCanvas.width, dollCanvas.height);
        dollCanvas.classes.add("bloodDoll");
        wrapper.append(dollCanvas);
        girlStats = getGirlStats(currentGirl)..id =("battleGirlStats");
        wrapper.append(girlStats);

        container.append(wrapper);
        /*
        dollCanvas.onMouseEnter.listen((Event event) {
            window.alert("girl stats");
        });*/// why does this do nothing??? i guess because of overlays

        currentGirl.canvas = dollCanvas;
    }

    Future<void> displayMonster(Element container) async {
        final DivElement wrapper = new DivElement()..classes.add("monsterFightWrapper");
        final CanvasElement dollCanvas = await currentMonster.doll.getNewCanvas();
        dollCanvas.classes.add("monsterDoll");
        wrapper.append(dollCanvas);
        currentMonster.canvas = dollCanvas;
        monsterStats = getGirlStats(currentMonster)..id = "battleMonsterStats";
        wrapper.append(monsterStats);
        container.append(wrapper);
        /*
        dollCanvas.onMouseEnter.listen((Event event) {
            window.alert("monsterstats");
        });*/ // why does this only do the right most edge of the monster???
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


