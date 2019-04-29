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

    //todo maybe images?
    Future<void> cutscene(String text, Element sceneContents) async {
        //have to click to get past it or something.
        Element scene = new DivElement()..classes.add("cutscene");
        DivElement textElement = new DivElement()..text = text;
        scene.append(textElement);
        scene.append(sceneContents);
        container.append(scene);
        final Completer<void> completer = new Completer();
        scene.onClick.listen((Event event) {
            scene.remove();
            completer.complete();
        });
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
    Future<void> damageGraphicGirl(int tick, int amount, [Element element]) async {
        int maxTicks = 2;
        if(element == null) {
            element = new DivElement()
                ..classes.add("girlDamageGraphic")
                ..text = "$amount";
            container.append(element);
            element.animate([{"opacity": 100},{"opacity": 0}], 3000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 1000), () =>
                damageGraphicMonster(tick+1, amount, element));
        }else {
            element.remove();
        }
    }


    Future<void> damageGraphicMonster(int tick, int amount, [Element element]) async {
        int maxTicks = 2;
        if(element == null) {
            element = new DivElement()
                ..classes.add("monsterDamageGraphic")
                ..text = "$amount";
            container.append(element);
            element.animate([{"opacity": 100},{"opacity": 0}], 3000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 1000), () =>
                damageGraphicMonster(tick+1, amount, element));
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