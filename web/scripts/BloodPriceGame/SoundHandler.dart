import 'dart:html';

abstract class SoundHandler {
    static AudioElement fx = new AudioElement();

    static void moneySound() {
        playSoundEffect("121990__tomf__coinbag");
    }

    static void clickSound() {
        playSoundEffect("254286__jagadamba__mechanical-switch");
    }

    static void playSoundEffect(String locationWithoutExtension) {
        if(fx.canPlayType("audio/mpeg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(fx.canPlayType("audio/ogg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.ogg";
        fx.play();

    }
}