import 'dart:html';

import 'BloodPriceGame/BloodPriceGame.dart';
import 'dart:async';
import 'package:DollLibCorrect/src/Dolls/Doll.dart';
import 'package:CommonLib/NavBar.dart';

Future<Null> main() async {
  await loadNavbar();
  await Doll.loadFileData();
  BloodPriceGame game = new BloodPriceGame();
  game.display(querySelector("#output"));

}
