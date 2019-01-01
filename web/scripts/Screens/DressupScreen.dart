import '../MagicalGirlCharacterObject.dart';
import '../PrettyDressupPart.dart';
import 'GameScreen.dart';
import 'dart:async';
import 'dart:html';

import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:DollLibCorrect/src/Dolls/MagicalDoll.dart';

class DressupScreen extends GameScreen {
    MagicalGirlCharacterObject girl;
    MagicalDoll doll;
    List<DressupTab> tabs = new List<DressupTab>();
    CanvasElement canvas;
    DressupTab selectedTab;

    DressupScreen(MagicalGirlCharacterObject this.girl) {
        doll = girl.doll as MagicalDoll;
        initTabs();
    }

    void initTabs() {
        tabs.add(new DressupTab(this,girl, doll.skirt));
        tabs.add(new DressupTab(this,girl, doll.bowBack));
        tabs.add(new DressupTab(this,girl, doll.frontBow));
        tabs.add(new DressupTab(this,girl, doll.socks));
        tabs.add(new DressupTab(this,girl, doll.shoes));
        tabs.add(new DressupTab(this,girl, doll.glasses));

    }



    @override
    Future<Null> setup(Element parent) async {
        super.setup(parent);
        DivElement girlContainer = new DivElement()..classes.add("girlContainer");
        container.append(girlContainer);
        await makeDressup(girlContainer);
    }


    Future<Null> makeDressup(Element subcontainer) async {
        //full size
        canvas = girl.doll.blankCanvas;
        syncDressup();
        subcontainer.append(canvas);
        DivElement tabElement = new DivElement()..classes.add("tabs");
        subcontainer.append(tabElement);
        drawTabs(tabElement);
    }

    Future<Null> syncDressup() async {
        canvas.context2D.clearRect(0,0,canvas.width,canvas.height);
        CanvasElement tmpCanvas = await girl.doll.getNewCanvas();
        await girl.makeViewerBorder(canvas);
        canvas.context2D.drawImage(tmpCanvas,0,0);

    }


    Future<Null> drawTabs(Element subcontainer) async {
        tabs.forEach((DressupTab tab) {
            tab.showButton(subcontainer);
        });
        selectTab(tabs.first,subcontainer);

    }

    void selectTab(DressupTab tab, Element subContainer) {
        if(selectedTab != null) selectedTab.hideContents();
        selectedTab = tab;
        tab.showContents(subContainer);
    }

}

class DressupTab {
    List<PrettyDressupPart> parts = new List<PrettyDressupPart>();
    SpriteLayer layerToCollate;
    MagicalGirlCharacterObject girl;
    Element container;
    ButtonElement tabButton;
    DressupScreen owner;


    DressupTab(DressupScreen this.owner, MagicalGirlCharacterObject this.girl, SpriteLayer this.layerToCollate) {
        init();
    }
    void init() {
        for(int i = 0; i<layerToCollate.maxImageNumber; i++) {
            parts.add(new PrettyDressupPart(layerToCollate, i,girl));
        }
    }

    void showButton(Element subcontainer) {
         tabButton = new ButtonElement()..text = layerToCollate.name;
         tabButton.classes.add("tabButton");
         subcontainer.append(tabButton);
         tabButton.onClick.listen((Event e) {
            owner.selectTab(this,subcontainer);
         });
    }

    void showContents(Element subcontainer) {
        if(container == null) {
            render(subcontainer);
        }else {
            container.style.display = "block";
        }
        tabButton.classes.add("tabButtonSelected");
    }

    void hideContents() {
        if(container != null) {
            container.style.display = "none";
            tabButton.classes.remove("tabButtonSelected");
        }
    }

    //TODO also display layer label
    Future<Null> render(Element subcontainer) async {
        container = new DivElement()..classes.add("tab");
        subcontainer.append(container);
        for(PrettyDressupPart part in parts) {
            await part.render(container);
        }
    }
}