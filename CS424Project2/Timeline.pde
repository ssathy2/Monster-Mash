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
  
  float plotX1, plotY1;
  float plotX2, plotY2;
 
  int timelineHeight, timelineWidth;
  
  RangeControlListener listener;
  
  int[] lineColors = new int[6];
  
  boolean isPlotVisible = true;
  
  public Timeline(PApplet p, ControlP5 p5, int timelineX, int timelineY, int timelineWidthParam, int timelineHeightParam, String sliderName) {
    // use this object to grab latest sliderYearMax and slideryearMin values
    listener = new RangeControlListener();
    
    parent = p;
    plotX1 = (float)timelineX;
    plotY1 = (float)timelineY;
    
    sliderHeight = 25 * scaleFactor;
    sliderWidth = timelineWidthParam;
    yearsSliderHandleSize = 10 * scaleFactor;
    
    sliderX = floor(plotX1);
    sliderY = floor(plotY1) + timelineHeightParam - (10*scaleFactor);
    
    timelineHeight = timelineHeightParam ;
    timelineWidth = timelineWidthParam;
    plotX2 = (float)(plotX1 + timelineWidth);
    
    // the 10*scaleFactor is to fit in the years labels
    plotY2 = (float)(plotY1 + timelineHeight) - sliderHeight - (10 * scaleFactor);
    
    // Sample line colors for now... 
    lineColors[0] = color(#00FFFE);
    lineColors[1] = color(#D10010);
    lineColors[2] = color(#5B8749);
    lineColors[3] = color(#FFFD56);
    lineColors[4] = color(#FF9735);
    lineColors[5] = color(#237BDD);
    
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
  }
  
  public void drawYearLabels() {
    // temp interval var
    int yearInterval = 10;
    fill(#FFFFFF);
    textSize(8 * scaleFactor);
    textAlign(CENTER, TOP);
 
    for (int years = listener.sliderYearsMin;years <= listener.sliderYearsMax; years++) {
      if (years % yearInterval == 0) {
        float x = map(years, listener.sliderYearsMin, listener.sliderYearsMax, plotX1, plotX2);
        text(years, x, plotY2 + (10 * scaleFactor));
      }
    }
  }
  
  public void drawUnitLabels(int dataMin, int dataMax, int dataInterval) {
    // TODO: Need to implement an intuitive way of displaying the unit labels for the current 
    //       display we're looking at.
    fill(#DFDFDF);
    textSize(8 * scaleFactor);
    textAlign(RIGHT);
  
    stroke(128);
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
  }
  
  public void draw() {
    if(isPlotVisible) {
      // TODO: Should timeline have same bg color as regular app?
      parent.fill(#232323);
      parent.rectMode(CORNERS);
      parent.noStroke();
      parent.rect(plotX1, plotY1, plotX2, plotY2);

      drawYearLabels();
      drawUnitLabels(0, 100, 10);
      drawLines();
    }
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

