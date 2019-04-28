import "dart:async";
import "dart:html";

import 'SoundHandler.dart';

abstract class Effects {
    static final Element _box = querySelector("#gameBox");

    // hit effects
    //#######################################

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

    // city damage layers
    //#######################################

    static int _damageLevel = 0;
    static const int damageLayers = 3;

    static void damageCity() {
        if (_damageLevel < damageLayers) {
            _damageLevel++;

            _box.append(new DivElement()..className="damage damage$_damageLevel");
        }
    }
}