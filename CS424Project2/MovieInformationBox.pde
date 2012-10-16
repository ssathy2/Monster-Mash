/*
  Authors: Siddharth Sathyam(ssathy2@gmail.com), Anna Mukhina, Kush Shah
  - Element to display movie information after user types in a movie and chooses a movie 
  - TODO: Find a nice image that can be used as the image for this button...a 'X' would be great
*/

class MovieInformationBox { 
  // position, dimension related  
  int boxXPos, boxYPos;
  int boxHeight, boxWidth;
  
  // closebutton position, dimension
  int closeButtonX, closeButtonY;
  int closeButtonHeight, closeButtonWidth;
  
  // strings for year, movie, cert, budget, and monsters
  String yearText;
  String movieText;
  String certificationText;
  String budgetText;
  String monstersText;
  
  boolean showBox;
  
  Bang closeButton;
  PApplet parentApplet;
  
  public MovieInformationBox(PApplet p, ControlP5 p5, int x, int y, int h, int w) {
    parentApplet = p;
    showBox = true;
    boxXPos = x;
    boxYPos = y;
    boxHeight = h;
    boxWidth = w;
    
    // position closeButton near the bottom left corner 
    closeButtonHeight = 10 * scaleFactor;
    closeButtonWidth = closeButtonWidth;
    closeButtonX = boxXPos + (2 * scaleFactor);
    closeButtonY = (boxYPos + boxHeight) - closeButtonHeight - (2 * scaleFactor);
    
    closeButton = p5.addBang("closeButton")
                    .setPosition(closeButtonX, closeButtonY)
                    .setSize(closeButtonWidth, closeButtonHeight)
                    .setTriggerEvent(Bang.RELEASE)
                    .setLabel("")
                    ;
  }
  
  public void draw() {
    if(showBox) {
      // Draw a border...seems hacky -> need to do research on drawing a border a different way
      parentApplet.rectMode(CORNERS);
      parentApplet.stroke(#00FFFE);
      parentApplet.rect(boxXPos, boxYPos, boxXPos + boxWidth, boxYPos + boxHeight, 7);
   
      drawMovieText();
      drawYearText();
      drawMonstersText();
    }
  }
  
  public void drawMovieText() {
    parentApplet.textFont(font);
    parentApplet.textSize(10 * scaleFactor);
    parentApplet.text(movieText, boxXPos/2, 5 * scaleFactor);
    println(movieText);
  }
  
  public void drawYearText() {
    
  }
  
  public void drawCertificationText() {
    
  }
  
  public void drawBudgetText() {
    
  }
  
  public void drawMonstersText() {
    
  }
  
  public void updateInformationBox(String name) {
    yearText = moviesDB.getYearAssociatedWithMovie(name);
    ArrayList<String> monsters = moviesDB.getMonstersAssociatedWithMovie(name);
    movieText = name;
    String m = "";
    for(int i = 0; i < monsters.size(); i++) {
      if(i == monsters.size() - 1) { 
         m += monsters.get(i); 
      }
      else {
         m += monsters.get(i) + ", ";
      }
    }
    monstersText = m;
  }
}
