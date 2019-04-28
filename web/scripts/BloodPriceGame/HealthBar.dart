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


    Future<void> damageGraphicMonster(int tick, int amount, [Element element]) async {
        print("damage tick $tick amount $amount");
        int maxTicks = 2;
        if(element == null) {
            element = new DivElement()
                ..classes.add("monsterDamageGraphic")
                ..text = "-$amount";
            container.append(element);
            element.classes.add("fadeOut");
            element.style.fontSize = "100px"; //starts the fade out, hopefully
        }

        if(tick < maxTicks) {
            new Timer(new Duration(milliseconds: 10000), () =>
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