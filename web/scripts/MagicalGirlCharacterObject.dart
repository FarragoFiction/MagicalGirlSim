import 'MagicalAdventure.dart';
import 'dart:async';
import 'dart:html';
import 'package:CommonLib/Colours.dart';
import 'package:CreditsLib/CharacterLib.dart';
import 'package:CreditsLib/src/StatObject.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:LoaderLib/src/loader.dart';
import 'package:RenderingLib/RendereringLib.dart';
/*

TODO: magical girls can choose to retire, go to magical girl valhalla or be forced to retire.
 */

class MagicalGirlCharacterObject extends CharacterObject {
  CanvasElement _portrait = new CanvasElement(width: 200, height:200);
  int _numberWins = 0;
  int _numberLosses = 0;
  bool dirty = true;
  Future<CanvasElement> get portrait async {
      if(dirty) {
          CanvasElement tmp = await doll.getNewCanvas();
          _portrait.context2D.clearRect(0,0,_portrait.width, _portrait.height);
          _portrait.context2D.drawImage(tmp,-230,-100);
      }
      return _portrait;
  }
  MagicalGirlCharacterObject(String name, String dollString) : super(name, dollString) {
    _portrait.classes.add("portrait");
  }

  void makeButton(Element subContainer) {
    ButtonElement button = new ButtonElement()..classes.add("adventureButton")..text = "Go on Mission!";
    subContainer.append(button);
    button.onClick.listen((Event e) {
        MagicalAdventure adventure = new MagicalAdventure(this);
        adventure.start(subContainer);

    });
  }
  int get themeSeed {
      return doll.associatedColor.red + doll.associatedColor.green + doll.associatedColor.blue;

  }
  int get attackSeed => (doll as MagicalDoll).bowBack.imgNumber;
  //if multiple magical girls have the same skirt they are obviously on the same team
  int get enemySeed => (doll as MagicalDoll).skirt.imgNumber;
  int get mysteriousStrangerSeed => (doll as MagicalDoll).shoes.imgNumber;
  int get magicalCompanionSeed => (doll as MagicalDoll).socks.imgNumber;
  int get weaponSeed => (doll as MagicalDoll).frontBow.imgNumber;



  void win() {
        _numberWins ++;
  }

  void lose() {
    _numberLosses ++;
  }

  @override
  Future<Null> makeViewer(Element subContainer) async {
      canvasViewer = new DivElement();
      canvasViewer.classes.add("magicalCard");
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
      canvas.context2D.fillStyle = "rgba(${color.red}, ${color.green}, ${color.blue}, 0.15)";
      int buffer = 15;
      canvas.context2D.fillRect(buffer, buffer, canvas.width-buffer*2, canvas.height-buffer*2);
      canvas.context2D.strokeRect(lineWidth-2,lineWidth-2,canvas.width-(lineWidth+2), canvas.height-(lineWidth+2));
  }

  static Future<MagicalGirlCharacterObject> randomGirl() async {
      MagicalDoll doll = new MagicalDoll();
      await doll.setNameFromEngine();
      return new MagicalGirlCharacterObject(doll.dollName, doll.toDataBytesX());
  }

  @override
  void makeViewerText(CanvasElement canvas) {
      Colour color = new Colour.hsv(doll.associatedColor.hue, 0.3, 0.7);
      canvas.context2D.fillStyle = "${color.toStyleString()}";
      canvas.context2D.strokeStyle = "${color.toStyleString()}";
      int fontSize = 24;
      int currentY = (300+fontSize*2).ceil();

      canvas.context2D.font = "bold ${fontSize}pt cabin";
      Renderer.wrapTextAndResizeIfNeeded(canvas.context2D, name, "cabin", 20, currentY, fontSize, cardWidth-50, fontSize);
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