import processing.core.*;

public class TouchButton {
  String content = "";
  float Width = 0;
  float Height = 0;
  float xPosition = 0;
  float yPosition = 0;
  boolean isVisible = true;
  private PApplet parent = null;
  int foregroundColor = 100;
  int backgroundColor = 100;
  int textColor = 0;
  PFont font;
  
  public void setForegroundColor(final int colorParam) {
    foregroundColor = colorParam;
  }
  
  public void setBackgroundColor(final int colorParam) {
    backgroundColor = colorParam;
  }
  
  public void setTextColor(final int colorParam) {
    textColor = colorParam;  
  }
  
  public TouchButton(PApplet parent,String content, float width, float height, float xPos, float yPos, PFont paramFont){
    this.parent = parent;
    this.content = content;
    Width = width;
    Height = height;
    xPosition = xPos;
    yPosition = yPos;
    font = paramFont;
  }
  public boolean isVisible(){
    return isVisible;
  }
  public void setVisible(){
    isVisible = true;
  }
  public void setCollapsed(){
    isVisible = false;
  }
  
  public void draw(){
    if(isVisible){
      parent.fill(backgroundColor);
      parent.rectMode(parent.CORNERS);
      noStroke();
      parent.rect(xPosition, yPosition, xPosition+Width, yPosition+Height);
      parent.textFont(font);
      parent.fill(textColor);
      parent.textAlign(parent.CENTER, parent.CENTER);
      parent.text(content, xPosition+(Width/2), (float) (yPosition+(Height/2)+2));
    }    
  }
  
  public boolean Clicked(float xPos, float yPos){
    return xPos >= xPosition && xPos <= (xPosition+Width) &&
        yPos >= yPosition && yPos <= (yPosition+Height) && isVisible;
  }
  
  public float getWidth(){
    return Width;
  }
  public float getHeight(){
    return Height;
  }
  
  public String getContent(){
    return content;
  }
}

