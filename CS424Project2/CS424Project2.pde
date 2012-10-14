import processing.net.*;
import controlP5.*;

// Primary controlP5 object
ControlP5 cp5;
PFont font;

// Database connector obj
DatabaseAdapter moviesDB;

// App UI elements
CheckBox genreCheckbox;
CheckBox keywordCheckbox;
SearchableListbox countriesBox;
SearchableListbox moviesBox;
RemovableListbox removableCountriesBox;
MovieInformationBox movieInformationBox;
Timeline timeLine;

// Arraylists that contain currently selected countries, genres, and monsters
ArrayList<String> selectedCountries;
ArrayList<String> selectedGenres;
ArrayList<String> selectedKeywords;

// Data
HashMap<Integer, Integer> comedyCount;
HashMap<Integer, Integer> horrorCount;
HashMap<Integer, Integer> musicalCount;
HashMap<Integer, Integer> dramaCount;

// String arr of Items --> Testing for now
String test[] = {"United States", "France", "United Kingdom", "Japan", "Germany", "Italy", "Russia", "China", "Canada", "Spain", "India"};

// Sample line colors for now... 
int[] lineColors; 

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

int movieInformationBoxX, movieInformationBoxY;
int movieInformationBoxWidth, movieInformationBoxHeight;

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
boolean displayMBP = true;

int textColor = color(#DFDFDF);
int backgroundColor;

void setup(){
  backgroundColor = color(#232323);
  
  // set size and scalefactor
  if(displayOnWall) {
    if(!displayMBP) {
      size(8160, 2304, P3D);
      scaleFactor = 5;
    }
    else {
      size(8160, 2304);
      scaleFactor = 5;   
    }
  } else { 
    // change these to match your screen size
    size(2479,700);
    scaleFactor = 2;
  }
  
  lineColors = new int[6];
  // set some colors up yo
  lineColors[0] = color(#00FFFE);
  lineColors[1] = color(#D10010);
  lineColors[2] = color(#5B8749);
  lineColors[3] = color(#FFFD56);
  lineColors[4] = color(#FF9735);
  lineColors[5] = color(#237BDD);
  
  font = createFont("SansSerif", 7 * scaleFactor);

  // init cp5 object
  cp5 = new ControlP5(this);
  cp5.setFont(font);
  
  // initialize the x,y, sizes of the ui elements
  genreCheckboxX = width - (scaleFactor * 250);
  genreCheckboxY = scaleFactor * 40;
  genreCheckboxHeight = scaleFactor * 20;
  genreCheckboxWidth = scaleFactor * 20;
  keywordCheckboxX = genreCheckboxX;
  keywordCheckboxY = genreCheckboxY + genreCheckboxHeight + (20 * scaleFactor);
  keywordCheckboxHeight = scaleFactor * 20;
  keywordCheckboxWidth = scaleFactor * 20;
  
  listBoxItemHeight = 18 * scaleFactor;
  listBoxItemWidth = 100 * scaleFactor;
  
  countriesBoxX = width - (listBoxItemWidth) - 15 * scaleFactor;
  countriesBoxY = height - (200 * scaleFactor);
  countriesBoxWidth = listBoxItemWidth;
  countriesBoxHeight = 200 * scaleFactor;
  
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

  movieInformationBoxX = timelineX + timelineWidth + (100 * scaleFactor);
  movieInformationBoxY = 5 * scaleFactor;
  movieInformationBoxWidth = 100;
  movieInformationBoxHeight = 200;

  selectedCountries = new ArrayList<String>();
  selectedGenres = new ArrayList<String>();
  selectedKeywords = new ArrayList<String>();
  
  // The password will probably be different on the wall DB
  moviesDB = new DatabaseAdapter(this, "root", "lexmark9", "p2");
  
  // init all of the ui elements
  initGenreCheckbox();
  initKeywordCheckbox();
  initCountriesBox();
  initRemovableCountriesBox();
  //initMoviesBox();
  initTimeLine();
  initHelpButton(font);
  initCreditsButton(font);
  initMovieInformationBox(); 
    
  // note that it might take some time to load in data
  // loadData();
}

public void loadData() {
  println("Loading comedy movies per year...");
  HashMap<Integer, Integer> comedyCount = moviesDB.getNumberMoviesPerYear("Comedy", 1890, 2012); 
  println("Comedy movies per year loaded.");  
  println("Loading horror movies per year...");
  HashMap<Integer, Integer> horrorCount = moviesDB.getNumberMoviesPerYear("Horror", 1890, 2012); 
  println("Horror movies per year loaded.");  
  println("Loading muscial movies per year...");
  HashMap<Integer, Integer> musicalCount = moviesDB.getNumberMoviesPerYear("Musical", 1890, 2012); 
  println("Musical movies per year loaded.");  
  println("Loading drama movies per year...");
  HashMap<Integer, Integer> dramaCount = moviesDB.getNumberMoviesPerYear("Drama", 1890, 2012); 
  println("drama movies per year loaded.");  
} 

boolean sketchFullScreen() {
  //if(displayOnWall) {
    return false;
  //}
  /*else {
    return true;  
  }*/
}

void draw() {
  // set BG color
  // background(#333333);    
  background(backgroundColor);
  
  // draw timeline
  timeLine.draw();
  
  // draw the help and credits buttons
  helpButton.draw();
  creditsButton.draw(); 
  
  movieInformationBox.draw();
  
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
                     .addItem("Comedy", 0)
                     .addItem("Drama", 1)
                     .addItem("Horror", 2)
                     .addItem("Musical", 3)
                     .setSpacingColumn(scaleFactor * 40)
                     .setItemsPerRow(4)
                     .toUpperCase(false)
                     ;
  //selectedGenres.add("Comedy");
  //selectedGenres.add("Drama");
  selectedGenres.add("Horror");
  //selectedGenres.add("Musical");
  genreCheckbox.activateAll();
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
  timeLine = new Timeline(this, cp5, timelineX, timelineY, timelineWidth, timelineHeight, "slider1");
}

void initMoviesBox() {
  
}

void initRemovableCountriesBox() {
    removableCountriesBox = new RemovableListbox(cp5, removableCountriesBoxX, removableCountriesBoxY, removableCountriesBoxHeight, removableCountriesBoxWidth, listBoxItemHeight);
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

void initMovieInformationBox() {
  movieInformationBox = new MovieInformationBox(this, cp5, movieInformationBoxX, movieInformationBoxY, movieInformationBoxHeight, movieInformationBoxWidth);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("genreCheckbox")) {
    selectedGenres.clear();
    for (int i=0;i<genreCheckbox.getArrayValue().length;i++) { 
      int n = (int)genreCheckbox.getArrayValue()[i];
      if(n == 1) {
        selectedGenres.add(genreCheckbox.getItem(i).getLabel()); 
      }
    }
  }
  else if(theEvent.isFrom("keywordCheckbox")) {
    selectedKeywords.clear();
    for (int i=0;i<keywordCheckbox.getArrayValue().length;i++) { 
      int n = (int)keywordCheckbox.getArrayValue()[i];
      if(n == 1) {
        selectedKeywords.add(keywordCheckbox.getItem(i).getLabel()); 
      }
    }
  } 
}
