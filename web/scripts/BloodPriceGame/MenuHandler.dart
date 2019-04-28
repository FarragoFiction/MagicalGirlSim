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
            secondMenu.style.display = "none";
            thirdMenu.style.display = "none";
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
                menu.classes.remove("invertedItem");

            }else {
                secondMenu.style.display = "none";
                thirdMenu.style.display = "none";
                menu.classes.add("invertedItem");
            }
        });
        container.append(menu);
    }

    void unmarkChildren(Element menu) {
        for(final Element e in menu.children) {
            e.classes.remove("invertedItem");

        }
    }

    void displayHealthBargainOpt(Element container) {
        final DivElement menu = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "Health Pact >";
        container.append(menu);
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text = ("Trade future health for current health. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            menu.classes.add("invertedItem");

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
            menu.classes.add("invertedItem");

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
            menu.classes.add("invertedItem");
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
            menu.classes.add("invertedItem");

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
            menu.classes.add("invertedItem");

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