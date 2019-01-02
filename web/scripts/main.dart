import 'Game.dart';
import 'MagicalGirlCharacterObject.dart';
import 'dart:async';
import 'dart:html';
import 'package:CreditsLib/CharacterLib.dart';
import 'package:DollLibCorrect/src/Dolls/Doll.dart';
import 'package:DollLibCorrect/src/Dolls/MagicalDoll.dart';
import 'package:CommonLib/NavBar.dart';

Future<Null> main() async {
  await loadNavbar();
  await Doll.loadFileData();
  Game game =Game.instance;
  await game.initGirls();
  await game.display(querySelector("#output"));

}
