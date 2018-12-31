import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

//TODO save/load from json
class Game {
    int magicules = 0;
    Element container;
    Element moneyContainer;
    List<MagicalGirlCharacterObject> girls = new List<MagicalGirlCharacterObject>();


    Future<Null> initGirls()async {
        for(int i = 0; i<3; i++) {
            MagicalGirlCharacterObject girl = await MagicalGirlCharacterObject.randomGirl();
            girls.add(girl);
        }
    }

    Future<Null> display(Element parent) async {
        container = new DivElement();
        parent.append(container);
        moneyContainer = new DivElement();
        container.append(moneyContainer);
        girls.forEach((MagicalGirlCharacterObject girl) {
            girl.makeViewer(container);
        });
        syncMoney();
    }

    void syncMoney() {
        moneyContainer.text = "Magicules: $magicules";
    }

}