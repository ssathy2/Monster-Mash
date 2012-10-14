/*
  - Class that contains an array list of string that can be added or removed depending on the actions of another controller
  - Items can be added by adding to the arraylist and items can be removed from the list by clicking the 'X' button next to item
*/
import processing.core.*;
import controlP5.*;

class RemovableListbox {
  ListBox removableBox;
  ControlP5 parentControlP5;
  RemovableListBoxListener listener;
  
  private HashMap<Integer, String> itemsMap = new HashMap<Integer, String>();
  private ArrayList<String> literalItems = new ArrayList<String>();
  
  int xPos;
  int yPos;
  int itemHeight;
  int itemWidth;
  int boxHeight;
  int boxWidth;

  int maxItems;
  int numCurrentItems;
  
  class RemovableListBoxListener implements ControlListener {
    public void controlEvent(ControlEvent theEvent) {
      if(theEvent.isFrom("removableBox")) {
        int currentIndex = (int)theEvent.group().value();
        println("Current place = " + itemsMap.get(currentIndex));
        removeItemFromRemovableListBox(itemsMap.get(currentIndex));
      }
    }
  }
  
  public RemovableListbox (ControlP5 p, int x, int y, int h, int w, int boxItemHeight) {
   this.parentControlP5 = p;
   xPos = x;
   yPos = y;
   boxHeight = h;
   boxWidth = w;
   itemWidth = boxWidth;
   itemHeight = boxItemHeight;  
   maxItems = 5;
   numCurrentItems = 0;
   
   literalItems = new ArrayList<String>();
   
   listener = new RemovableListBoxListener();
   
   removableBox = parentControlP5.addListBox("removableBox")
                  .setLabel("")
                  .disableCollapse()
                  .setPosition(xPos, yPos)
                  .setSize(w, h)
                  .setItemHeight(boxItemHeight)
                  .toUpperCase(false)
                  .addListener(listener)
                  .setBarHeight(0)
                  ;
  }
  
  public void addItemToRemovableListBox(String item) {
    if(!item.isEmpty () && !literalItems.contains(item) && literalItems.size() <= maxItems) {
      literalItems.add(item);
      itemsMap.put(numCurrentItems, item);
      ListBoxItem tmp = removableBox.addItem(item, numCurrentItems);
      tmp.setColorBackground(lineColors[numCurrentItems]);
      tmp.setColorForeground(lineColors[numCurrentItems]);
      tmp.setColorLabel(#232323);
      println("Item: " + item + " with index: " + numCurrentItems + " was added");
      numCurrentItems++;
    }
  }
  
  public void removeItemFromRemovableListBox(String item) {
    if(literalItems.contains(item)) {
      println("Removing Item with string val: " + item);
      numCurrentItems--;
      if(numCurrentItems == 0 ){
        removableBox.clear(); 
      }
      else {
        removableBox.removeItem(item);        
      }
      itemsMap.remove(literalItems.lastIndexOf(item));
      literalItems.remove(item);  
      removableBox.update();
      println(literalItems.size());
    }
  }
  
  public ArrayList<String> getCurrentCountriesSelected () {
   return literalItems; 
  }

}
