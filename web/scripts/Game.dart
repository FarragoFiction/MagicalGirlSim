import 'MagicalGirlCharacterObject.dart';
import 'Screens/DressupScreen.dart';
import 'Screens/GameScreen.dart';
import 'Screens/TeamScreen.dart';
import 'dart:async';
import 'dart:html';

//TODO save/load from json
//TODO missions take time to return from
//TODO Magical girls can retire/be forced to retire (set number of missions they can do?)
//TODO abilitiy to recruit new magical girl
class Game {
    static Game _instance;
    GameScreen currentScreen;
    AudioElement fx = new AudioElement();
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

    void removeFunds(int amount) {
        _magicules += -1*amount;
        syncMoney();
        //TODO save here.
    }

    Future<Null> display(Element parent) async {
        container = new DivElement();
        parent.append(container);
        moneyContainer = new DivElement()..classes.add("money");
        container.append(moneyContainer);
        currentScreen = new TeamScreen();
        //currentScreen = new DressupScreen(girls.first);
        currentScreen.setup(container);
        syncMoney();
    }

    void syncMoney() {
        moneyContainer.text = "Magicules: $magicules";
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

}