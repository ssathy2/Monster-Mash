import processing.core.*;
import java.util.ArrayList; 

public class Keyboard {
  private PApplet parent = null;
  public ArrayList keys;
  String[] letters = {
    "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "Z", "X", "C", "V", "B", "N", "M"};
  String input = ""; //user input
  float xPos, yPos; //top left point of keyboard
  float width, height; //size of each key
  PFont font;
  int forColor;
  int backColor;
  int textColor;
  boolean isVisible = true;

  public Keyboard(PApplet parent, float width, float height, float xPos, float yPos, PFont paramFont, int forColor, int backColor, int textColor) {
    this.parent = parent;
    this.xPos = xPos;
    this.yPos = yPos;
    this.width = width;
    this.height = height;
    font = paramFont;
    this.forColor = forColor;
    this.backColor = backColor;
    this.textColor = textColor;
    keys = new ArrayList<TouchButton>();

    //Add keys to keyboard
    float x = xPos;
    float y = yPos;

    for (int i = 0; i < 26; i++) {
      String letter = letters[i];
      TouchButton b = new TouchButton(parent, letter, width, height, x, y, font);
      b.setVisible();
      b.setForegroundColor(forColor);
      b.setBackgroundColor(backColor);
      b.setTextColor(textColor);
      keys.add(b);
      if (i < 9) { 
        x = x + width + 10*scaleFactor; 
      }
      else if ( i == 9 ) { 
        x = xPos; 
        y = y + height + 10*scaleFactor;
      }
      else if (i < 18) {  
        x = x + width + 10*scaleFactor;
      } 
      else if (i == 18) { 
        x = xPos;  
        y = y + height + 10*scaleFactor;
      }
      else if (i < 27) { 
        x = x + width + 10*scaleFactor;
      }
    }
    TouchButton space = new TouchButton(parent, "SPACE", width*2, height, x, y, font);
    space.setVisible();
    space.setForegroundColor(forColor);
    space.setBackgroundColor(backColor);
    space.setTextColor(textColor);
    keys.add(space);

    x = x + (width*2) + 10*scaleFactor; 
    TouchButton del = new TouchButton(parent, "DEL", width*1.5, height, x, y, font);
    del.setVisible();
    del.setForegroundColor(forColor);
    del.setBackgroundColor(backColor);
    del.setTextColor(textColor);
    keys.add(del);
  } 

  public void draw() {
    if (isVisible) {
      for (int i = 0; i < keys.size(); i++) { //draw each key
        ((TouchButton)keys.get(i)).draw();
      }
    }
  }

  public boolean Clicked(float xPos, float yPos) {
    if (!isVisible) { 
      return false;
    }
    for (int i = 0; i < keys.size(); i++) { //check each key if it had been clicked
      TouchButton tmp = (TouchButton)keys.get(i);
      if (tmp.Clicked(xPos, yPos)) {
        String content = tmp.getContent();  //get key's content to add to input string
        if (content.equals("SPACE")) {
          input = input + " ";
        }
        else if (content.equals("DEL")) {
          if (input.length() >= 1) { //check length to avoid exception
            input = input.substring(0, input.length() - 1);
          }
        }
        else {
          input = input + content;
        }
        return true;
      }
    }
    return false;
  }
  
  public String getInput() {
    return input;
  }
  public void setVisible() {
    isVisible = true;
  }
  public void setCollapsed() {
    isVisible = false;
  }
}

