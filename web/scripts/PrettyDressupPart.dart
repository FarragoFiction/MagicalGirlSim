import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

import 'package:DollLibCorrect/src/Dolls/Layers/SpriteLayer.dart';
import 'package:RenderingLib/RendereringLib.dart';

class PrettyDressupPart {
    MagicalGirlCharacterObject girl;
    SpriteLayer layer;
    SpriteLayer layerToChange;

    PrettyDressupPart(SpriteLayer this.layerToChange, int imgNumber, MagicalGirlCharacterObject this.girl) {
        layer = new SpriteLayer(layerToChange.name, layerToChange.imgNameBase,imgNumber, layerToChange.maxImageNumber);
    }

    //TODO on click need to rerender the girl doll with the layer to mimic set to this
    Future<Null> render(Element subcontainer) async {
        //full size
        CanvasElement tmpCanvas = await girl.doll.blankCanvas;
        await layer.drawSelf(tmpCanvas);

        CanvasElement canvas = girl.doll.blankCanvas;

        await girl.makeViewerBorder(canvas);
        Renderer.swapPalette(tmpCanvas, girl.doll.paletteSource, girl.doll.palette);

        canvas.context2D.drawImage(tmpCanvas,0,0);
        subcontainer.append(canvas);
    }
}