FloatTable data;
float dataMin, dataMax;

float plotX1, plotY1;
float plotX2, plotY2;
float labelX, labelY;

int currentColumn = 0;
int columnCount, rowCount;

int yearMin, yearMax;
int[] years;

int yearInterval = 10;
int volumeInterval = 10;
int volumeIntervalMinor = 5;
float barWidth = 4;

float [] tabLeft,tabRight;
float tabTop,tabBottom;
float tabPad = 10;

PImage[] tabImageNormal;
PImage[] tabImageHighlight;

Integrator [] interpolators;

PFont plotFont;
int keyp = 1;

void setup(){
  size(720, 405);  
  data = new FloatTable("milk-tea-coffee.tsv");
  rowCount = data.getRowCount();
  columnCount = data.getColumnCount();
  
  years = int(data.getRowNames());
  yearMin = years[0];
  yearMax = years[years.length-1];
  
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;
  
  plotX1 = 120; //50
  plotX2 = width - 80; //-plotX1
  labelX = 50;
  plotY1 = 60;
  plotY2 = height - 70; //- plotY1
  labelY = height - 25;
  
  interpolators = new Integrator[rowCount];
  for(int row =0; row<rowCount;row++){
    float initialValue = data.getFloat(row,0);
    interpolators[row] = new Integrator(initialValue);
//    interpolators[row].attraction = 0.1;
  }
  plotFont = createFont("Verdana", 20);
  textFont(plotFont);
  smooth();
}

void draw(){
  background(224);
  fill(255); 
  rectMode(CORNERS);
  noStroke();
  stroke(115,115,115);
  strokeWeight(2);
  rect(plotX1, plotY1, plotX2, plotY2);
  
//  drawTitle();
  drawTitleTabs();
  drawAxisLabels();
  
  for(int row =0;row<rowCount;row++){
    interpolators[row].update();
  }
  
  drawYearLabels();
  drawVolumeLabels();
  
  if(currentColumn == columnCount){
    summary();
  }
  else{
    stroke(#5679c1);
    strokeWeight(5);
    if (keyp == 1){//dots
    drawDataPoints(currentColumn);
    drawDataHighlight(currentColumn);
    }
    else if (keyp == 2){//connected dotts
  //    noFill();
  //    drawDataCurve(currentColumn);
      stroke(22,158,103);//#5679C1, 132,48,122 /// 226,80,174
      strokeWeight(5);
      drawDataPoints(currentColumn);
      noFill();
      strokeWeight(0.5);
      drawDataLine(currentColumn);
      drawDataHighlight(currentColumn);
    }
    else if (keyp == 3){//line chart
      noFill();
      drawDataLine(currentColumn);
      drawDataHighlight(currentColumn);
    }
    else if (keyp == 4){//filled area
        noStroke();
        fill(#5679C1);
        drawDataArea(currentColumn);
        drawDataHighlight(currentColumn);
    }
  } 
}

void drawTitle(){
  fill(0);
  textSize(20);
  textAlign(LEFT);
  String title;
  println("here : "+columnCount);
  if(currentColumn == columnCount)
    title = "summary";
  else
    title = data.getColumnName(currentColumn);
  text("'"+title+"'", (plotX1+plotX2-30)/2, plotY1 -10);
}

void drawAxisLabels(){
  fill(0);
  textSize(14);
  textLeading(15);
  textAlign(CENTER, CENTER);
  plotFont = createFont("Georgia", 14);
  textFont(plotFont);
  pushMatrix();
  rotate(-PI/2.0);
  text("Gallons consumed per capita", -190, 70);
  popMatrix();
  text("year", labelY, (plotX1+plotX2)/2);
}

void drawYearLabels(){
  fill(0);
  textSize(11);
  textAlign(CENTER, TOP);
  
  //use thin gray lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 0; row < rowCount; row++){
      if (years[row] % yearInterval == 0){
        float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
        text(years[row], x , plotY2+10);
        line(x, plotY1, x, plotY2);
      }
   }
}

void drawVolumeLabels(){
  fill(0);
  textSize(11);
  stroke(128);
  strokeWeight(1);
  
  for (float v = dataMin; v <= dataMax; v+= volumeInterval){
    if (v % volumeIntervalMinor == 0){
      float y = map(v, dataMin, dataMax, plotY2, plotY1);
      if (v % volumeInterval == 0){
        if (v == dataMin){
          textAlign(RIGHT);
        }else if (v == dataMax){
          textAlign(RIGHT, TOP);
        }else{
          textAlign(RIGHT, CENTER);
        }
        text(floor(v), plotX1-10, y);
        line(plotX1-4, y , plotX1, y);
      }else{
        //line(plotX1-2, y , plotX1, y);
      }
    }
  }
}


//draw data as a series of points
void drawDataPoints(int col){
  rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
//      float value = data.getFloat(row, col);
      float value = interpolators[row]._value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x,y);
    }
  }
}

void keyPressed(){
  if (key == '['){
    currentColumn --;
    if (currentColumn < 0){
      currentColumn = columnCount - 1;
    }
  }else if (key == ']'){
      currentColumn ++;
      if (currentColumn == columnCount){
        currentColumn = 0;
      }
    }
    else if (key == '1'){//dots
        keyp = 1;
    }
    else if (key == '2'){ // connected dots
        keyp = 2;
    }else if (key == '3'){ // line
        keyp = 3;
    }else if (key == '4'){ //filled chart
        keyp = 4;
    }
}

void drawTitleTabs(){
  rectMode(CORNERS);
  noStroke();
  textSize(10);
  textAlign(LEFT);
  
  if(tabLeft == null){
    tabLeft = new float[columnCount+1];
    tabRight = new float[columnCount+1];
    
    tabImageNormal = new PImage[columnCount+1];
    tabImageHighlight = new PImage[columnCount+1];
  
    int col = 0;
    for(col = 0;col< columnCount;col++){
      String title = data.getColumnName(col);
      tabImageNormal[col] = loadImage(title + "-unselected.png");
      tabImageHighlight[col] = loadImage(title + "-selected.png");
    }
    tabImageNormal[col] = loadImage("summary" + "-unselected.png");
    tabImageHighlight[col] = loadImage("summary" + "-selected.png");
  }
    float runningX = plotX1;
    tabBottom = plotY1;
    tabTop = plotY1 - tabImageNormal[0].height;
    //    tabTop = plotY1 - textAscent() -15;
    
    for(int col = 0;col< columnCount+1;col++){
      String title;
      if(col == columnCount)
        title = "summary";
      else
        title = data.getColumnName(col);
      tabLeft[col] = runningX;
      float titleWidth = tabImageNormal[col].width;
      tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;    
      PImage tabImage = (col == currentColumn)? 
        tabImageHighlight[col] : tabImageNormal[col];
      image(tabImage, tabLeft[col], tabTop);
      runningX = tabRight[col];
    }
    
//    tabLeft[col] = runningX;
//    float titleWidth = textWidth(title);
//    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
//    fill(col == currentColumn ? 255 : 224);
//    rect(tabLeft[col],tabTop,tabRight[col],tabBottom);
//    fill(col == currentColumn ? 0 : 64);
//    text(title, runningX+tabPad, plotY1-10);
//    runningX = tabRight[col];
  
}

void mousePressed(){
  if(mouseY > tabTop && mouseY < tabBottom){
    for(int col = 0;col<columnCount+1;col++){
      if(mouseX > tabLeft[col]&& mouseX < tabRight[col]){
        
        setCurrent(col);
      }
    }
  }
}

void setColumn(int col){
  if(col != currentColumn){
    currentColumn = col;
  }
}

void setCurrent(int col){
    currentColumn = col;
  if(col != columnCount){
    for(int row = 0;row<rowCount;row++){
      interpolators[row].target(data.getFloat(row,col));
    }
  }
}

void drawDataLine(int col){
  beginShape();
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x,y);
    }
  }
  endShape();
}

void drawDataHighlight(int col){
  for (int row=0;row<rowCount;row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      if(dist(mouseX,mouseY,x,y)<3){
        strokeWeight(10);
        point(x,y);
        fill(0);
        textSize(10);
        textAlign(CENTER);
        plotFont = createFont("Georgia", 15);
        textFont(plotFont);
        text(nf(value,0,2)+"("+years[row]+")",x,y-8);
      }
    }
  }
}

void drawDataCurve(int col){
  beginShape();
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      curveVertex(x,y);
      if((row==0)||(row==rowCount-1)){
        curveVertex(x,y);
      }
    }
  }
  endShape();
}

void drawDataArea(int col){
  beginShape();
  int rowCount = data.getRowCount();
  for (int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      vertex(x,y);
    }
  }
  vertex(plotX2, plotY2);
  vertex(plotX1, plotY2);
  endShape(CLOSE);
}

void drawDataBars(int col){
  noStroke();
  rectMode(CORNERS);
  
  for (int row = 0; row < rowCount; row++){
    if (data.isValid(row,col)){
      float value = data.getFloat(row, col);
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      rect(x-barWidth/2, y, x+barWidth/2, plotY2);
    }
  }
}

void summary(){
//  println("helo");
  for (int c=0 ; c<3 ; c++){
    if (c==0){//red
      stroke(226,80,174);
    }else if(c == 1){ //
      stroke(132,48,122);
    }else{
      stroke(22,158,103);
    }
    strokeWeight(3);
    noFill();
    drawDataLine(c);
    drawDataHighlight(c);
  }
}
