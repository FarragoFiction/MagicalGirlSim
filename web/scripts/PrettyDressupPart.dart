import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
import 'Screens/DressupScreen.dart';
import 'dart:async';
import 'dart:html';

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/src/Dolls/Layers/SpriteLayer.dart';
import 'package:RenderingLib/RendereringLib.dart';

class PrettyDressupPart {
    MagicalGirlCharacterObject girl;
    SpriteLayer layer;
    SpriteLayer layerToChange;


    PrettyDressupPart(SpriteLayer this.layerToChange, int imgNumber, MagicalGirlCharacterObject this.girl) {
        layer = new SpriteLayer(layerToChange.name, layerToChange.imgNameBase,imgNumber, layerToChange.maxImageNumber);
    }

    Future<Null> render(Element subcontainer) async {
        //full size
        CanvasElement tmpCanvas = await girl.doll.blankCanvas;
        await layer.drawSelf(tmpCanvas);

        CanvasElement canvas = new CanvasElement(width:100,height:100);

        await girl.makeViewerBorder(canvas);
        Renderer.swapPalette(tmpCanvas, girl.doll.paletteSource, girl.doll.palette);

        canvas.context2D.drawImageScaled(tmpCanvas,0,0,100,100);
        subcontainer.append(canvas);

        canvas.onClick.listen((Event e)
        {
            changeOutfit();
        });
    }

    void changeOutfit() {
      layerToChange.imgNumber = layer.imgNumber;
      DressupScreen screen  =Game.instance.currentScreen as DressupScreen;
      screen.syncDressup();
      window.scrollTo(0,0);
    }

    static imgNumberToPowerLevel(int number) {
        Random rand = new Random(number);
        return rand.nextIntRange(-13,13);
    }
}