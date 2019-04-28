import 'MagicalAdventure.dart';
import 'PrettyDressupPart.dart';
import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
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
  CanvasElement cardCanvas;
  int _amountWon = 0;
  int _amountLost = 0;
  int cardHeight = 800;
  MagicalDoll magicDoll;
  CanvasElement statElement;
  String magical_attack;
  String weapon;
  String animal;
  String theme;
  String get theme_weapon => "$theme $weapon";

  //if you generally win more than you lose you'll win even more, sort of like momentum
  double get efficiencyRating {
      if(_amountWon == 0 && _amountLost == 0) return 0.1;
      if(_amountWon != 0 && _amountLost == 0) return 5.0; //perfection
      if(_amountWon == 0 && _amountLost != 0) return 1.0; //bad break

      //no more than triple your value
        return Math.min(( _amountWon.abs()/_amountLost.abs()),3.0);
  }

  bool dirty = true;
    //TODO wire these up
  int get externalClothesModifier {
      int numberOne = magicDoll.skirt.imgNumber;
      int numberTwo = magicDoll.shoes.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);
  }

  int get loyalClothesModifier {
      int numberOne = magicDoll.bowBack.imgNumber;
      int numberTwo = magicDoll.hairBack.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);
  }

  int get curiousClothesModifier {
      int numberOne = magicDoll.glasses.imgNumber;
      int numberTwo = magicDoll.eyes.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);
  }

  int get idealisticClothesModifier {
      int numberOne = magicDoll.hairFront.imgNumber;
      int numberTwo = magicDoll.body.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);
  }

  int get energeticClothesModifier {
      int numberOne = magicDoll.socks.imgNumber;
      int numberTwo = magicDoll.mouth.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);  }

  int get patientClothesModifier {
      int numberOne = magicDoll.eyebrows.imgNumber;
      int numberTwo = magicDoll.frontBow.imgNumber;
      return PrettyDressupPart.imgNumberToPowerLevel(numberOne) + PrettyDressupPart.imgNumberToPowerLevel(numberTwo);
  }

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

  int get themeSeed {
      return doll.associatedColor.red + doll.associatedColor.green + doll.associatedColor.blue;

  }
  int get attackSeed => (doll as MagicalDoll).bowBack.imgNumber;
  //if multiple magical girls have the same skirt they are obviously on the same team
  int get enemySeed => (doll as MagicalDoll).skirt.imgNumber;
  int get mysteriousStrangerSeed => (doll as MagicalDoll).shoes.imgNumber;
  int get magicalCompanionSeed => (doll as MagicalDoll).socks.imgNumber;
  int get weaponSeed => (doll as MagicalDoll).frontBow.imgNumber;



  void win(int amount) {
        _amountWon +=amount;
        syncToCardCanvas();
  }

  void lose(int amount) {
    _amountLost += amount;
    syncToCardCanvas();
  }

  int get statSum {
    int ret = 0;
    stats.forEach((StatObject stat) {
        ret += stat.value.abs();
    });
    return ret;
  }

  @override
  void initializeStats() {
      print("trying to initialize stats with doll $doll");
      stats.clear();
      magicDoll = doll as MagicalDoll;
      stats.add(new StatObject(this, StatObject.PATIENCE,StatObject.IMPATIENCE,patientClothesModifier));
      stats.add(new StatObject(this, StatObject.ENERGETIC,StatObject.CALM,energeticClothesModifier));
      stats.add(new StatObject(this, StatObject.IDEALISTIC,StatObject.REALISTIC,idealisticClothesModifier));
      stats.add(new StatObject(this, StatObject.CURIOUS,StatObject.ACCEPTING,curiousClothesModifier));
      stats.add(new StatObject(this, StatObject.LOYAL,StatObject.FREE,loyalClothesModifier));
      stats.add(new StatObject(this, StatObject.EXTERNAL,StatObject.INTERNAL,externalClothesModifier));
  }



  @override
  Future<Null> makeViewer(Element subContainer) async {
      canvasViewer = new DivElement();
      canvasViewer.classes.add("magicalCard");
      subContainer.append(canvasViewer);
      cardCanvas = new CanvasElement(width: cardWidth, height: cardHeight);
      canvasViewer.append(cardCanvas);
      await makeViewerBorder(cardCanvas);
      makeViewerDoll(cardCanvas);
      makeViewerText(cardCanvas);
  }

  Future syncToCardCanvas() async {
      cardCanvas.context2D.clearRect(0,0, cardCanvas.width, cardCanvas.height);
      await makeViewerBorder(cardCanvas);
      makeViewerDoll(cardCanvas);
      makeViewerText(cardCanvas);
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
  Future<Null> makeViewerText(CanvasElement canvas) async {
      statElement = canvas;
      Colour color = new Colour.hsv(doll.associatedColor.hue, 0.3, 0.7);
      canvas.context2D.fillStyle = "${color.toStyleString()}";
      canvas.context2D.strokeStyle = "${color.toStyleString()}";
      int fontSize = 24;
      int currentY = (300+fontSize*2).ceil();

      canvas.context2D.font = "bold ${fontSize}pt cabin";
      Renderer.wrapTextAndResizeIfNeeded(canvas.context2D, name, "cabin", 20, currentY, fontSize, cardWidth-50, fontSize);
      fontSize = 18;
      canvas.context2D.font = "bold ${fontSize}pt cabin";
      currentY += (fontSize*2).round();
      currentY = displayStats(canvas, 20,currentY, fontSize,275);

      canvas.context2D.fillText("Earned Magicules:",fontSize,currentY);
      canvas.context2D.fillText("$_amountWon",325-fontSize,currentY);
      currentY += (fontSize*1.2).round();

      canvas.context2D.fillText("Lost Magicules:",fontSize,currentY);
      canvas.context2D.fillText("$_amountLost",325-fontSize,currentY);
      currentY += (fontSize*1.2).round();
      currentY += (fontSize*1.2).round();

      await displayTraits(canvas, fontSize, fontSize,currentY);
  }

  Future<void> setShitUp() async {
      MagicalAdventure adventure = new MagicalAdventure(this);
      Narrative narrative =  await adventure.getNarrative();
      magical_attack = await adventure.getAttackName(narrative);
      theme = await adventure.getAdj(narrative).toUpperCase();
      weapon = await adventure.getWeapon(narrative).toUpperCase();
      animal = await adventure.getCompanion(narrative).toUpperCase();


  }

  Future<int> displayTraits(CanvasElement canvas, int fontSize, int x, int currentY) async {
    await setShitUp();

    canvas.context2D.fillText("Magical Attack:",x,currentY);
    currentY += (fontSize*1.2).round();
    canvas.context2D.fillText("$theme $magical_attack".toUpperCase(),x,currentY);
    currentY += (fontSize*2.4).round();

    canvas.context2D.fillText("Weapon:",x,currentY);
    currentY += (fontSize*1.2).round();
    canvas.context2D.fillText("$weapon".toUpperCase(),x,currentY);
    currentY += (fontSize*2.4).round();

    canvas.context2D.fillText("Magical Companion:",x,currentY);
    currentY += (fontSize*1.2).round();
    canvas.context2D.fillText("$animal".toUpperCase(),x,currentY);
    currentY += (fontSize*2.4).round();
    return currentY;

  }

  int displayStats(CanvasElement canvas, int x, int currentY, int fontSize, int statMargin) {
    for(StatObject s in stats) {
        canvas.context2D.fillText("${s.name}:",x,currentY);
        canvas.context2D.fillText("${s.value.abs()}",x+statMargin,currentY);

        currentY += (fontSize*1.2).round();
    }
    return currentY;
  }

}

