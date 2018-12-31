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
        int prize = results();
        window.alert("Gained $prize");
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