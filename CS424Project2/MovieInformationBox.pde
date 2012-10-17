/*
  Authors: Siddharth Sathyam(ssathy2@gmail.com), Anna Mukhina, Kush Shah
  - Element to display movie information after user types in a movie and chooses a movie 
  - TODO: Find a nice image that can be used as the image for this button...a 'X' would be great
*/

class MovieInformationBox { 
  // position, dimension related  
  int boxXPos, boxYPos;
  int boxHeight, boxWidth;

  // strings for year, movie, cert, budget, and monsters
  String yearText;
  String movieText;
  String certificationText;
  String budgetText;
  String monstersText;
  
  boolean showBox;
  
  PApplet parentApplet;
  
  public MovieInformationBox(PApplet p, ControlP5 p5, int x, int y, int h, int w) {
    parentApplet = p;
    showBox = true;
    boxXPos = x;
    boxYPos = y;
    boxHeight = h;
    boxWidth = w;
  }
  
  public void draw() {
    if(showBox) {
      // Draw a border...seems hacky -> need to do research on drawing a border a different way
      parentApplet.rectMode(CORNERS);
      parentApplet.stroke(#00FFFE);
      parentApplet.fill(#232323);
      parentApplet.rect(boxXPos, boxYPos, boxXPos + boxWidth, boxYPos + boxHeight, 7);
   
      drawMovieText();
      drawYearText();
      drawMonstersText();
    }
  }
  
  public void drawMovieText() {
    fill(#DFDFDF);
    parentApplet.textFont(font);
    parentApplet.textAlign(CENTER);
    parentApplet.text(movieText, (boxXPos + (80 * scaleFactor)), boxYPos + (20 * scaleFactor));
  }
  
  public void drawYearText() {
    parentApplet.textFont(font);
    parentApplet.textAlign(CENTER);
    parentApplet.text(yearText, (boxXPos + (80 * scaleFactor)), boxYPos + (55 * scaleFactor));
  }
  
  public void drawCertificationText() {
    
  }
  
  public void drawBudgetText() {
    
  }
  
  public void drawMonstersText() {
    parentApplet.textFont(font);
    parentApplet.textAlign(CENTER);
    parentApplet.text(monstersText, (boxXPos + (80 * scaleFactor)), boxYPos + (90 * scaleFactor));
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
         if(monsters.size() % 3 == 0) {
           
         }
         else {
                m += monsters.get(i) + ", ";
        
         }
      }
    }
    monstersText = m;
  }
}
