import processing.net.*;
import controlP5.*;
import java.util.*;
import hypermedia.net.*;
import omicronAPI.*;

//Touch setup
OmicronAPI omicronManager;
TouchListener touchListener;
PApplet applet;

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
Keyboard onScreenKeyboard;
PieChart pChart;
Information helpBox;
Information creditsBox;
Table dataTable;

// Arraylists that contain currently selected countries, genres, and monsters
ArrayList<String> selectedCountries;
ArrayList<String> selectedGenres;
ArrayList<String> selectedKeywords;
boolean isGenreKeywordChanged;

// String arr of all countries
String listOfAllCountries[];

//list of all movies
String listOfAllMovies[];

String currentMovieSelected;

// Sample line colors for now... 
int[] lineColors; 

// Touchbuttons
TouchButton helpButton;
TouchButton creditsButton;
TouchButton dataViewButton;

boolean showTable;

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
int dataViewButtonX, dataViewButtonY;
int dataViewButtonWidth, dataViewButtonHeight;

int timelineX, timelineY;
int timelineWidth, timelineHeight;

int onscreenKeyboardX, onscreenKeyboardY;
int onscreenKeyboardHeight, onscreenKeyboardWidth;

int pchartX, pchartY;
int pchartHeight, pchartWidth;

int helpBoxX, helpBoxY;
int helpBoxHeight, helpBoxWidth;

int creditsBoxX, creditsBoxY;
int creditsBoxHeight, creditsBoxWidth;

int dataTableX, dataTableY;
int dataTableHeight, dataTableWidth;

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

public void init() {
  super.init();
  omicronManager = new OmicronAPI(this);      
  if(displayOnWall) {
    if(!displayMBP) {
      omicronManager.setFullscreen(true);
    }
  }
}

void setup(){ 
  applet = this;
  touchListener = new TouchListener();
  omicronManager.setTouchListener(touchListener);
  if(displayOnWall) {    
    if(!displayMBP) { 
      omicronManager.ConnectToTracker(7001, 7340, "131.193.77.159");
    }
  }
  
  //set size and scalefactor
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

//      size(1240, 350);
//      scaleFactor = 1;
  }

  showTable = false;

  lineColors = new int[6];
  // set some colors up yo
  lineColors[0] = color(#00FFFE);
  lineColors[1] = color(#D10010);
  lineColors[2] = color(#5B8749);
  lineColors[3] = color(#FFFD56);
  lineColors[4] = color(#FF9735);
  lineColors[5] = color(#237BDD);
  
  font = createFont("SansSerif", 9 * scaleFactor);
  // init cp5 object
  cp5 = new ControlP5(this);
  //cp5.getPointer().enable();
  backgroundColor = color(#232323);
  cp5.setFont(font);
  
  // initialize the x,y, sizes of the ui elements
  listBoxItemHeight = 18 * scaleFactor;
  listBoxItemWidth = 100 * scaleFactor;

  helpButtonX = (40 * scaleFactor) + (width/2) + (30*scaleFactor);
  helpButtonY = height - (15 * scaleFactor);
  helpButtonWidth = 50 * scaleFactor; 
  helpButtonHeight = 15 * scaleFactor;
  creditsButtonX = helpButtonX + helpButtonWidth + (10 * scaleFactor);
  creditsButtonY = helpButtonY;
  creditsButtonHeight = helpButtonHeight;
  creditsButtonWidth = 50 * scaleFactor;
  dataViewButtonX = creditsButtonX + creditsButtonWidth + (10 * scaleFactor);
  dataViewButtonY = helpButtonY;
  dataViewButtonWidth = 100 * scaleFactor;
  dataViewButtonHeight = helpButtonHeight;
  
  timelineX = 20 * scaleFactor;
  timelineY = 5;
  timelineWidth = (width / 2) - (20 * scaleFactor); 
  timelineHeight = height - (helpButtonHeight) - (10 * scaleFactor);
 
  //dataTableX = timelineX;
  //dataTableY = timelineY;
  dataTableX = width/4 - 50;
  dataTableY = timelineY + 50*scaleFactor;
  dataTableHeight =  20 * scaleFactor;
  dataTableWidth = 100 * scaleFactor;

  removableCountriesBoxX = timelineX + timelineWidth + (10 * scaleFactor);
  removableCountriesBoxY = (height/3);
  removableCountriesBoxHeight = 200 * scaleFactor;
  removableCountriesBoxWidth = listBoxItemWidth;
 
  countriesBoxX = removableCountriesBoxX + removableCountriesBoxWidth + (20*scaleFactor);
  countriesBoxY = removableCountriesBoxY;
  countriesBoxWidth = listBoxItemWidth + (25 * scaleFactor);
  countriesBoxHeight = 200 * scaleFactor;
  
  genreCheckboxX = countriesBoxX + countriesBoxWidth + (40 * scaleFactor);
  genreCheckboxY = (height/3);
  genreCheckboxHeight = scaleFactor * 20;
  genreCheckboxWidth = scaleFactor * 20;
  keywordCheckboxX = genreCheckboxX;
  keywordCheckboxY = (height/2);
  keywordCheckboxHeight = scaleFactor * 20;
  keywordCheckboxWidth = scaleFactor * 20;
  
  onscreenKeyboardX = genreCheckboxX;
  onscreenKeyboardY = 3*height / 4;
  onscreenKeyboardHeight = scaleFactor * 10;
  onscreenKeyboardWidth = scaleFactor * 20;
 
  moviesBoxWidth = countriesBoxWidth + (40*scaleFactor);
  moviesBoxHeight = countriesBoxHeight;
  moviesBoxX = width - (moviesBoxWidth) - (10*scaleFactor);
  moviesBoxY = countriesBoxY;
  
  pchartX = timelineX + timelineWidth + (125 * scaleFactor);
  pchartY = 5 * scaleFactor;
  pchartWidth = countriesBoxWidth;
  pchartHeight = height/3 - (10 * scaleFactor); 
  
  movieInformationBoxX = genreCheckboxX;
  movieInformationBoxY = 20 * scaleFactor;
  movieInformationBoxWidth = moviesBoxWidth;
  movieInformationBoxHeight = pchartHeight - (40*scaleFactor);
  
  helpBoxHeight = movieInformationBoxHeight;
  helpBoxWidth = moviesBoxWidth;
  helpBoxX = width - helpBoxWidth;
  helpBoxY = movieInformationBoxY + (45 * scaleFactor);

  creditsBoxHeight = movieInformationBoxHeight;
  creditsBoxWidth = moviesBoxWidth;
  creditsBoxX = helpBoxX;
  creditsBoxY = movieInformationBoxY + (35 * scaleFactor);
  
  selectedGenres = new ArrayList<String>();
  selectedKeywords = new ArrayList<String>();
  isGenreKeywordChanged = true;
  
  // The password will probably be different on the wall DB
  //if(!displayOnWall) {
  //moviesDB = new DatabaseAdapter(this, "root", "lexmark9", "monster_mash", "localhost");
  //}
  //else {
  moviesDB = new DatabaseAdapter(this, "cs424", "cs424", "monster_mash", "omgtracker.evl.uic.edu");
  //}
   
  // init all of the ui elements
  initGenreCheckbox();
  initKeywordCheckbox();
  initRemovableCountriesBox();
  
  // load the data in
  loadData();
  
  // these should be init'ed after data has been loaded
  initHelpBox();
  initCreditsBox();
  //initPiechart();
  initDataTable();
  initCountriesBox();  
  initMoviesBox();
  initTimeLine();
  initHelpButton(font);
  initCreditsButton(font);
  initDataViewButton(font); 
  initMovieInformationBox(); 
  initOnScreenKeyboard();
}

public void loadData() {
  // Load in all of the movies
  println("Getting all movies...");
  ArrayList<String> movies = moviesDB.getMoviesWithGenres(Arrays.copyOf(selectedGenres.toArray(), selectedGenres.toArray().length, String[].class), 1890, 2012);
  println("All movies loaded...");
  listOfAllMovies = Arrays.copyOf(movies.toArray(), movies.toArray().length, String[].class);
  // load in all countries
  println("Getting all countries...");
  listOfAllCountries = moviesDB.getAllCountries();
  println("All countries loaded...");
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
  omicronManager.process(); //touch

  selectedCountries = removableCountriesBox.getCurrentItemsSelected();
  
  if(selectedCountries.size() > 0){
    //pChart.updateValues();
    //pChart.draw();
  }  

  helpBox.draw();
  creditsBox.draw();

  dataTable.shouldShowTable(showTable);
  timeLine.shouldShowPlot(!showTable);
  
  dataTable.draw();
  // draw timeline
  timeLine.draw();
  movieInformationBox.draw();

  // draw the help and credits buttons
  helpButton.draw();
  creditsButton.draw();
  dataViewButton.draw(); 
  onScreenKeyboard.draw();
  
  if(countriesBox.isInFocus() || moviesBox.isInFocus()) {
    if(countriesBox.isInFocus()) {

    }
    else if(countriesBox.isInFocus()) {
  
    }
    
    onScreenKeyboard.setVisible();  
  }
  else {
    onScreenKeyboard.setCollapsed(); 
    onScreenKeyboard.clear(); 
  }
     
  // draw genre, countries, and monsters string labels
  textFont(font);
  textSize(9 * scaleFactor);
  fill(#DFDFDF);
  text("Genres", (genreCheckboxX + (genreCheckboxWidth/2)), genreCheckboxY - (10*scaleFactor));
  text("Monsters", (keywordCheckboxX + (keywordCheckboxWidth/2)), keywordCheckboxY - (10*scaleFactor));
  text("Countries of Origin", (countriesBoxX + (countriesBoxWidth / 2)), countriesBoxY - (10 * scaleFactor));
  text("Movies", (moviesBoxX + (moviesBoxWidth / 2)), moviesBoxY - (10 * scaleFactor));
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
                     .setColorActive(#DFDFDF)
                     .setColorBackground(#3C6C71)
                     .setColorForeground(#AFAFAF)
                     ;
  selectedGenres.add("Comedy");
  selectedGenres.add("Drama");
  selectedGenres.add("Horror");
  selectedGenres.add("Musical");
  genreCheckbox.activateAll();
}

void initKeywordCheckbox() {
  keywordCheckbox = cp5.addCheckBox("keywordCheckbox")
                       .setPosition(keywordCheckboxX, keywordCheckboxY)
                       .setSize(keywordCheckboxWidth, keywordCheckboxHeight)
                       .addItem("Alien", 0)
                       .addItem("Demon", 1)
                       .addItem("Insect", 2)
                       .addItem("Ghost", 3)
                       .addItem("Ghoul", 4) 
                       .addItem("Monster", 5)
                       .addItem("Mutant", 6)
                       .addItem("Werewolf", 7)
                       .addItem("Vampire",8) 
                       .addItem("Zombie", 9)
                       .setSpacingColumn(scaleFactor * 40)
                       .setSpacingRow(scaleFactor * 10)
                       .setItemsPerRow(5)
                       .toUpperCase(false)
                       .setColorActive(#DFDFDF)
                       .setColorBackground(#3C6C71)
                       .setColorForeground(#AFAFAF)
                       ;
}

void initCountriesBox(){
   countriesBox = new SearchableListbox(cp5, countriesBoxX, countriesBoxY, countriesBoxHeight, countriesBoxWidth, listBoxItemHeight, countriesBoxWidth, listOfAllCountries, "countriesBox", true);
}

void initOnScreenKeyboard() {
   onScreenKeyboard = new Keyboard(this, onscreenKeyboardWidth, onscreenKeyboardHeight, onscreenKeyboardX, onscreenKeyboardY, font, #DFDFDF, #DFDFDF, #232323);
   onScreenKeyboard.setCollapsed();
}

// Very very very dangerous way of doing this
void keyReleased() {
  // should prob look for a different way of doing this...
  if(countriesBox.isInFocus()) {
    countriesBox.keyReleased();
  }
  else if(moviesBox.isInFocus()) {
    moviesBox.keyReleased();       
  }
}

void initTimeLine() {
  timeLine = new Timeline(this, cp5, timelineX, timelineY, timelineWidth, timelineHeight, "slider1");
}

void initMoviesBox() {
  moviesBox = new SearchableListbox(cp5, moviesBoxX, moviesBoxY, moviesBoxHeight, moviesBoxWidth, listBoxItemHeight, moviesBoxWidth, listOfAllMovies, "moviesBox", false);
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

void initDataViewButton(PFont font) {
  dataViewButton = new TouchButton(this, "Show Table", (float)dataViewButtonWidth, (float)dataViewButtonHeight, (float)dataViewButtonX, (float)dataViewButtonY, font); 
  dataViewButton.setBackgroundColor(color(#DFDFDF));
  dataViewButton.setTextColor(color(#2C2228));
}

void initMovieInformationBox() {
  movieInformationBox = new MovieInformationBox(this, cp5, movieInformationBoxX, movieInformationBoxY, movieInformationBoxHeight, movieInformationBoxWidth);
  movieInformationBox.updateInformationBox("Shaun of the Dead (2004)");
}

void initPiechart() {
  int[] blah = {1};
  pChart = new PieChart(this, pchartX, pchartY, pchartWidth, pchartHeight, blah);
}

void initDataTable() { 
  dataTable = new Table(this, cp5, "slider2", dataTableWidth, dataTableHeight, (float)dataTableX, (float)dataTableY, dataTableWidth, dataTableHeight, font);
  dataTable.shouldShowTable(false);
} 

void initHelpBox() {
  String help = "Help\n- Use the genre option to filter movies by genre\n- Use the keyword options to filter movies by keywords\n- A combination of the genre and keywords options can be used to filter data as well\n- The slider underneath the time line can be used to see movie data for a particular\n   range of years\n- Data for a particular set of countries can also be compared\n- Touching the country in the countries listbox adds them to the timeline\n- Touching the country from the area next to the listbox removes that country\n   from the timeline\n- Movie data for a particular movie can be seen by searching for the movie in the movies\n   listbox and touching that movie";
  PFont f = createFont("SansSerif", 7 * scaleFactor);
  helpBox = new Information(this, (float)helpBoxX, (float)helpBoxY, f, help);
}

void initCreditsBox() {
  String credits = "Credits\nCS424 Project 2\nAuthors: Siddharth Sathyam, Anna Mukhina, Kush Shah\nData Website: http://www.imdb.com/interfaces\nLibraries Used: Controlp5, SQLibrary, OMicron\nButtons from Daniel Stack\nWebpage: http://www.siddsathyam.com/projects/cs424/project2";
  creditsBox = new Information(this, (float)creditsBoxX, (float)creditsBoxY, font, credits);
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("genreCheckbox")) {
    selectedGenres.clear();
    for (int i=0;i<genreCheckbox.getArrayValue().length;i++) { 
      int n = (int)genreCheckbox.getArrayValue()[i];
      if(n == 1) {
        selectedGenres.add(genreCheckbox.getItem(i).getLabel());
        isGenreKeywordChanged = true; 
      }
    }
  }
  else if(theEvent.isFrom("keywordCheckbox")) {
    selectedKeywords.clear();
    for (int i=0;i<keywordCheckbox.getArrayValue().length;i++) { 
      int n = (int)keywordCheckbox.getArrayValue()[i];
      if(n == 1) {
        selectedKeywords.add(keywordCheckbox.getItem(i).getLabel());
        isGenreKeywordChanged = true; 
      }
    }
  } 
}

void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
  println("X: " + xPos + " Y: " + yPos);
  noFill();
  stroke(255,0,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );

  if(helpButton.Clicked(xPos, yPos)) {
    helpBox.setVisible();
    creditsBox.setCollapsed();  
  }
  else if(creditsButton.Clicked(xPos, yPos)) {
    creditsBox.setVisible();
    helpBox.setCollapsed(); 
  }
  else if(dataViewButton.Clicked(xPos, yPos)) {
    if(showTable) {
      showTable = false;
      dataViewButton.setText("Show Table");  
    }
    else {
      showTable = true;
      dataViewButton.setText("Show Timeline");    
    }   
  } 
  else if(onScreenKeyboard.Clicked(xPos, yPos)) {
     if(countriesBox.isInFocus()) {
       countriesBox.setText(onScreenKeyboard.getInput());  
       countriesBox.inputBox.keepFocus(true);
     } else if(moviesBox.isInFocus()) {
       moviesBox.setText(onScreenKeyboard.getInput());
       moviesBox.inputBox.keepFocus(true);
     }
  }
  
  cp5.getPointer().set(floor(xPos), floor(yPos));    
  if(displayOnWall) {
    cp5.getPointer().pressed();
  }
}// touchDown

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
  //println("touchMove(): Called from Proj class");
  noFill();
  stroke(0,255,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );

  cp5.getPointer().set(floor(xPos), floor(yPos));
}// touchMove

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
  println("X: " + xPos + " Y: " + yPos);
  noFill();
  stroke(0,0,255);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  
  if(countriesBox.isInFocus()) {
    countriesBox.inputBox.setFocus(true);
  }else if(moviesBox.isInFocus()) {
    moviesBox.inputBox.setFocus(true);
  }
  
  cp5.getPointer().set(floor(xPos), floor(yPos));
  if(displayOnWall) {
    cp5.getPointer().released();
  }
}// touchUp
