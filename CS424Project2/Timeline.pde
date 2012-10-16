import processing.core.*;
import controlP5.*;

/*
  Utility class to draw a timeline at requested plot points
  - Color can be changed by setting the BG and FG colors
  - Years can be adjusted by setting year min and year max values
  - data is plotted by passing a floatable of data to class
  - pass in a set of colors to color multiple lines
 */

class Timeline {
  
  PApplet parent;
  Range yearsSlider;
    
  int sliderX, sliderY;
  int sliderHeight, sliderWidth;
  int yearsSliderHandleSize;
  
  String rangeName;
  String title; 
   
  float plotX1, plotY1;
  float plotX2, plotY2;
 
  int timelineHeight, timelineWidth;
  
  RangeControlListener listener;
  
  boolean isPlotVisible = true;
  boolean showComedy = true;
  boolean showHorror = true;
  boolean showMusical = true;
  boolean showDrama = true;
  
     
  // Data
  HashMap<Integer, Integer> comedyCount;
  HashMap<Integer, Integer> horrorCount;  
  HashMap<Integer, Integer> musicalCount;
  HashMap<Integer, Integer> dramaCount;
  HashMap<Integer, Integer> genreKeyword;
  
  HashMap<String, HashMap<Integer, Integer>> cachedCountries;
  HashMap<String, HashMap<Integer, Integer>> cachedKeywordGenres;
  
  public Timeline(PApplet p, ControlP5 p5, int timelineX, int timelineY, int timelineWidthParam, int timelineHeightParam, String sliderName) {
    // use this object to grab latest sliderYearMax and slideryearMin values
    listener = new RangeControlListener();
    
    parent = p;
    plotX1 = (float)timelineX + (5 * scaleFactor);
    plotY1 = (float)(timelineY + (40 * scaleFactor));
    
    sliderHeight = 25 * scaleFactor;
    sliderWidth = timelineWidthParam;
    yearsSliderHandleSize = 10 * scaleFactor;
    
    sliderX = floor(plotX1);
    sliderY = floor(plotY1) + timelineHeightParam - (55*scaleFactor);
    
    timelineHeight = timelineHeightParam ;
    timelineWidth = timelineWidthParam;
    plotX2 = (float)(plotX1 + timelineWidth);
    
    // the 10*scaleFactor is to fit in the years labels
    plotY2 = (float)(plotY1 + timelineHeight) - sliderHeight - (60 * scaleFactor);
    
    rangeName = sliderName;
    
    yearsSlider = p5.addRange(sliderName)
                    .setBroadcast(false)
                    .setDecimalPrecision(0)
                    .setLabel("")
                    .setPosition(sliderX, sliderY)
                    .setSize(sliderWidth, sliderHeight)
                    .setHandleSize(yearsSliderHandleSize)
                    .setRange(1890, 2012)
                    .setRangeValues(1890, 2012)
                    // after the initialization we turn broadcast back on again
                    .setBroadcast(true)
                    .addListener(listener)
                    ;
      title = "BLAH BLAH TEST TITLE";
      cachedCountries = new HashMap<String, HashMap<Integer, Integer>>();
      cachedKeywordGenres = new HashMap<String, HashMap<Integer, Integer>>();
      loadData();  
  }
  
  public void loadData() {
    println("Loading comedy movies per year...");
    comedyCount = moviesDB.getNumberMoviesPerYear("Comedy", 1890, 2012); 
    println("Comedy movies per year loaded.");  
    println("Loading horror movies per year...");
    horrorCount = moviesDB.getNumberMoviesPerYear("Horror", 1890, 2012); 
    println("Horror movies per year loaded.");  
    println("Loading muscial movies per year...");
    musicalCount = moviesDB.getNumberMoviesPerYear("Musical", 1890, 2012); 
    println("Musical movies per year loaded.");  
    println("Loading drama movies per year...");
    dramaCount = moviesDB.getNumberMoviesPerYear("Drama", 1890, 2012); 
    println("drama movies per year loaded.");
    println("Loading keyword genre data...");
    genreKeyword = moviesDB.getMovieCount(Arrays.copyOf(selectedGenres.toArray(), selectedGenres.toArray().length, String[].class),
                                                                     Arrays.copyOf(selectedKeywords.toArray(), selectedKeywords.toArray().length, String[].class), 
                                                                     1890, 2012);  
    println("Keyword genre data loaded");
  } 

  public void drawYearLabels() {
    // temp interval var
    int yearInterval = 10;
    int minorYearInterval = 2;
    
    fill(#DFDFDF);
    textSize(8 * scaleFactor);
    textAlign(CENTER, TOP);
 
    stroke(#DFDFDF);
    strokeWeight(1);
    
    for (int years = listener.sliderYearsMin;years <= listener.sliderYearsMax; years++) {
      float x = map(years, listener.sliderYearsMin, listener.sliderYearsMax, plotX1, plotX2);
      if (years % yearInterval == 0) {
        text(years, x, plotY2 + (10 * scaleFactor));
        line(x, plotY2, x, plotY2 + (10*scaleFactor));
      }
      else if(years % minorYearInterval == 0) {
        line(x, plotY2, x, plotY2 + (5*scaleFactor));
      }
    }  
  }
  
  public void drawUnitLabels(int dataMin, int dataMax, int dataInterval) {
    // TODO: Need to implement an intuitive way of displaying the unit labels for the current 
    //       display we're looking at.
    fill(#DFDFDF);
    textSize(8 * scaleFactor);
    textAlign(RIGHT);
  
    stroke(#DFDFDF);
    strokeWeight(1);
    
    for(int i = dataMin; i <= dataMax; i = i + dataInterval) {
      float yPos = map(i, dataMin, dataMax, plotY2, plotY1);
      if (i == dataMin) {
          textAlign(RIGHT, CENTER);                 // Align by the bottom
          text(i, plotX1 - 3, yPos); 
      } else if (i == dataMax) {
          textAlign(RIGHT, CENTER);            // Align by the top
          text(i, plotX1 - 3, yPos); 
      } else {
          textAlign(RIGHT, CENTER);            // Align by the top
          text(i, plotX1 - 3, yPos);     
      }
      line(plotX1, yPos, plotX2, yPos); 
    }
  }
  
  public void drawLines() {
    // TODO: Need some way to draw the lines for the time-line
    //       Need some color coding scheme...use line-color array
    if(selectedCountries.isEmpty()) {
      if(!selectedGenres.isEmpty() && !selectedKeywords.isEmpty()) {
          drawGenreKeywordLine();
      }
      else {
        stroke(#EDFC47);
        strokeWeight(2);
        drawDataLine();    
      }
    }
    else {
      drawCountryLines();
    }
  }
  
  public void drawGenreKeywordLine() {
     // this is suicidal...each query execution takes like mf'in 3ish seconds, gots to figure out a way to cache these damn things
     if(isGenreKeywordChanged) {
       println("Getting keyword/genres...");
       genreKeyword = moviesDB.getMovieCount(Arrays.copyOf(selectedGenres.toArray(), selectedGenres.toArray().length, String[].class),
                                                                     Arrays.copyOf(selectedKeywords.toArray(), selectedKeywords.toArray().length, String[].class), 
                                                                     1890, 2012);
       println("Keyword/genres loaded");
       isGenreKeywordChanged = false;
     }
     drawColoredLine(#E31A45, genreKeyword);
     drawUnitLabels(0, getMaxValue(genreKeyword), 5);
  }
  
  private int getMaxValue(HashMap<Integer, Integer> m) {
    int maxVal = 0;
    for(int i = 1890; i <= 2012; i++) {
      if(m.get(i) > maxVal) {
        maxVal = m.get(i);
      }  
    }
    return maxVal;
  }
  
  public void drawCountryLines() {
    for(int i = 0; i < selectedCountries.size(); i++) {
      String country = selectedCountries.get(i);
      if(cachedCountries.containsKey(country)) {
        println("Found movies cached for: " + country);
        drawColoredLine(lineColors[i], cachedCountries.get(country));   
      } 
      else {
        println("Getting movies for " + country + "...");
        HashMap<Integer, Integer> moviesCountry = moviesDB.getNumberMoviesPerYear(Arrays.copyOf(selectedGenres.toArray(), selectedGenres.toArray().length, String[].class), country, 1890, 2012);
        println("Movies loaded for " + country);
        cachedCountries.put(country, moviesCountry);
        drawColoredLine(lineColors[i], moviesCountry);
      }  
    } 
  }
  
  public void drawColoredLine(int lineColor, HashMap<Integer, Integer> movies) {
    stroke(lineColor);
    strokeWeight(2);
    int[] displayArr = new int[(2012-1890)];
    
    for(int j = 1890; j <= 2012; j++) {
      if(j == 2012) {
        if(movies.get(j) == null){
          displayArr[j-1890-1] += 0;
        }else { 
          displayArr[j - 1890 - 1] += movies.get(j);  
        }
      } else {
        if(movies.get(j) == null) {
          displayArr[j-1890] += 0;
        } else {
          displayArr[j - 1890] += movies.get(j);
        }
      }
    }
    
    int yearsMin = listener.sliderYearsMin;
    int yearsMax = listener.sliderYearsMax;
    int maxVal = getMaxValue(displayArr);
    
    noFill();
    beginShape();
    for (int i = yearsMin; i <= yearsMax ; i++) {
      float value = (float) ((i == 2012)?displayArr[i - 1890 - 1]:displayArr[i - 1890]);
      float x = map(i, yearsMin, yearsMax, plotX1, plotX2);
      float y = map(value, 0, maxVal, plotY2, plotY1);
      vertex(x,y);
    }
    endShape();
  }
  
  private void drawDataLine() {
    showComedy = showHorror = showMusical = showDrama = false;
    int[] displayArr = new int[(2012-1890)];
    
      for(int i = 0; i < selectedGenres.size(); i++) {
        if(selectedGenres.get(i).equals("Horror")) {
          showHorror = true;
          for(int j = 1890; j <= 2012; j++) {
            if(horrorCount.get(j) == null) displayArr[j-1890] += 0;
            else {
              if(j == 2012) {
                displayArr[j - 1890 - 1] += horrorCount.get(j);  
              }
              else {
                displayArr[j - 1890] += horrorCount.get(j);
              }
            }
          }
        }
        else if(selectedGenres.get(i).equals("Comedy")) {
          showComedy = true;      
          for(int j = 1890; j <= 2012; j++) {
            if(comedyCount.get(j) == null) displayArr[j-1890] += 0;
            else {
              if(j == 2012) {
                displayArr[j - 1890 - 1] += comedyCount.get(j);  
              }
              else {
                displayArr[j - 1890] += comedyCount.get(j);
              }
            }
          }
        }
        else if(selectedGenres.get(i).equals("Musical")) {
          showMusical = true;
          for(int j = 1890; j <= 2012; j++) {
            if(musicalCount.get(j) == null) displayArr[j-1890] += 0;
            else {
              if(j == 2012) {
                displayArr[j - 1890 - 1] += musicalCount.get(j);  
              }
              else {
                displayArr[j - 1890] += musicalCount.get(j);
              }
            }
        }
        }
        else if(selectedGenres.get(i).equals("Drama")){
          showDrama = true;  
          for(int j = 1890; j <= 2012; j++) {
            if(dramaCount.get(j) == null) displayArr[j-1890] += 0;
            else {
              if(j == 2012) {
                displayArr[j - 1890 - 1] += dramaCount.get(j);  
              }
              else {
                displayArr[j - 1890] += dramaCount.get(j);
              }
            }
        }
      }
    }
    
    int yearsMin = listener.sliderYearsMin;
    int yearsMax = listener.sliderYearsMax;
    int maxVal = getMaxValue(displayArr);
    
    noFill();
    beginShape();
    for (int i = yearsMin; i <= yearsMax ; i++) {
      float value = (float) ((i == 2012)?displayArr[i - 1890 - 1]:displayArr[i - 1890]);
      float x = map(i, yearsMin, yearsMax, plotX1, plotX2);
      float y = map(value, 0, maxVal, plotY2, plotY1);
      vertex(x,y);
    }
    endShape();

    drawUnitLabels(0, maxVal, 1000);
  }
  
  public int getMaxValue(int[] numbers){  
  int maxValue = numbers[0];  
    for(int i=1;i < numbers.length;i++){  
      if(numbers[i] > maxValue){  
        maxValue = numbers[i];  
      }  
    }  
    return maxValue;  
  }  
  
  public void draw() {
    if(isPlotVisible) {
      // TODO: Should timeline have same bg color as regular app?
      parent.fill(backgroundColor);
      parent.rectMode(CORNERS);
      parent.noStroke();
      parent.rect(plotX1, plotY1, plotX2, plotY2);

      drawYearLabels();
      drawLines();
      drawTitle();
    }
  }
  
  public void drawTitle() {
    fill(#DFDFDF);
    textSize(8 * scaleFactor);
    textAlign(CENTER);
    
    text(title, (plotX1 + timelineWidth / 2), (plotY1 - ((40 * scaleFactor) / 2)));
  }
  
  public void shouldShowPlot(boolean showPlot) {
    isPlotVisible = showPlot;
  }
  
  class RangeControlListener implements ControlListener {
    int sliderYearsMin = 1890;
    int sliderYearsMax = 2012;
  
    public void controlEvent(ControlEvent theEvent) {
      if(theEvent.isFrom(rangeName)) {
        sliderYearsMin = floor(theEvent.getController().getArrayValue(0));
        sliderYearsMax = floor(theEvent.getController().getArrayValue(1));
        println("Slider: New Range Vals-> min: " + sliderYearsMin + " max: " + sliderYearsMax);
      }
    }
  }
}

