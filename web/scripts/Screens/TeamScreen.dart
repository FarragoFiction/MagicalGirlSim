import '../MagicalGirlCharacterObject.dart';
import 'GameScreen.dart';
import 'dart:html';

class TeamScreen extends GameScreen {

    @override setup(Element parent) {
        super.setup(parent);
        girls.forEach((MagicalGirlCharacterObject girl) async {
            DivElement girlContainer = new DivElement()..classes.add("girlContainer");
            container.append(girlContainer);
            await girl.makeViewer(girlContainer);
            girl.makeButton(girlContainer);
        });
    }

}