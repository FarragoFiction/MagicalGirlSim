//uses facts about the target girl to generate a magical adventure blurb.

import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

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
        if(actuallyWon) {
            return await getWinningText(prize);
        }else {
            return await getLosingText(prize);

        }
        //"OMFG DO THIS PLZ. $prizeString $prize magicules."..classes.add("adventureContent
    }

    Future<String> getWinningText(int prize) async {
        String flavor = "TODO: LOAD FROM TEXT ENGINE WITH SET ADJ AND SHIT FOR WINNING";
        String prizeString = "${girl.name} earned $prize. ";
        return "$flavor $prizeString";
    }

    Future<String> getLosingText(int penalty) async {
        String flavor = "TODO: LOAD FROM TEXT ENGINE WITH SET ADJ AND SHIT FOR LOSING";
        String prizeString = "${girl.name} lost $penalty. ";
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