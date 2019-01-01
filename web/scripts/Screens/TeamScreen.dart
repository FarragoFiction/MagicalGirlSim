import '../MagicalAdventure.dart';
import '../MagicalGirlCharacterObject.dart';
import 'DressupScreen.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'dart:html';

class TeamScreen extends GameScreen {

    @override
    Future<Null> setup(Element parent) async {
        super.setup(parent);
        girls.forEach((MagicalGirlCharacterObject girl) async {
            DivElement girlContainer = new DivElement()..classes.add("girlContainer");
            container.append(girlContainer);
            showGirlWithStats(girl, girlContainer);
        });
    }

    Future<Null> showGirlWithStats(MagicalGirlCharacterObject girl, Element subcontainer) async {
        await girl.makeViewer(subcontainer);
        makeButtons(girl, subcontainer);
    }


    void makeButtons(MagicalGirlCharacterObject girl, Element subContainer) {
        makeAdventureButton(girl, subContainer);
    }

    void makeAdventureButton(MagicalGirlCharacterObject girl, Element subContainer) {
        ButtonElement button = new ButtonElement()..classes.add("adventureButton")..text = "Go on Mission!";
        subContainer.append(button);
        button.onClick.listen((Event e) {
            MagicalAdventure adventure = new MagicalAdventure(girl);
            adventure.start(subContainer);
        });
    }

    void makeDressupButton(MagicalGirlCharacterObject girl, Element subContainer) {
        ButtonElement button = new ButtonElement()..classes.add("adventureButton")..text = "Go on Mission!";
        subContainer.append(button);
        button.onClick.listen((Event e) {
            showNewScreen(new DressupScreen(girl));
        });
    }

}