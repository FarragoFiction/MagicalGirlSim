import 'dart:async';
import 'dart:html';

class HealthBar {
    final DivElement container  = new DivElement();
    final DivElement girlHP  = new DivElement();
    final DivElement monsterHP  = new DivElement();
    HealthBar();

    void updateGirlHP(int number) {
        girlHP.text = "$number HP";
    }

    void updateMonsterHP(int number) {
        monsterHP.text = "$number HP";

    }

    Future<void> popup(String text, int tick, [Element element]) async {
        int maxTicks = 3;
        if(element == null) {
            element = new DivElement()
                ..classes.add("attackpopup")
                ..text = text;
            container.append(element);
        }
        if(tick == 1) {
            element.animate([{"opacity": 100},{"opacity": 0}], 9000);
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 4000), () =>
                popup(text, tick+1,element));
        }else {
            element.remove();
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
        container.append(girlHP);
        container.append(monsterHP);
        parent.append(container);
    }
}