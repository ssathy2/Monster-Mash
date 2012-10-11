import processing.net.*;
import controlP5.*;

// Primary controlP5 object
ControlP5 cp5;

PFont font;

// App UI elements
CheckBox genreCheckbox;
CheckBox keywordCheckbox;
SearchableListbox countriesBox;
SearchableListbox moviesBox;
RemovableListbox removableCountriesBox;
Timeline timeLine;

// String arr of Items --> Testing for now
String test[] = {"United States", "France", "United Kingdom", "Japan", "Germany", "Italy", "Russia", "China", "Canada", "Spain", "India"};

// Arraylists containing the genres and keywords...this'll be updated with the current genres and current monsters that are selected
String genres[] = {"Horror", "Comedy", "Musical", "Drama"};

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

int removableCountriesBoxX, removableCountriesBoxY;
int removableCountriesBoxHeight, removableCountriesBoxWidth;

int listBoxItemHeight, listBoxItemWidth;

int helpButtonX, helpButtonY;
int helpButtonWidth, helpButtonHeight;
int creditsButtonX, creditsButtonY;
int creditsButtonHeight, creditsButtonWidth;

int timelineX, timelineY;
int timelineWidth, timelineHeight;

int scaleFactor;

/*
  Options:
  - decide whether we're displaying on the wall
  - decide whether we're running on a mbp (can't do P3D and 8160 by 2304 for some reason)
*/
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
  genreCheckboxY = scaleFactor * 40;
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
  
  removableCountriesBoxX = countriesBoxX - countriesBoxWidth - (10 * scaleFactor);
  removableCountriesBoxY = countriesBoxY;
  removableCountriesBoxHeight = countriesBoxHeight;
  removableCountriesBoxWidth = countriesBoxWidth;

  helpButtonX = (width / 2) + 20 * scaleFactor;
  helpButtonY = height - (15 * scaleFactor);
  helpButtonWidth = 25 * scaleFactor; 
  helpButtonHeight = 15 * scaleFactor;
  creditsButtonX = helpButtonX + helpButtonWidth + (10 * scaleFactor);
  creditsButtonY = helpButtonY;
  creditsButtonHeight = helpButtonHeight;
  creditsButtonWidth = 30 * scaleFactor;

  timelineX = 20 * scaleFactor;
  timelineY = 5;
  timelineWidth = width / 2; 
  timelineHeight = height - (helpButtonHeight) - (10 * scaleFactor);

  // init all of the ui elements
  initGenreCheckbox();
  initKeywordCheckbox();
  initCountriesBox();
  initRemovableCountriesBox();
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
  
  // draw removable countries box
  // grab the last selected country from the countries box and add it to the countries display
  removableCountriesBox.addItemToRemovableListBox(countriesBox.getLastSelectedItem());
  removableCountriesBox.draw();
  
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
                     .activateAll()
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
                       .activateAll()
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
  timeLine = new Timeline(this, cp5, timelineX, timelineY, timelineWidth, timelineHeight, "slider1");
}

void initMoviesBox() {
  
}

void initRemovableCountriesBox() {
    removableCountriesBox = new RemovableListbox(this, removableCountriesBoxX, removableCountriesBoxY, removableCountriesBoxHeight, removableCountriesBoxWidth);
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
