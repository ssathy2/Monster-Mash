import processing.net.*;
import controlP5.*;

// dummy var to force range sliders to use integers
int yearsRange;

// Primary controlP5 object
ControlP5 cp5;

PFont font;

// App UI elements
CheckBox genreCheckbox;
CheckBox keywordCheckbox;
SearchableListbox countriesBox;
SearchableListbox moviesBox;
Timeline timeLine;

// String arr of Items --> Testing for now
String test[] = {"United States", "France", "United Kingdom", "Japan"};

// Touchbuttons
TouchButton helpButton;
TouchButton creditsButton;

//ui element position vars
int genreCheckboxX, genreCheckboxY;
int genreCheckboxHeight, genreCheckboxWidth;
int keywordCheckboxX, keywordCheckboxY;
int keywordCheckboxHeight, keywordCheckboxWidth;
int countriesBoxX, countriesBoxY;
int countriesBoxWidth, countriesBoxHeight;
int moviesBoxX, moviesBoxY;
int moviesBoxWidth, moviesBoxHeight;

int listBoxItemHeight, listBoxItemWidth;

int helpButtonX, helpButtonY;
int helpButtonWidth, helpButtonHeight;
int creditsButtonX, creditsButtonY;
int creditsButtonHeight, creditsButtonWidth;

int timelineX, timelineY;
int timelineWidth, timelineHeight;

int scaleFactor;
boolean displayOnWall = false;

int textColor = color(#DFDFDF);

void setup(){
  if(displayOnWall) {
    size(8160, 2304, P3D);
    scaleFactor = 5;
  } else { 
    // change these to match your screen size
    size(1280,800);
    scaleFactor = 2;
  }
  
  font = createFont("SansSerif", 7 * scaleFactor);

  // init cp5 object
  cp5 = new ControlP5(this);
  cp5.setFont(font);
  
  // initialize the x,y, sizes of the ui elements
  genreCheckboxX = width - (scaleFactor * 250);
  genreCheckboxY = scaleFactor * 20;
  genreCheckboxHeight = 50;
  genreCheckboxWidth = 50;
  keywordCheckboxX = genreCheckboxX;
  keywordCheckboxY = genreCheckboxY + genreCheckboxHeight + (20 * scaleFactor);
  keywordCheckboxHeight = 50;
  keywordCheckboxWidth = 50;
  
  listBoxItemHeight = 20 * scaleFactor;
  listBoxItemWidth = 100 * scaleFactor;
  
  countriesBoxX = width - (listBoxItemWidth) - 15 * scaleFactor;
  countriesBoxY = height - (230 * scaleFactor);
  countriesBoxWidth = listBoxItemWidth;
  countriesBoxHeight = 220 * scaleFactor;
  
  helpButtonX = (width / 2) + 20 * scaleFactor;
  helpButtonY = height - (15 * scaleFactor);
  helpButtonWidth = 25 * scaleFactor; 
  helpButtonHeight = 15 * scaleFactor;
  creditsButtonX = helpButtonX + helpButtonWidth + (10 * scaleFactor);
  creditsButtonY = helpButtonY;
  creditsButtonHeight = helpButtonHeight;
  creditsButtonWidth = 30 * scaleFactor;

  timelineX = 10 * scaleFactor;
  timelineY = 5;
  timelineWidth = width / 2; 
  timelineHeight = height - (helpButtonHeight) - (10 * scaleFactor);

  // init all of the ui elements
  initGenreCheckbox();
  initKeywordCheckbox();
  initCountriesBox();
  //initMoviesBox();
  initTimeLine();
  initHelpButton(font);
  initCreditsButton(font);
  
}

boolean sketchFullScreen() {
  if(displayOnWall) {
    return false;
  }
  else {
    return true;  
  }
}

void draw() {
  // set BG color
  // background(#333333);    
  background(#232323);
  
  // draw timeline
  timeLine.draw();
  
  // draw the help and credits buttons
  helpButton.draw();
  creditsButton.draw(); 
  
  // draw genre, countries, and monsters string labels
  textFont(font);
  textSize(8 * scaleFactor);
  fill(#DFDFDF);
  text("Genres", (genreCheckboxX + (genreCheckboxWidth/2)), genreCheckboxY - (5*scaleFactor));
  text("Monsters", (keywordCheckboxX + (keywordCheckboxWidth/2)), keywordCheckboxY - (5*scaleFactor));
  text("Countries of Origin", (countriesBoxX + (countriesBoxWidth / 2)), countriesBoxY - (5 * scaleFactor));
}

void initGenreCheckbox() {
  genreCheckbox = cp5.addCheckBox("genreCheckbox")
                     .setPosition(genreCheckboxX, genreCheckboxY)
                     .setSize(genreCheckboxWidth, genreCheckboxHeight)
                     .addItem("Horror", 0)
                     .addItem("Comedy", 1)
                     .addItem("Musical", 2)
                     .addItem("Drama", 3)
                     .setSpacingColumn(scaleFactor * 40)
                     .setItemsPerRow(4)
                     .toUpperCase(false)
                     ;
}

void initKeywordCheckbox() {
  keywordCheckbox = cp5.addCheckBox("keywordCheckbox")
                       .setPosition(keywordCheckboxX, keywordCheckboxY)
                       .setSize(keywordCheckboxWidth, keywordCheckboxHeight)
                       .addItem("Aliens", 0)
                       .addItem("Vampires", 1)
                       .addItem("Demons", 2)
                       .addItem("More Monsters Here", 3)
                       .setSpacingColumn(scaleFactor * 40)
                       .setSpacingRow(scaleFactor * 10)
                       .setItemsPerRow(2)
                       .toUpperCase(false)
                       ;
}

void initCountriesBox(){
   countriesBox = new SearchableListbox(cp5, countriesBoxX, countriesBoxY, countriesBoxHeight, countriesBoxWidth, listBoxItemHeight, listBoxItemWidth, test);
}

// Very very very dangerous way of doing this
void keyReleased() {
  // should prob look for a different way of doing this...
  if(countriesBox.isInFocus()) {
    countriesBox.keyReleased();  
  }
}

void initTimeLine() {
  timeLine = new Timeline(this, cp5, timelineX, timelineY, timelineWidth, timelineHeight);
}

void initMoviesBox() {
  
}

void initHelpButton(PFont font) {
  helpButton = new TouchButton(this, "Help",(float)helpButtonWidth, (float)helpButtonHeight, (float)helpButtonX, (float)helpButtonY, font); 
  helpButton.setBackgroundColor(color(#DFDFDF));
  helpButton.setTextColor(color(#2C2228));
}

void initCreditsButton(PFont font) {
  creditsButton = new TouchButton(this, "Credits",(float)creditsButtonWidth, (float)creditsButtonHeight, (float)creditsButtonX, (float)creditsButtonY, font); 
  creditsButton.setBackgroundColor(color(#DFDFDF));
  creditsButton.setTextColor(color(#2C2228));

}
