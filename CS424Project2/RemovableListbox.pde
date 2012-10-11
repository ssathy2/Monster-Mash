/*
  - Class that contains an array list of string that can be added or removed depending on the actions of another controller
  - Items can be added by adding to the arraylist and items can be removed from the list by clicking the 'X' button next to item
*/

import processing.core.*;
import controlP5.*;

class RemovableListbox {
  HashMap<String, TouchButton> buttonsMap;
  int xPos;
  int yPos;
  int itemHeight;
  int itemWidth;
  int boxHeight;
  int boxWidth;
  PApplet parent;
  
  public RemovableListbox (PApplet p, int x, int y, int h, int w) {
   this.parent = p;
   xPos = x;
   yPos = y;
   boxHeight = h;
   boxWidth = w;
   itemWidth = boxWidth;
   itemHeight = boxHeight;  

   buttonsMap = new HashMap<String, TouchButton>();
  }
  
  public void addItemToRemovableListBox(String item) {
    if(buttonsMap.size() > 0) {
      itemHeight = boxHeight / buttonsMap.size(); 
    }

    if(!item.isEmpty () && !buttonsMap.containsKey(item)) {
      TouchButton newButton = new TouchButton(parent, item, itemWidth, itemHeight, xPos, yPos + (buttonsMap.size() * itemHeight), font);
      newButton.setBackgroundColor(color(#DFDFDF));
      newButton.setTextColor(color(#2C2228));
      buttonsMap.put(item, newButton);
    }
  }
  
  public void removeItemFromRemovableListBox(String item) {
    if(buttonsMap.containsKey(item)) {
      buttonsMap.remove(item);
    }
  }
  
  private void checkButtonsClicked(int x, int y) {
    Object[] vals = buttonsMap.values().toArray();
    TouchButton button;
    for(int i = 0; i < vals.length; i++) {
      button = (TouchButton)vals[i];
      if(button.Clicked((float)x, (float)y)) {
        buttonsMap.remove(button.content);    
      }
    }    
  }

  public void draw() {
    // check and see if any of the items in the box were clicked...if so then
    // remove them
    
    if(buttonsMap.size() > 0) {
      itemHeight = boxHeight / buttonsMap.size(); 
      Object[] vals = buttonsMap.values().toArray();
      TouchButton button;
      for(int i = 0; i < vals.length; i++) {
        button = (TouchButton)vals[i];
        button.Height = itemHeight;
        button.yPosition = yPos + (i * itemHeight);
        button.draw();  
      }
    }  
  }
}
