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
        dismiss.onClick.listen((Event e){
            game.clickSound();
            pop.remove();
        });
        pop.append(dismiss);
        content.text = await getText();


    }

    Future<String> getText()async {
        bool actuallyWon = won();
        int prize = results(actuallyWon);
        Narrative narrative = await getNarrative();
        narrative.story.setString("name",girl.name);

        setAdj(narrative);
        setAttackName(narrative);
        setEnemyType(narrative);
        setMagicalCompanion(narrative);
        setMysteriousStranger(narrative);
        setWeaponType(narrative);
        narrative.engine.setSeed(rand.nextInt());
        //story.setString("name2","${participants.last.name}");
        if(actuallyWon) {
            return await getWinningText(prize,narrative);
        }else {
            return await getLosingText(prize,narrative);

        }
        //"OMFG DO THIS PLZ. $prizeString $prize magicules."..classes.add("adventureContent
    }

    Future<Narrative> getNarrative() async {
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
      return new Narrative(textEngine, story);
    }

    /*
     int get attackSeed => (doll as MagicalDoll).bowBack.imgNumber;
  int get magicalCompanionSeed => (doll as MagicalDoll).skirt.imgNumber;
  int get weaponSeed => (doll as MagicalDoll).frontBow.imgNumber;
     */

    void setAdj(Narrative narrative) {
        //TODO use the text engine to fetch a magical adj like sparkling, shining ,hopefilled etc.
        String adj = getAdj(narrative);
        print("adj set to $adj");
        narrative.story.setString("attackAdj",adj.toUpperCase());
    }

    String getAdj(Narrative narrative) {
      int s = girl.themeSeed;
      return narrative.getPhrase(s,"PossibleThemeAdjectives");
    }

    void setAttackName(Narrative narrative) {
        String adj = getAttackName(narrative);
        print("attack set to $adj");
        narrative.story.setString("attackName",adj.toUpperCase());
    }

    String getAttackName(Narrative narrative) {
      int s = girl.attackSeed;
      return narrative.getPhrase(s,"PossibleAttackNames");
    }

    void setMysteriousStranger(Narrative narrative) {
        String adj = getStranger(narrative);
        print("stranger set to $adj");
        narrative.story.setString("mysteriousStranger",adj.toUpperCase());
    }

    String getStranger(Narrative narrative) {
      int s = girl.mysteriousStrangerSeed;
      return narrative.getPhrase(s,"mysteriousStrangerTypes");
    }

    void setMagicalCompanion(Narrative narrative) {
        String adj = getCompanion(narrative);
        print("companion set to $adj");
        narrative.story.setString("magicalCompanion",adj.toUpperCase());
    }

    String getCompanion(Narrative narrative) {
      int s = girl.magicalCompanionSeed;
      return narrative.getPhrase(s,"magicalCompanionTypes");
    }

    void setEnemyType(Narrative narrative) {
        String adj = getEnemy(narrative);
        print("enemy set to $adj");
        narrative.story.setString("enemyType",adj.toUpperCase());
    }

    String getEnemy(Narrative narrative) {
      int s = girl.enemySeed;
      return narrative.getPhrase(s,"possibleEnemyTypes");
    }

    void setWeaponType(Narrative narrative) {
        String adj = getWeapon(narrative);
        print("weapon set to $adj");
        narrative.story.setString("weapon",adj.toUpperCase());
    }

    String getWeapon(Narrative narrative) {
      int s = girl.weaponSeed;
      return narrative.getPhrase(s,"possibleWeaponTypes");
    }

    Future<String> getWinningText(int prize,Narrative narrative) async {
        //            storyText = "$storyText ${getLines('Beginning', textEngine, story)}\n \n ";
        String flavor = narrative.engine.phrase("winningText", story: narrative.story);
        String prizeString = "${girl.name} earned $prize magicules.";
        print("flavor set to $flavor");
        return "$flavor $prizeString";
    }



    Future<String> getLosingText(int penalty, Narrative narrative) async {
        String flavor = narrative.engine.phrase("losingText", story: narrative.story);
        String prizeString = "${girl.name} lost $penalty magicules.";
        print("flavor set to $flavor");
        return "$flavor $prizeString";

    }

    Future<Null> getPortrait(Element portrait) async {
        CanvasElement canvas = await girl.portrait;
        portrait.append(canvas);
    }



    //more likely than not to succeed
    bool won() {
        int powerLevel = girl.statSum;
        if(powerLevel >= 113*8) {
            return true;
        }else if(powerLevel > 113*4) {
            return rand.nextDouble()>.25; //75% chance
        }else if(powerLevel > 113) {
            return rand.nextBool(); //50/50
        }else {
            return false; //just no
        }
    }

    int results(bool actuallyWon) {
        int amount = (rand.nextIntRange(13,113)*girl.efficiencyRating).ceil();
        if(!actuallyWon) {
            amount = amount * -1;
            girl.lose(amount);
        }else {
            girl.win(amount);
        }
        game.addFunds(amount);
        return amount;
    }


}

class Narrative {
    TextEngine engine;
    TextStory story;
    Narrative(TextEngine this.engine, TextStory this.story);

    String getPhrase(int seed, String identifier) {
        engine.setSeed(seed);
        String phrase = engine.phrase(identifier, story: story);
        return phrase;
    }
}