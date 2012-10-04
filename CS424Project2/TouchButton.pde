import processing.core.*;

public class TouchButton {
  String content = "";
  float Width = 0;
  float Height = 0;
  float xPosition = 0;
  float yPosition = 0;
  boolean isVisible = true;
  private PApplet parent = null;
  public TouchButton(PApplet parent,String content, float width, float height, float xPos, float yPos){
    this.parent = parent;
    this.content = content;
    Width = width;
    Height = height;
    xPosition = xPos;
    yPosition = yPos;
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
      parent.fill(150);
      parent.rectMode(parent.CORNERS);
      parent.rect(xPosition, yPosition, xPosition+Width, yPosition+Height);
      parent.fill(0);
      parent.textAlign(parent.CENTER);
      parent.text(content, xPosition+(Width/2), (float) (yPosition+(Height/2)+2));
      parent.textAlign(parent.LEFT);
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
}

