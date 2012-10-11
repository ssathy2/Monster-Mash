import processing.core.*;
import controlP5.*;

/** 
  class that allows us to create listboxes that have an attached searchbox with them
  auto complete and filtering options are also another feature of this
*/
class SearchableListbox {
  String currentTextInBox = "";
 
  private String currentSelectedItem = ""; 
  
  int listboxxPos, listboxyPos;
  int listboxHeight, listboxWidth;
  int listboxItemHeight, listboxItemWidth;
  
  int searchboxHeight, searchboxWidth;
  int searchboxxPos, searchboxyPos;
  
  ListBox itemsBox;
  Textfield inputBox;
  MyControlListener listener;
  
  String[] listboxItems;
  
  // init all of the class global vars
  public SearchableListbox(ControlP5 p5, int xPos, int yPos, int boxHeight, int boxWidth, int searchBoxHeight, int searchBoxWidth, String[] items) {
     searchboxxPos = xPos;
     searchboxyPos = yPos;
     searchboxHeight = searchBoxHeight;
     searchboxWidth = searchBoxWidth;
     listboxItems = items;
     listboxxPos = xPos;
     listboxyPos = yPos + searchBoxHeight;
     listboxHeight = boxHeight;
     listboxWidth = boxWidth;
     listboxItemHeight = searchBoxHeight;
     listboxItemWidth = searchBoxWidth;
     
     listener = new MyControlListener();
     
     // add the itemsbox and the input box
     itemsBox = p5.addListBox("itemsBox")
                  .setLabel("")
                  .disableCollapse()
                  .setPosition(listboxxPos, listboxyPos)
                  .setSize(listboxWidth, listboxHeight)
                  .setItemHeight(listboxItemHeight)
                  .toUpperCase(false)
                  .addListener(listener)
                  .addItems(listboxItems);
                  
     inputBox = p5.addTextfield("inputBox")
                  .setPosition(searchboxxPos, searchboxyPos)
                  .setSize(searchboxWidth, searchboxHeight)
                  .setLabel("")
                  ;   
  }
  
  public boolean isInFocus() {
    return inputBox.isFocus();
  }
  
  public void keyReleased() {
    currentTextInBox = inputBox.getText();
    itemsBox.clear();
    for(int i = 0; i < listboxItems.length; i++) {
       if(listboxItems[i].toLowerCase().startsWith((currentTextInBox.toLowerCase()))) {
         itemsBox.addItem(listboxItems[i], i); 
       }
    }
    itemsBox.update();
  }

  public String getLastSelectedItem() {
     return currentSelectedItem;
  }
  
  class MyControlListener implements ControlListener {
    int currentIndex;
    public void controlEvent(ControlEvent theEvent) {
      if(theEvent.isFrom("itemsBox")) {
         currentIndex = (int)theEvent.group().value();
         inputBox.setText(listboxItems[currentIndex]);
         currentSelectedItem = listboxItems[currentIndex];
      }
    }

  }  
}

