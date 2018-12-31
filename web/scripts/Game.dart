import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

//TODO save/load from json
class Game {
    int magicules = 0;
    Element container;
    List<MagicalGirlCharacterObject> girls = new List<MagicalGirlCharacterObject>();


    Future<Null> initGirls()async {
        for(int i = 0; i<3; i++) {
            MagicalGirlCharacterObject girl = await MagicalGirlCharacterObject.randomGirl();
            girls.add(girl);
        }
    }

    Future<Null> display(Element parent) async {
        DivElement container = new DivElement();
        parent.append(container);
        girls.forEach((MagicalGirlCharacterObject girl) {
            girl.makeViewer(container);
        });
    }

}