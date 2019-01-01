import '../MagicalGirlCharacterObject.dart';
import '../PrettyDressupPart.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:DollLibCorrect/src/Dolls/MagicalDoll.dart';

class DressupScreen extends GameScreen {
    MagicalGirlCharacterObject girl;
    MagicalDoll doll;
    DressupTab skirtTab;

    DressupScreen(MagicalGirlCharacterObject this.girl) {
        doll = girl.doll as MagicalDoll;
        skirtTab = new DressupTab(girl, doll.skirt);
    }



    @override
    Future<Null> setup(Element parent) async {
        super.setup(parent);
        DivElement girlContainer = new DivElement()..classes.add("girlContainer");
        container.append(girlContainer);
        await makeDressup(girlContainer);
    }


    Future<Null> makeDressup(Element subcontainer) async {
        //full size
        CanvasElement tmpCanvas = await girl.doll.getNewCanvas();
        CanvasElement canvas = girl.doll.blankCanvas;
        await girl.makeViewerBorder(canvas);
        canvas.context2D.drawImage(tmpCanvas,0,0);
        subcontainer.append(canvas);
        drawSkirtTab(subcontainer);
    }

    Future<Null> drawSkirtTab(Element subcontainer) async {
        skirtTab.render(subcontainer);

    }

}

class DressupTab {
    List<PrettyDressupPart> parts = new List<PrettyDressupPart>();
    SpriteLayer layerToCollate;
    MagicalGirlCharacterObject girl;

    DressupTab(MagicalGirlCharacterObject this.girl, SpriteLayer this.layerToCollate) {
        init();
    }
    void init() {
        for(int i = 0; i<layerToCollate.maxImageNumber; i++) {
            parts.add(new PrettyDressupPart(layerToCollate, i,girl));
        }
    }

    //TODO also display layer label
    Future<Null> render(Element subcontainer) async {
        for(PrettyDressupPart part in parts) {
            await part.render(subcontainer);
        }
    }
}