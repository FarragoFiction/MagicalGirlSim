import 'dart:html';

abstract class Screen {
    Element parentContainer;
    //one stop shop for removing this shit.
    Element container;
    //useful for 'back' buttons
    Screen parent;

    void showNewScreen(Screen child) {
        teardown();
        child.parent = this;
        child.setup(parentContainer);
    }
    void teardown() {
        container.remove();
    }


    void setup(Element element) {
        parentContainer = element;
        container = new DivElement();
        parentContainer.append(container);
    }
}