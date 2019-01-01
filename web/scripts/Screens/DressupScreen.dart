import '../MagicalGirlCharacterObject.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'dart:html';

class DressupScreen extends GameScreen {
    MagicalGirlCharacterObject girl;

    DressupScreen(MagicalGirlCharacterObject this.girl);



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
    }

}