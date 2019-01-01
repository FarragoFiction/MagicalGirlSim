//uses facts about the target girl to generate a magical adventure blurb.

import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:TextEngine/TextEngine.dart';

class MagicalAdventure {
    MagicalGirlCharacterObject girl;
    Game game;
    Random rand = new Random();

    MagicalAdventure(MagicalGirlCharacterObject this.girl) {
        game = Game.instance;
        rand.nextInt();

    }

    void start(Element container) {
        popup(container);

    }

    Future<Null> popup(Element container) async {
        DivElement pop = new DivElement()..classes.add("adventurePopup");

        container.append(pop);
        DivElement portrait = new DivElement();
        pop.append(portrait);
        DivElement content = new DivElement()..text = "...";
        pop.append(content);
        getPortrait(portrait);
        ButtonElement dismiss = new ButtonElement()..text = "Okay"..classes.add("adventureButton");
        dismiss.onClick.listen((Event e) =>pop.remove());
        pop.append(dismiss);
        content.text = await getText();


    }

    Future<String> getText()async {
        bool actuallyWon = won();
        int prize = results(actuallyWon);
        TextEngine textEngine;

        if (girl.doll.useAbsolutePath) {
            //absolute location, don't need to keep shit maintained between sims
            //print("trying absolute location first");
            textEngine = new TextEngine(13, "/WordSource");
        } else {
            //relative location for testing
            print("using relative location, must be testing locally");
            textEngine = new TextEngine(13);
        }

        TextStory story = new TextStory();
        await textEngine.loadList("Mission");
        story.setString("name",girl.name);

        setAdj(textEngine,story);
        setAttackName(textEngine,story);
        textEngine.setSeed(rand.nextInt());
        //story.setString("name2","${participants.last.name}");
        if(actuallyWon) {
            return await getWinningText(prize,textEngine, story);
        }else {
            return await getLosingText(prize,textEngine, story);

        }
        //"OMFG DO THIS PLZ. $prizeString $prize magicules."..classes.add("adventureContent
    }

    /*
     int get attackSeed => (doll as MagicalDoll).bowBack.imgNumber;
  int get magicalCompanionSeed => (doll as MagicalDoll).skirt.imgNumber;
  int get weaponSeed => (doll as MagicalDoll).frontBow.imgNumber;
     */

    void setAdj(TextEngine engine, TextStory story) {
        //TODO use the text engine to fetch a magical adj like sparkling, shining ,hopefilled etc.
        int s = girl.themeSeed;
        engine.setSeed(s);
        String adj = engine.phrase("PossibleThemeAdjectives", story: story);
        story.setString("attackAdj",adj.toUpperCase());

    }

    void setAttackName(TextEngine engine, TextStory story) {
        int s = girl.attackSeed;
        engine.setSeed(s);
        String adj = engine.phrase("PossibleAttackNames", story: story);
        story.setString("attackName",adj.toUpperCase());
    }

    void setMysteriousStranger(TextEngine engine, TextStory story) {
        int s = girl.attackSeed;
        engine.setSeed(s);
        String adj = engine.phrase("mysteriousStrangerTypes", story: story);
        story.setString("mysteriousStranger",adj.toUpperCase());
    }

    void setMagicalCompanion(TextEngine engine, TextStory story) {
        int s = girl.attackSeed;
        engine.setSeed(s);
        String adj = engine.phrase("magicalCompanionTypes", story: story);
        story.setString("mysteriousStranger",adj.toUpperCase());
    }

    void setEnemyType(TextEngine engine, TextStory story) {
        int s = girl.attackSeed;
        engine.setSeed(s);
        String adj = engine.phrase("magicalCompanionTypes", story: story);
        story.setString("mysteriousStranger",adj.toUpperCase());
    }

    void setWeaponType(TextEngine engine, TextStory story) {
        int s = girl.attackSeed;
        engine.setSeed(s);
        String adj = engine.phrase("possibleWeaponTypes", story: story);
        story.setString("weapon",adj.toUpperCase());
    }

    Future<String> getWinningText(int prize, TextEngine textEngine, TextStory story) async {
        //            storyText = "$storyText ${getLines('Beginning', textEngine, story)}\n \n ";
        String flavor = textEngine.phrase("winningText", story: story);
        String prizeString = "${girl.name} earned $prize magicules.";


        return "$flavor $prizeString";
    }



    Future<String> getLosingText(int penalty, TextEngine textEngine, TextStory story) async {
        String flavor = textEngine.phrase("losingText", story: story);
        String prizeString = "${girl.name} lost $penalty magicules.";
        return "$flavor $prizeString";

    }

    Future<Null> getPortrait(Element portrait) async {
        CanvasElement canvas = await girl.portrait;
        portrait.append(canvas);
    }



        //TODO make this based on something.
    bool won() {
        return rand.nextBool();
    }

    int results(bool actuallyWon) {
        int amount = rand.nextIntRange(13,113);
        if(!actuallyWon) {
            amount = amount * -1;
        }
        game.addFunds(amount);
        return amount;
    }


}