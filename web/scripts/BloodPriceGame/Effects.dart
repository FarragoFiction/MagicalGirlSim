import "dart:async";
import "dart:html";

import 'SoundHandler.dart';

abstract class Effects {
    static final Element _box = querySelector("#gameBox");

    static void magicHit(int x, int y) {
        SoundHandler.meatSound();
        _spawn("hit1", x, y, 800);
    }
    static void weaponHit(int x, int y) {
        SoundHandler.meatSound();
        _spawn("hit2", x, y, 800);
    }

    static void _spawn(String type, int x, int y, int duration) {
        final Element effect = new DivElement()
            ..className="hit $type"
            ..style.left="${x}px"
            ..style.top="${y}px";
        _box.append(effect);

        new Timer(new Duration(milliseconds: duration), effect.remove);
    }
}