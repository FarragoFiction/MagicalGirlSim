import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';

import '../MagicalGirlCharacterObject.dart';
import 'HealthBar.dart';

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
    AudioElement fx = new AudioElement();
    BloodPriceGirl currentGirl;
    MonsterGirl currentMonster;
    Element secondMenu;
    Element thirdMenu;
    Element thirdMenuInsides;
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
        displayMenu(container);
        displayBloodPriceSub1(container);
        displayBloodPriceSub2(container);



    }


    void moneySound() {
        playSoundEffect("121990__tomf__coinbag");
    }

    void clickSound() {
        playSoundEffect("254286__jagadamba__mechanical-switch");
    }

    void playSoundEffect(String locationWithoutExtension) {
        if(fx.canPlayType("audio/mpeg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(fx.canPlayType("audio/ogg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.ogg";
        fx.play();

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

    //defaults to hidden
    void displayBloodPriceSub1(Element container) {
        secondMenu = new DivElement()..classes.add("bloodMenu1")..classes.add("menuHolder");

        container.append(secondMenu);
        displayHealthBargainOpt(secondMenu);
        displayWeaponBargainOpt(secondMenu);
        displayMagicBargainOpt(secondMenu);
        displayCompanionBargainOpt(secondMenu);
        displayLegacyBargainOpt(secondMenu);
    }

    //defaults to hidden
    void displayBloodPriceSub2(Element container) {
        thirdMenu = new DivElement()..classes.add("bloodMenu2")..classes.add("menuHolder");
        container.append(thirdMenu);

        final DivElement header = new DivElement()..text = "Blood Price"..classes.add("menuHeader");
        thirdMenu.append(header);

        thirdMenuInsides = new DivElement()..classes.add("menuInsides");
        thirdMenu.append(thirdMenuInsides);

        ButtonElement button = new ButtonElement()..text = "Pay Blood Price"..classes.add("bloodPriceButton");
        thirdMenu.append(button);
        button.onClick.listen((Event e){
            window.alert("TODO: determine which child is selected, do shit.");
        });
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
        menu.onClick.listen((Event e) {
            clickSound();
            if(secondMenu.style.display == "none" || secondMenu.style.display.isEmpty) {
                secondMenu.style.display = 'block';
                menu.style.backgroundColor = "#fdbee5";
                menu.style.color = "#fff0f9";
            }else {
                secondMenu.style.display = "none";
                thirdMenu.style.display = "none";
                menu.style.backgroundColor = "#fff0f9";
                menu.style.color = "#fdbee5";
            }
        });
        container.append(menu);
    }

    void unmarkChildren(Element menu) {
        menu.children.forEach((Element e) {
            e.style.backgroundColor = "#fff0f9";
            e.style.color = "#fdbee5";
        });
    }

    void displayHealthBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Health Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text = ("Trade future health for current health. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayWeaponBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Weapon Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current weapon strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayMagicBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Magic Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current magic strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayCompanionBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Companion Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current companion strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayLegacyBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Legacy Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for the ability to better help those who come after you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

}

class BloodPriceGirl extends MagicalGirlCharacterObject{
    int hp = 113;
  BloodPriceGirl(String name, String dollString) : super(name, dollString);

  static Future<BloodPriceGirl> randomGirl() async {
      MagicalDoll doll = new MagicalDoll();
      await doll.setNameFromEngine();
      return new BloodPriceGirl(doll.dollName, doll.toDataBytesX());
  }

}

//TODO make actually a monster dollset not a magical girl (its a subset tho???)
class MonsterGirl extends MagicalGirlCharacterObject{
    int hp = 9999;
    MonsterGirl(String name, String dollString) : super(name, dollString);

    static Future<MonsterGirl> randomGirl() async {
        MagicalDoll doll = new MagicalDoll();
        await doll.setNameFromEngine();
        return new MonsterGirl(doll.dollName, doll.toDataBytesX());
    }

}