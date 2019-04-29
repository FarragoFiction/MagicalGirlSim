import 'dart:html';

import 'Amulet.dart';
import 'BloodPact.dart';
import 'BloodPriceGame.dart';
import 'BloodPriceGirl.dart';
import 'Companion.dart';
import 'SoundHandler.dart';

 class MenuHandler {
     Element firstMenu;
     Element secondMenu;
     Element thirdMenu;
     Element thirdMenuInsides;
     Element legacyChoice;
     Element healthChoice;
     Element weaponChoice;
     Element magicChoice;
     Element companionChoice;


     void displayMenu(Element container) {
        firstMenu = new DivElement()..classes.add("menuHolder");
        displayWeapon(firstMenu);
        displayMagic(firstMenu);
        displayCompanion(firstMenu);
        displayBloodPrice(firstMenu);
        displayBloodPriceSub1(container);
        displayBloodPriceSub2(container);
        container.append(firstMenu);
    }

    void commonClickShit([bool click = true]) {
        if(click) SoundHandler.clickSound();
        secondMenu.style.display = "none";
        thirdMenu.style.display = "none";
    }



    void displayWeapon(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "⚔️ Weapon";
        container.append(menu);
        menu.onClick.listen((Event e) {
            commonClickShit();
            BloodPriceGame.instance.handleWeapon();
            unmarkChildren(container);
        });
    }

    void displayMagic(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "✨ Magic";
        container.append(menu);
        menu.onClick.listen((Event e) {
            commonClickShit();
            BloodPriceGame.instance.handleMagic();
            unmarkChildren(container);
        });
    }

    void displayCompanion(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "🐥 Friend";
        //menu.append(new SpanElement()..className="friend"..text="Friend");
        container.append(menu);
        menu.onClick.listen((Event e) {
            commonClickShit();
            BloodPriceGame.instance.handleCompanion();
            unmarkChildren(container);
        });
    }

    void displayBloodPrice(Element container) {
        final DivElement menu = new DivElement()..classes.add("menuItem")..text = "💖 Blood Price >";
        menu.onClick.listen((Event e) {
            SoundHandler.clickSound();
            if(secondMenu.style.display == "none" || secondMenu.style.display.isEmpty) {
                secondMenu.style.display = 'block';
                menu.classes.add("invertedItem");
                unmarkChildren(secondMenu);
            }else {
                secondMenu.style.display = "none";
                thirdMenu.style.display = "none";
                menu.classes.remove("invertedItem");
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
        healthChoice = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "🚑 Health Pact >";
        container.append(healthChoice);
        healthChoice.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text = ("Trade future health for current health, just for you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            healthChoice.classes.add("invertedItem");

        });
    }

    void displayWeaponBargainOpt(Element container) {
        weaponChoice = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "⚔️ Weapon Pact >";
        container.append(weaponChoice);
        weaponChoice.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current weapon strength, just for you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            weaponChoice.classes.add("invertedItem");

        });
    }

    void displayMagicBargainOpt(Element container) {
        magicChoice = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "✨ Magic Pact >";
        container.append(magicChoice);
        magicChoice.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current magic strength, just for you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            magicChoice.classes.add("invertedItem");
        });
    }

    void displayCompanionBargainOpt(Element container) {
        companionChoice = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "🐥 Pact >";
        container.append(companionChoice);
        companionChoice.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for current 🐥 strength, which benefits all magical girls,even those who come after you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            companionChoice.classes.add("invertedItem");

        });
    }

    void displayLegacyBargainOpt(Element container) {
        legacyChoice = new DivElement()..classes.add("bloodItem")..classes.add("menuItem")..text = "🥚 Legacy Pact >";
        container.append(legacyChoice);
        legacyChoice.onClick.listen((Event e) {
            SoundHandler.clickSound();
            thirdMenu.style.display = 'block';
            thirdMenuInsides.text =("Trade future health for the ability to better help all magical girls, even those who come after you. Beware offering up more health than future you can spare.");
            unmarkChildren(container);
            legacyChoice.classes.add("invertedItem");

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
         unmarkChildren(secondMenu);
         unmarkChildren(firstMenu);
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
             SoundHandler.moneySound();
             commonClickShit(false);
             performBloodRite();
         });
     }

     void performBloodRite() {
         //you're selected if you have invertedItem class.
         if(legacyChoice.classes.toList().contains("invertedItem")){
             performLegacyRite();
         }else if(companionChoice.classes.toList().contains("invertedItem")) {
             performCompanionRite();
         }else if(magicChoice.classes.toList().contains("invertedItem")) {
             performMagicRite();
         }else if(weaponChoice.classes.toList().contains("invertedItem")) {
             performWeaponRite();
         }else if(healthChoice.classes.toList().contains("invertedItem")) {
             performHealthRite();
         }

         unmarkChildren(secondMenu);
         BloodPriceGame.instance.healthBar.updateBill(BloodPriceGame.instance.currentGirl.unpaidPacts);

     }


     void performHealthRite() {
         BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
         HealthBloodPact lp = new HealthBloodPact();
         girl.healthPacts.add(lp);
         BloodPriceGame.instance.damageGirl(lp.healthToRestore, BloodPriceGame.MAGICDAMAGE);
         BloodPriceGame.instance.healthBar.popup(lp.flavorText,0);
     }

     void performMagicRite() {
         BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
         MagicBloodPact lp = new MagicBloodPact();
         girl.magicPacts.add(lp);
         BloodPriceGame.instance.healthBar.popup(lp.flavorText,0);
     }

     void performWeaponRite() {
         BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
         WeaponBloodPact lp = new WeaponBloodPact();
         girl.weaponPacts.add(lp);
         BloodPriceGame.instance.healthBar.popup(lp.flavorText,0);
     }

     void performLegacyRite() {
         BloodPriceGirl girl = BloodPriceGame.instance.currentGirl;
         LegacyBloodPact lp = new LegacyBloodPact(girl.name);
         Amulet.bloodPacts.add(lp);
         BloodPriceGame.instance.healthBar.popup(lp.flavorText,0);
     }

     void performCompanionRite() {
         CompanionBloodPact cp = new CompanionBloodPact();
         Companion.bloodPacts.add(cp);
         BloodPriceGame.instance.spreadCorruption(BloodPriceGame.instance.birb);
         if(Companion.bloodPacts.length >= Companion.neededPower) {
             BloodPriceGame.instance.badEnding();
         }
         BloodPriceGame.instance.healthBar.popup(cp.flavorText,0);
     }



 }