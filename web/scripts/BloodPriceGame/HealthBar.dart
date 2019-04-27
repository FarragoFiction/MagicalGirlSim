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

    void display(Element parent) {
        container.classes.add("healthBar");
        girlHP.classes.add("girlHP");
        monsterHP.classes.add("monsterHP");
        container.append(girlHP);
        container.append(monsterHP);
        parent.append(container);
    }
}