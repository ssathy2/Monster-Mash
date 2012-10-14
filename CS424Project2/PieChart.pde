class PieChart { 
  PApplet parent;
  int xPos;
  int yPos;
  int pieChartHeight;
  int pieChartWidth;
  
  float diameter;
  
  ArrayList<Integer> angles;
  int[] vals;
  
  float lastAngle = 0;
  
  public PieChart(PApplet p, int x, int y, int w, int h, int[] values) {
   parent = p;
   xPos = x;
   yPos = y;
   pieChartHeight = h;
   pieChartWidth = w;
   
   angles = new ArrayList<Integer>();
   vals = values;
   diameter = min(pieChartWidth, pieChartHeight) * 0.75;
   noStroke();
   noLoop();
   calculateAngles();
  } 
  
  public void calculateAngles() {
    int sum = 0;
    int i = 0;
    for(i = 0; i < vals.length; i++) {
      sum += vals[i];
    } 
    i = 0;
    for(i = 0; i < vals.length; i++) {
      angles.add((vals[i] / sum) * 360);
    } 
  }
  
  public void draw() {
    for (int i = 0; i < angles.size(); i++) {
      parent.fill(angles.get(i) * 3.0);
      parent.arc(pieChartWidth/2, pieChartHeight/2, diameter, diameter, lastAngle, lastAngle+(parent.radians(angles.get(i))));
      lastAngle += radians(angles.get(i));
    }
  }

}


