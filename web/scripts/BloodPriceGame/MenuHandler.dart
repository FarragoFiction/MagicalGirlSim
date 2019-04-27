import 'dart:html';

import 'BloodPriceGame.dart';
import 'SoundHandler.dart';

 class MenuHandler {
     Element secondMenu;
     Element thirdMenu;
     Element thirdMenuInsides;

    void displayMenu(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuHolder");
        displayWeapon(menu);
        displayMagic(menu);
        displayCompanion(menu);
        displayBloodPrice(menu);
        displayBloodPriceSub1(container);
        displayBloodPriceSub2(container);
        container.append(menu);
    }



    void displayWeapon(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Weapon";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            BloodPriceGame.instance.handleWeapon();
        });
    }

    void displayMagic(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Magic";
        container.append(menu);
    }

    void displayCompanion(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Companion";
        container.append(menu);
    }

    void displayBloodPrice(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "Blood Price >";
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            if(secondMenu.style.display == "none" || secondMenu.style.display.isEmpty) {
                secondMenu.style.display = 'block';
                menu.style.backgroundColor = "#fdbee5";
                menu.style.color = "#fff0f9";
            }else {
                secondMenu.style.display = "none";
                thirdMenu.style.display = "none";
                menu.style.backgroundColor = "#fff0f9";
                menu.style.color = "#fdbee5";
            }
        });
        container.append(menu);
    }

    void unmarkChildren(Element menu) {
        menu.children.forEach((Element e) {
            e.style.backgroundColor = "#fff0f9";
            e.style.color = "#fdbee5";
        });
    }

    void displayHealthBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Health Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text = ("Trade future health for current health. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayWeaponBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Weapon Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current weapon strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayMagicBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Magic Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current magic strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayCompanionBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Companion Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current companion strength. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

    void displayLegacyBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Legacy Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for the ability to better help those who come after you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.style.backgroundColor = "#fdbee5";
            menu.style.color = "#fff0f9";
        });
    }

     //defaults to hidden
     void displayBloodPriceSub1(Element container) {
         secondMenu = new DivElement()..classes.add("bloodMenu1")..classes.add("menuHolder");

         container.append(secondMenu);
         displayHealthBargainOpt(secondMenu);
         displayWeaponBargainOpt(secondMenu);
         displayMagicBargainOpt(secondMenu);
         displayCompanionBargainOpt(secondMenu);
         displayLegacyBargainOpt(secondMenu);
     }

     //defaults to hidden
     void displayBloodPriceSub2(Element container) {
         thirdMenu = new DivElement()..classes.add("bloodMenu2")..classes.add("menuHolder");
         container.append(thirdMenu);

         final DivElement header = new DivElement()..text = "Blood Price"..classes.add("menuHeader");
         thirdMenu.append(header);

         thirdMenuInsides = new DivElement()..classes.add("menuInsides");
         thirdMenu.append(thirdMenuInsides);

         ButtonElement button = new ButtonElement()..text = "Pay Blood Price"..classes.add("bloodPriceButton");
         thirdMenu.append(button);
         button.onClick.listen((Event e){
             window.alert("TODO: determine which child is selected, do shit.");
         });
     }



 }