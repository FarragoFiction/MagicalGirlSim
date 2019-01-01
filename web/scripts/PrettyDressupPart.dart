import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';

import 'package:DollLibCorrect/src/Dolls/Layers/SpriteLayer.dart';
import 'package:RenderingLib/RendereringLib.dart';

class PrettyDressupPart {
    MagicalGirlCharacterObject girl;
    SpriteLayer layer;

    PrettyDressupPart(SpriteLayer layerToMimic, int imgNumber, MagicalGirlCharacterObject girl) {
        layer = new SpriteLayer(layerToMimic.name, layerToMimic.imgNameBase,imgNumber, layerToMimic.maxImageNumber);
    }

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