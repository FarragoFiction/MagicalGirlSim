//uses facts about the target girl to generate a magical adventure blurb.

import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';

class MagicalAdventure {
    MagicalGirlCharacterObject girl;
    Game game;

    MagicalAdventure(MagicalGirlCharacterObject this.girl) {
        game = Game.instance;
    }

    void start(Element container) {
        popup(container);

    }

    Future<Null> popup(Element container) async {
        DivElement pop = new DivElement()..classes.add("adventurePopup");
        int prize = results();
        String prizeString = "${girl.name} earned ";
        if(prize < 0) {
            prizeString = "${girl.name} lost ";
        }
        container.append(pop);
        DivElement portrait = new DivElement();
        pop.append(portrait);
        DivElement content = new DivElement()..text = "OMFG DO THIS PLZ. $prizeString $prize magicules."..classes.add("adventureContent");
        pop.append(content);
        getPortrait(portrait);
        ButtonElement dismiss = new ButtonElement()..text = "Okay"..classes.add("adventureButton");
        dismiss.onClick.listen((Event e) =>pop.remove());
        pop.append(dismiss);


    }

    Future<Null> getPortrait(Element portrait) async {
        CanvasElement canvas = await girl.portrait;
        portrait.append(canvas);
    }



        //TODO make this based on something.
    bool won() {
        Random rand = new Random();
        rand.nextInt();
        return rand.nextBool();
    }

    int results() {
        int amount = 13;
        if(!won()) {
            amount = amount * -1;
        }
        game.addFunds(amount);
        return amount;
    }


}