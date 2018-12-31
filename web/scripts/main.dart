import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';
import 'package:CreditsLib/CharacterLib.dart';
import 'package:DollLibCorrect/src/Dolls/Doll.dart';
import 'package:DollLibCorrect/src/Dolls/MagicalDoll.dart';

Future<Null> main() async {
  await Doll.loadFileData();
  MagicalDoll doll = new MagicalDoll();
  await doll.setNameFromEngine();
  MagicalGirlCharacterObject co2 = new MagicalGirlCharacterObject(doll.dollName, doll.toDataBytesX());
  await co2.makeViewer(querySelector("#output"));
}
