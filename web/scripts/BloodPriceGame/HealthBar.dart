import 'dart:async';
import 'dart:html';

import 'Amulet.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';
import 'Companion.dart';

class HealthBar {
    final DivElement container  = new DivElement();
    final DivElement girlHP  = new DivElement();
    final DivElement monsterHP  = new DivElement();
    final DivElement billElement  = new DivElement();

    Element currentPopup;
    HealthBar();

    //if a pact is in play and its cost is not zero, its unpaid
    int get unpaidPacts {

    }
    void updateGirlHP(int number) {
        girlHP.text = "$number HP";
    }

    void updateMonsterHP(int number) {
        monsterHP.text = "$number HP";

    }

    void updateBill(int number) {
        BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
        billElement.innerHtml = "$number Unpaid Pacts.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All Pacts: ⚔️: ${girl.weaponPacts.length} ✨: ${girl.magicPacts.length} 🥚: ${Amulet.bloodPacts.length} 🐥: ${Companion.bloodPacts.length}";

    }

    Future<Element> pickGirlCutscene(String text, Element sceneContents) async {
//have to click to get past it or something.
        Element scene = new DivElement()..classes.add("cutscene");
        DivElement textElement = new DivElement()..innerHtml = text..classes.add("cutsceneText");
        scene.append(textElement);

        scene.append(sceneContents);
        container.append(scene);

        return scene;
    }

    //todo maybe images?
    Future<void> cutscene(String text, Element sceneContents, [bool cantskip = false]) async {
        //have to click to get past it or something.
        Element scene = new DivElement()..classes.add("cutscene");
        DivElement textElement = new DivElement()..innerHtml = text..classes.add("cutsceneText");
        scene.append(textElement);

        scene.append(sceneContents);
        container.append(scene);
        final Completer<void> completer = new Completer();
        if(!cantskip) {
            scene.onClick.listen((Event event) {
                scene.remove();
                completer.complete();
            });
        }else {
            StreamSubscription<Event> listener;
            listener = scene.onClick.listen((Event event) {
                ButtonElement button = new ButtonElement()..text = "Replay?"..classes.add("replayButton");
                scene.append(button);
                button.onClick.listen((Event e) => window.location.href = window.location.href);
                listener.cancel(); //only dot it once plz

            });

        }
        return completer.future;
    }

    Future<bool> twoOptionPopup(String text, String trueOpt, String falseOpt) async {
        final Completer<bool> completer = new Completer();
        DivElement popup = new DivElement()..classes.add("twoOpt");
        ButtonElement opt1Button = new ButtonElement()..text = trueOpt;
        ButtonElement opt2Button = new ButtonElement()..text = falseOpt;
        popup.append(opt1Button);
        popup.append(opt2Button);
        opt1Button.onClick.listen((Event e) {
            completer.complete(true);
        });

        opt2Button.onClick.listen((Event e) {
            completer.complete(false);
        });

        container.append(popup);


        //                completer.complete();
        return completer.future;

    }

    Future<void> popup(String text, int tick) async {
        int maxTicks = 3;

        if(currentPopup != null && tick == 0) {
            currentPopup.remove();
            currentPopup = null;
        }

        if(currentPopup == null) {
            currentPopup = new DivElement()
                ..classes.add("attackpopup")
                ..text = text;
            container.append(currentPopup);
        }
        if(tick == 1) {
            currentPopup.animate([{"opacity": 100},{"opacity": 0}], 9000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 4000), () =>
                popup(text, tick+1));
        }else {
            currentPopup.remove();
        }

    }

    //jitter? pulse?
    Future<void> damageGraphicGirl(int tick, int amount, int magicBonus, int weaponBonus, [Element element]) async {
        int maxTicks = 2;
        final int companionBonus = Companion.bloodPacts.length; //monster always has this active

        if(element == null) {
            String bonus = getBonus(magicBonus,weaponBonus, companionBonus);
            element = new DivElement()
                ..classes.add("girlDamageGraphic")
                ..text = "${amount > 0 ? "+":""}$amount $bonus";
            container.append(element);
            element.animate([{"opacity": 100},{"opacity": 0}], 3000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 1000), () =>
                damageGraphicGirl(tick+1, amount, magicBonus, weaponBonus, element));
        }else {
            element.remove();
        }
    }

    String getBonus(int magicBonus, int weaponBonus, int companionBonus) {
        String ret = "";

        final int eggBonus = Amulet.bloodPacts.length;

        if(weaponBonus > 0) {
            ret = "$ret x ${weaponBonus}⚔️";
        }

        if(magicBonus > 0) {
            ret = "$ret x ${magicBonus}✨ ";
        }

        if(eggBonus > 0) {
            ret = "$ret x ${eggBonus}🥚 ";
        }

        if(companionBonus > 0) {
            ret = "$ret x ${companionBonus}🐥 ";
        }

        return ret;

    }


    Future<void> damageGraphicMonster(int tick, int amount, int magicBonus, int weaponBonus,int companionBonus, [Element element]) async {
        final int maxTicks = 2;
        if(element == null) {
            String bonus = getBonus(magicBonus,weaponBonus, companionBonus);
            element = new DivElement()
                ..classes.add("monsterDamageGraphic")
                ..text = "$amount $bonus";
            container.append(element);
            element.animate([{"opacity": 100},{"opacity": 0}], 3000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 1000), () =>
                damageGraphicMonster(tick+1, amount,magicBonus, weaponBonus, companionBonus, element));
        }else {
            element.remove();
        }


    }

    void display(Element parent) {
        container.classes.add("healthBar");
        girlHP.classes.add("girlHP");
        monsterHP.classes.add("monsterHP");
        billElement.classes.add("billElement");
        container.append(girlHP);
        container.append(monsterHP);
        container.append(billElement);
        parent.append(container);
    }
}