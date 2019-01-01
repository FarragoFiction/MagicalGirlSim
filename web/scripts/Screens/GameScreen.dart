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

    void makeBackButton() {
        if(parent != null) {
            ButtonElement button = new ButtonElement()..text = "Back";
            button.onClick.listen((Event e)
            {
                //TODO think carefully if i want to preserve the original parent strucutre or make the current screen the new parent
                teardown();
                parent.setup(parentContainer);
            });
        }
    }


    void setup(Element element) {
        parentContainer = element;
        container = new DivElement();
        parentContainer.append(container);
        game.currentScreen = this;
    }
}