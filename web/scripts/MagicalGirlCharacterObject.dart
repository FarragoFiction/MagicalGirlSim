import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Colours.dart';
import 'package:CreditsLib/CharacterLib.dart';
import 'package:CreditsLib/src/StatObject.dart';
import 'package:LoaderLib/src/loader.dart';
import 'package:RenderingLib/RendereringLib.dart';

class MagicalGirlCharacterObject extends CharacterObject {
  MagicalGirlCharacterObject(String name, String dollString) : super(name, dollString);


  @override
  Future<Null> makeViewer(Element subContainer) async {
      canvasViewer = new DivElement();
      canvasViewer.classes.add("charViewer");
      subContainer.append(canvasViewer);
      CanvasElement canvas = new CanvasElement(width: cardWidth, height: cardHeight);
      canvasViewer.append(canvas);
      await makeViewerBorder(canvas);
      makeViewerDoll(canvas);
      makeViewerText(canvas);
  }

  @override
  Future<Null> makeViewerBorder(CanvasElement canvas) async {
      Colour color = new Colour.hsv(doll.associatedColor.hue, 0.3, 0.7);
      canvas.context2D.strokeStyle = "${color.toStyleString()}";
      int lineWidth = 6;
      canvas.context2D.lineWidth = lineWidth;
      ImageElement image = await  Loader.getResource(("images/BGs/magical.jpg"));
      canvas.context2D.drawImage(image,0,0);
      canvas.context2D.fillStyle = "rgba(${color.red}, ${color.green}, ${color.blue}, 0.1)";
      int buffer = 15;
      canvas.context2D.fillRect(buffer, buffer, canvas.width-buffer*2, canvas.height-buffer*2);
      canvas.context2D.strokeRect(lineWidth-2,lineWidth-2,canvas.width-(lineWidth+2), canvas.height-(lineWidth+2));
  }

  @override
  void makeViewerText(CanvasElement canvas) {
      Colour color = new Colour.hsv(doll.associatedColor.hue, 0.3, 0.7);
      canvas.context2D.fillStyle = "${color.toStyleString()}";
      canvas.context2D.strokeStyle = "${color.toStyleString()}";
      int fontSize = 24;
      int currentY = (300+fontSize*2).ceil();

      canvas.context2D.font = "bold ${fontSize}pt Courier New";
      Renderer.wrapTextAndResizeIfNeeded(canvas.context2D, name, "Courier New", 20, currentY, fontSize, cardWidth-50, fontSize);
      fontSize = 18;
      canvas.context2D.font = "bold ${fontSize}pt Courier New";
      currentY += (fontSize*2).round();
      for(StatObject s in stats) {
          canvas.context2D.fillText("${s.name}:",20,currentY);
          canvas.context2D.fillText("${s.value.abs()}",350-fontSize,currentY);

          currentY += (fontSize*1.2).round();
      }
  }

}