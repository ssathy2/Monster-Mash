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
  //FloatTable data;
  
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
  
  public Timeline(PApplet p, ControlP5 p5, int timelineX, int timelineY, int timelineWidthParam, int timelineHeightParam, String sliderName) {
    // use this object to grab latest sliderYearMax and slideryearMin values
    listener = new RangeControlListener();
    
    parent = p;
    plotX1 = (float)timelineX;
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
                    .showTickMarks(true)
                    .snapToTickMarks(true)
                    .addListener(listener)
                    ;
      title = "BLAH BLAH TEST TITLE";
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
          text(i, plotX1 - 4, yPos); 
      } else if (i == dataMax) {
          textAlign(RIGHT, CENTER);            // Align by the top
          text(i, plotX1 - 4, yPos); 
      } else {
          textAlign(RIGHT, CENTER);            // Align by the top
          text(i, plotX1 - 4, yPos);     
      }
      line(plotX1, yPos, plotX2, yPos); 
    }
  }
  
  public void drawLines() {
    // TODO: Need some way to draw the lines for the time-line
    //       Need some color coding scheme...use line-color array
    stroke(#EDFC47);
    strokeWeight(2);
    //drawDataLine(); 
  }
  
  private int getMaximum(Integer[] arr) {
    Arrays.sort(arr);
    return arr[arr.length];  
  }
  
  private void drawDataLine() {
    showComedy = showHorror = showMusical = showDrama = false;
    int maxVal = 0 ;
    int[] displayArr = new int[(2012-1890)];
    
    for(int i = 0; i < selectedGenres.size(); i++) {
      if(selectedGenres.get(i).equals("Horror")) {
        showHorror = true;
        maxVal += getMaximum(Arrays.copyOf(horrorCount.values().toArray(), comedyCount.values().toArray().length, Integer[].class));     
        for(int j = 1890; j <= 2012; j++) {
          displayArr[j-1890] += horrorCount.get(j);
        }
      }
      else if(selectedGenres.get(i).equals("Comedy")) {
        showComedy = true;         
        maxVal += getMaximum(Arrays.copyOf(comedyCount.values().toArray(), comedyCount.values().toArray().length, Integer[].class));     
        for(int j = 1890; j <= 2012; j++) {
          displayArr[j-1890] += comedyCount.get(j);
        }
      }
      else if(selectedGenres.get(i).equals("Musical")) {
        showMusical = true;
        maxVal += getMaximum(Arrays.copyOf(musicalCount.values().toArray(), comedyCount.values().toArray().length, Integer[].class));     
        for(int j = 1890; j <= 2012; j++) {
          displayArr[j-1890] += musicalCount.get(j);
        }
      }
      else if(selectedGenres.get(i).equals("Drama")){
        showDrama = true;  
        maxVal += getMaximum(Arrays.copyOf(dramaCount.values().toArray(), comedyCount.values().toArray().length, Integer[].class));     
        for(int j = 1890; j <= 2012; j++) {
          displayArr[j-1890] += dramaCount.get(j);
        }
      }
    }
    
    beginShape();
    
    int yearsMin = listener.sliderYearsMin;
    int yearsMax = listener.sliderYearsMax;
    
    for (int i = 0; i < displayArr.length; i++) {
      float value = (float)displayArr[i];
      float x = map(value, yearsMin, yearsMax, plotX1, plotX2);
      float y = map(value, 0, maxVal, plotY2, plotY1);
      vertex(x,y);
    }
    endShape();

  }
  
  public void draw() {
    if(isPlotVisible) {
      // TODO: Should timeline have same bg color as regular app?
      parent.fill(backgroundColor);
      parent.rectMode(CORNERS);
      parent.noStroke();
      parent.rect(plotX1, plotY1, plotX2, plotY2);

      drawYearLabels();
      drawUnitLabels(0, 50, 10);
      //drawLines();
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

