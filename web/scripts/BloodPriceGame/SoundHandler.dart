import 'dart:html';

abstract class SoundHandler {
    static AudioElement fx = new AudioElement();
    static AudioElement music = new AudioElement()..loop = true;
    static int musicTier = 0;

    static void meatSound() {
        playSoundEffect("85846__mwlandi__meat-slap-2");
    }

    static void magicSound() {
        playSoundEffect("magicattack");
    }

    static void moneySound() {
        playSoundEffect("121990__tomf__coinbag");
    }

    static void monsterSound() {
        playSoundEffect("weed");
    }

    static void clickSound() {
        playSoundEffect("254286__jagadamba__mechanical-switch");
    }

    static void bumpTier() {
        musicTier ++;
        playTier();
    }
    // thanks manic
    static void playTier() {
        print("play tier $musicTier");
        if(musicTier == 0) {
            playMusic("Magical_Theme");
        }else if(musicTier == 1) {
            playMusic("Magical_Theme_Corrupted_1");
        }else if(musicTier == 2) {
            playMusic("Magical_Theme_Corrupted_2");
        }else {
            playMusic("Magical_Theme_Corrupted_3");
        }
    }

    static void playMusic(String locationWithoutExtension) {
        if(music.canPlayType("audio/mpeg").isNotEmpty) music.src = "Music/${locationWithoutExtension}.mp3";
        if(music.canPlayType("audio/ogg").isNotEmpty) music.src = "Music/${locationWithoutExtension}.ogg";
        music.play();
    }

    static void playSoundEffect(String locationWithoutExtension) {
        if(fx.canPlayType("audio/mpeg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.mp3";
        if(fx.canPlayType("audio/ogg").isNotEmpty) fx.src = "SoundFX/${locationWithoutExtension}.ogg";
        fx.play();

    }
}