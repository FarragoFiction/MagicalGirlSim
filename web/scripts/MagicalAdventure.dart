//uses facts about the target girl to generate a magical adventure blurb.

import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
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

    void popup(Element container) {
        DivElement pop = new DivElement()..classes.add("adventurePopup");
        int prize = results();
        String prizeString = "${girl.name} earned ";
        if(prize < 0) {
            prizeString = "${girl.name} lost ";
        }
        pop.text = "OMFG DO THIS PLZ. $prizeString $prize magicules.";
        pop.append(container);
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