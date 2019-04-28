import "dart:async";
import "dart:html";

abstract class Effects {
    static final Element _box = querySelector("#gameBox");

    static void magicHit(int x, int y) => _spawn("hit1", x, y, 800);

    static void _spawn(String type, int x, int y, int duration) {
        final Element effect = new DivElement()
            ..className="hit $type"
            ..style.left="${x}px"
            ..style.top="${y}px";
        _box.append(effect);

        new Timer(new Duration(milliseconds: duration), effect.remove);
    }
}