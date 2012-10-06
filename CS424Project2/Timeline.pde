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
  
  float plotX1, plotY1;
  float plotX2, plotY2;
 
  int timelineHeight, timelineWidth;
  
  RangeControlListener listener;
  
  int[] lineColors = new int[6];
  
  boolean isPlotVisible = true;
  
  public Timeline(PApplet p, ControlP5 p5, int timelineX, int timelineY, int timelineWidthParam, int timelineHeightParam) {
    // use this object to grab latest sliderYearMax and slideryearMin values
    listener = new RangeControlListener();
    
    parent = p;
    plotX1 = (float)timelineX;
    plotY1 = (float)timelineY;
    
    sliderHeight = 25 * scaleFactor;
    sliderWidth = timelineWidthParam;
    yearsSliderHandleSize = 10 * scaleFactor;
    
    sliderX = floor(plotX1);
    sliderY = floor(plotY1) + timelineHeightParam - (sliderHeight);
    
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
    
    yearsSlider = p5.addRange("yearsRange")
                    .setBroadcast(false)
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
  }
  
  public void draw() {
    if(isPlotVisible) {
      parent.fill(#DFDFDF);
      parent.rectMode(CORNERS);
      parent.noStroke();
      parent.rect(plotX1, plotY1, plotX2, plotY2);
      parent.stroke(#EDFC47);
      parent.strokeWeight(2);
    }
  }
  
  public void shouldShowPlot(boolean showPlot) {
    isPlotVisible = showPlot;
  }
}

class RangeControlListener implements ControlListener {
  int sliderYearsMin;
  int sliderYearsMax;
  
  public void controlEvent(ControlEvent theEvent) {
    if(theEvent.isFrom("yearsRange")) {
      sliderYearsMin = floor(theEvent.getController().getArrayValue(0));
      sliderYearsMax = floor(theEvent.getController().getArrayValue(1));
      println("Slider: New Range Vals-> min: " + sliderYearsMin + " max: " + sliderYearsMax);
    }
  }

}
