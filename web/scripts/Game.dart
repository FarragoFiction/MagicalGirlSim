import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

//TODO save/load from json
class Game {
    static Game _instance;
    static Game get instance {
        if(_instance == null) {
            _instance = new Game();
        }
        return _instance;
    }
    int _magicules = 0;
    int get magicules => _magicules;

    Element container;
    Element moneyContainer;
    List<MagicalGirlCharacterObject> girls = new List<MagicalGirlCharacterObject>();


    Future<Null> initGirls()async {
        for(int i = 0; i<3; i++) {
            MagicalGirlCharacterObject girl = await MagicalGirlCharacterObject.randomGirl();
            girls.add(girl);
        }
    }

    void addFunds(int amount) {
        _magicules += amount;
        syncMoney();
        //TODO save here.
    }

    Future<Null> display(Element parent) async {
        container = new DivElement();
        parent.append(container);
        moneyContainer = new DivElement();
        container.append(moneyContainer);
        girls.forEach((MagicalGirlCharacterObject girl) async {
            DivElement girlContainer = new DivElement()..classes.add("girlContainer");
            container.append(girlContainer);
            await girl.makeViewer(girlContainer);
            girl.makeButton(girlContainer);
        });
        syncMoney();
    }

    void syncMoney() {
        moneyContainer.text = "Magicules: $magicules";
    }

}