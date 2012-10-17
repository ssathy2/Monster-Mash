import processing.core.*;

public class Information {
  private PApplet parent = null;
  float xPos = 0;
  float yPos = 0;
  boolean isVisible = false;
  PFont font;
  String info = "";
  
  public Information(PApplet parent, float xPos, float yPos, PFont paramFont, String info) {
    this.parent = parent;
    this.font = paramFont;
    this.xPos = xPos;
    this.yPos = yPos;
    this.info = info;
  }
  
  void draw() {
    if(isVisible) {
        //fill(#FFFFFF);
        //noStroke();
        //rect(20*scaleFactor, 160*scaleFactor, 220*scaleFactor, 190*scaleFactor);
        fill(#FFFFFF);
        parent.textFont(font);
        //textSize(15*scaleFactor);
        //textAlign(LEFT);
        parent.text(info, xPos, yPos);
    }
  }
  
  void setVisible(){
    isVisible = true;
  }
  
  void setCollapsed() {
    isVisible = false;
  }
}
