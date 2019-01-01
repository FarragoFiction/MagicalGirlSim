import '../Game.dart';
import '../MagicalGirlCharacterObject.dart';
import 'dart:html';

abstract class GameScreen {
    Element parentContainer;
    //one stop shop for removing this shit.
    Element container;
    //useful for 'back' buttons
    GameScreen parent;

    Game game = Game.instance;
    List<MagicalGirlCharacterObject> get girls => game.girls;

    void showNewScreen(GameScreen child) {
        teardown();
        child.parent = this;
        child.setup(parentContainer);
    }
    void teardown() {
        container.remove();
    }


    void setup(Element element) {
        parentContainer = element;
        container = new DivElement();
        parentContainer.append(container);
    }
}