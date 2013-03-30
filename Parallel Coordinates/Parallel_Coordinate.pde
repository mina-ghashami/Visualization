//import java.io.IOException;
//import java.util.Vector;
//import java.io.BufferedReader;
//import java.io.DataInputStream;
//import java.io.FileInputStream;
//import java.io.FileNotFoundException;
//import java.io.IOException;
//import java.io.InputStreamReader;


//class Main extends PApplet {
  PFont plotFont;
  float X1, Y1;
  float width, height;
  float labelX, labelY;
  dataReader reader1, reader2, currentReader;
  Axis[] axes;
  int[] currentAxisOrdering;
  Vector<Integer> initmousex, initmousey, endmousex, endmousey;
  boolean pressed = false;
  boolean dragged = false;
  PImage reset;
  int kmeans;
  boolean drawClusteringMode = false;
  boolean k3, k4, k6;

  void setup() {
    size(1500, 520);
    plotFont = createFont("Verdana", 20);
    textFont(plotFont);
    X1 = 100;
    Y1 = 120;//60
    width = 5;
    height = 300;
    kmeans = 4;
    k3 = false;
    k4 = false; 
    k6 = false;
    initmousex = new Vector<Integer>();
    initmousey = new Vector<Integer>();
    endmousex = new Vector<Integer>();
    endmousey = new Vector<Integer>();
    reset = loadImage("C:\\Users\\Mina\\Documents\\Processing\\sketchbook\\Parallel_Coordinate\\image\\reset3.png");
    try {
      reader1 = new dataReader("C:\\Users\\Mina\\Documents\\Processing\\sketchbook\\Parallel_Coordinate\\cars.okc");//cars.okc
      reader2 = new dataReader("C:\\Users\\Mina\\Documents\\Processing\\sketchbook\\Parallel_Coordinate\\cameras.txt");
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    reader1.setkmeans(kmeans);
    reader2.setkmeans(kmeans);
    currentReader = reader1;
    initiation();
  }

  void initiation() {
    axes = new Axis[currentReader.columnCount];
    currentAxisOrdering = new int[currentReader.columnCount];
    for (int i = 0; i < axes.length; i++) {
      axes[i] = new Axis(currentReader.getColumnName(i), currentReader.getColumnMin(i), currentReader.getColumnMax(i));
      axes[i].setWidth(width);
      axes[i].setHeight(height);
      axes[i].setupperLeftX(X1+i*100);
      axes[i].setupperLeftY(Y1);
      axes[i].setLabelX();
      axes[i].setLabelY();
      axes[i].setMinMaxPosition();
      currentAxisOrdering[i] = i;
    }
  }

  void draw() {
    background(225);
    rectMode(CORNER);
    drawButtons();

    drawTitle();
    drawAxisLabel();
    drawAxisBounds();
    drawArrows();
    if (!drawClusteringMode)
      drawLines(currentReader.data, 220, 102, 0, currentReader.data.length);
    else {
      drawClusters();
    }
    drawSelectArea();  
    drawAxisBar();
    drawLineHighlight();
  }

  void drawTitle() {
    fill(0);
    textSize(22);
    textAlign(CENTER, CENTER);
    if (currentReader == reader1)
      text("\"Cars data set\"", X1+100*3, Y1+height+60);
    else
      text("\"Cameras data set\"", X1+100*5, Y1+height+80);
  }


  void drawClusters() {
    drawClusteringMode = true;
    try {
      if (currentReader == reader1)
        currentReader.loadClusterFiles("C:\\Users\\Mina\\Documents\\Processing\\sketchbook\\Parallel_Coordinate\\cars\\"+kmeans);
      else
        currentReader.loadClusterFiles("C:\\Users\\Mina\\Documents\\Processing\\sketchbook\\Parallel_Coordinate\\cameras\\"+kmeans);
    } 
    catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    } 
    catch (Exception e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    int[] r = new int[6];
    int[] g = new int[6];
    int[] b = new int[6];
    r[0] = 163; 
    r[1] = 255; 
    r[2] = 255; 
    r[3] = 0; 
    r[4] = 0; 
    r[5] = 255;
    g[0] = 73; 
    g[1] = 201; 
    g[2] = 128; 
    g[3] = 179; 
    g[4] = 162; 
    g[5] = 128;
    b[0] = 164; 
    b[1] = 14; 
    b[2] = 192; 
    b[3] = 0; 
    b[4] = 232; 
    b[5] = 128;
    for (int i = 0; i < kmeans; i++) {
      drawLines(currentReader.data_cluster[i], r[i], g[i], b[i], currentReader.counter[i]);
    }
  }

  void drawButtons() {
    image(reset, 10, 70, 50, 50);

    textSize(12);
    textAlign(LEFT, LEFT);
    fill(255);
    rect(5, 120, 75, 30);
    fill(0);
    strokeWeight(2);
    text("plain data", 10, 140);

    fill(255);
    strokeWeight(1);
    rect(150, 30, 120, 30);
    fill(0);
    strokeWeight(2);
    text("Cars dataset", 165, 50);

    fill(255);
    strokeWeight(1);
    rect(340, 30, 120, 30);
    fill(0);
    strokeWeight(2);
    text("Cameras dataset", 345, 50);

    strokeWeight(1);
    fill(255);
    rect(5, 160, 75, 30);
    fill(0);
    strokeWeight(2);
    text("k = 3", 14, 180);

    strokeWeight(1);
    fill(255);
    rect(5, 200, 75, 30);
    fill(0);
    strokeWeight(2);
    text("k = 4", 14, 220);

    strokeWeight(1);
    fill(255);
    rect(5, 240, 75, 30);
    fill(0);
    strokeWeight(2);
    text("k = 6", 14, 260);
  }

  void drawArrows() {
    for (int i = 0; i < axes.length; i++) {
      if (axes[currentAxisOrdering[i]].asc)
        image(axes[currentAxisOrdering[i]].ascimg, axes[currentAxisOrdering[i]].imgX, axes[currentAxisOrdering[i]].imgY, axes[currentAxisOrdering[i]].imgW, axes[currentAxisOrdering[i]].imgH);
      else
        image(axes[currentAxisOrdering[i]].dscimg, axes[currentAxisOrdering[i]].imgX, axes[currentAxisOrdering[i]].imgY, axes[currentAxisOrdering[i]].imgW, axes[currentAxisOrdering[i]].imgH);
    }
  }

  void drawAxisBar() {
    for (int i = 0; i < axes.length; i++) {
      axes[currentAxisOrdering[i]].drawBar();
    }
  }

  void drawAxisBounds() {
    textSize(10);
    textAlign(LEFT, LEFT);
    for (int i = 0; i < axes.length; i++) {
      axes[currentAxisOrdering[i]].drawBounds();
    }
  }


  void drawAxisLabel() {
    fill(0);
    textSize(12);
    textAlign(CENTER, CENTER);
    for (int i = 0; i < axes.length; i++) {
      String name = axes[currentAxisOrdering[i]].name;
//      if(name == null)
//        print("nill");
        
      if (!name.contains("_"))
        text(name, axes[currentAxisOrdering[i]].labelX, axes[currentAxisOrdering[i]].labelY);
      else {
        String t="";
        String[] temp = name.split("_");
        for (int j = 0; j < temp.length; j++) {
          t = t + temp[j]+"\n";
        }
        text(t, axes[currentAxisOrdering[i]].labelX, axes[currentAxisOrdering[i]].labelY+30);
      }
    }
  }

  void drawLines(Float[][] data, int r, int g, int b, int counter) {  
    for (int i = 0; i <counter; i++) {//currentReader.data.length
      drawOneLine(data, i, r, g, b);
    }
  }

  boolean wholeRangeBars() {
    for (int i = 0; i < axes.length; i++) {
      if (axes[currentAxisOrdering[i]].yselect1 != 0 || axes[currentAxisOrdering[i]].yselect2 != 0)
        return false;
    }
    return true;
  }
  void drawOneLine(Float[][] data, int i, int r, int g, int b) {
    if (drawClusteringMode) {
      stroke(r, g, b);
      beginShape();
      for (int j = 0; j < axes.length; j++) {//axes.length
        float d = data[i][currentAxisOrdering[j]];
        noFill();
        strokeWeight(1);
        vertex(axes[currentAxisOrdering[j]].upperLeftX+axes[currentAxisOrdering[j]].widthh/2, axes[currentAxisOrdering[j]].getValuePos(d));
      }
      endShape();
    }
    else {
      if (wholeRangeBars())// first state
        stroke(0, 125, 0, 40);
      else {// some bars have selections
        boolean isSelected = true;
        for (int j = 0; j < axes.length; j++) {//axes.length
          float d = currentReader.data[i][currentAxisOrdering[j]];
          if (axes[currentAxisOrdering[j]].hasSelectedPortion)
            if (!axes[currentAxisOrdering[j]].inSelectedArea(axes[currentAxisOrdering[j]].getValuePos(d))) {
              isSelected = false;
            }
        }
        if (isSelected)
          stroke(r, g, b, 100);
        else
          stroke(0, 125, 0, 40);
      }
      beginShape();
      for (int j = 0; j < axes.length; j++) {//axes.length
        float d = currentReader.data[i][currentAxisOrdering[j]];
        noFill();
        strokeWeight(1);
        vertex(axes[currentAxisOrdering[j]].upperLeftX+axes[currentAxisOrdering[j]].widthh/2, axes[currentAxisOrdering[j]].getValuePos(d));
      }
      endShape();
    }
  }

  void drawLineHighlight() {
    for (int i = 0; i < currentReader.data.length; i++) {//currentReader.data.length
      if (fitInLineEq(currentReader.data[i])) {
        stroke(230, 0, 200);
        beginShape();
        for (int j = 0; j < axes.length; j++) {//axes.length
          float d = currentReader.data[i][currentAxisOrdering[j]];
          noFill();
          strokeWeight(1);
          vertex(axes[currentAxisOrdering[j]].upperLeftX+axes[currentAxisOrdering[j]].widthh/2, axes[currentAxisOrdering[j]].getValuePos(d));
        }
        endShape();
        showDetails(currentReader.data[i]);
      }
    }
  }

  void showDetails(Float[] arr) {
    float x, y;
    for (int i = 0; i < arr.length; i++) {
      x = axes[i].upperLeftX;
      y = axes[i].getValuePos(arr[i]);
      textSize(12);
      textAlign(CENTER);
      fill(0, 102, 253);//blue
      text(arr[i]+"", x, y);
    }
  }

  boolean fitInLineEq(Float[] arr) { 
    float x1, x2, y1, y2;
    float a, b;
    boolean flag = false;
    for (int i = 0; i < arr.length-1; i++) {
      x1 = axes[i].upperLeftX;
      x2 = axes[i+1].upperLeftX;
      y1 = axes[i].getValuePos(arr[i]);
      y2 = axes[i+1].getValuePos(arr[i+1]);
      a = (y2-y1)/(x2-x1);
      b = y2 - a*x2;
      if ( mouseXInSameArea(x1, x2) && mouseYInSameArea(Y1, Y1+height)&& abs(mouseY - a*mouseX - b) < 0.5) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  boolean mouseXInSameArea(float x1, float x2) {
    if (mouseX>=x1 && mouseX<=x2) {
      return true;
    }
    return false;
  }

  boolean mouseYInSameArea(float y1, float y2) {
    if (mouseY>=y1 && mouseY<=y2) {
      return true;
    }
    return false;
  }

  void mousePressed() {
    initmousex.add(mouseX);
    initmousey.add(mouseY);
    pressed = true;
    for (int i = 0; i < axes.length; i++) {
      //if mouse is over arrow pic
      if (axes[currentAxisOrdering[i]].mouseOverArrow()) {
        //change the pic
        axes[currentAxisOrdering[i]].asc = !axes[currentAxisOrdering[i]].asc;
        axes[currentAxisOrdering[i]].reverseAxis();
      }
      //if mouse is over axis bar, MOVE the bar
      if (axes[currentAxisOrdering[i]].mouseOverBar()) {
        axes[currentAxisOrdering[i]].locked = true;
        axes[currentAxisOrdering[i]].xoffset = mouseX - axes[currentAxisOrdering[i]].upperLeftX;
      }
      //if mouse not over bar, SELECT the bar
      if (!axes[currentAxisOrdering[i]].mouseOverBar()) {
        axes[currentAxisOrdering[i]].locked = false;
        axes[currentAxisOrdering[i]].xoffset = mouseX - axes[currentAxisOrdering[i]].upperLeftX;
        axes[currentAxisOrdering[i]].yoffset = mouseY - axes[currentAxisOrdering[i]].upperLeftY;
      }
    }
  }

  void mouseClicked() {
    //over reset button
    if (mouseXInSameArea(10, 10+50) && mouseYInSameArea(70, 70+50)) {//mouse over reset button
      initiation();
    }
    else if (mouseXInSameArea(5, 80) && mouseYInSameArea(120, 150)) {//plain button
      //      Systeout.println("plain");
      drawClusteringMode = false;
    }
    else if (mouseXInSameArea(5, 80) && mouseYInSameArea(160, 190)) {//k==3 button
      //      Systeout.println("k3");
      drawClusteringMode = true;
      kmeans = 3;
      currentReader.setkmeans(kmeans);
    }
    else if (mouseXInSameArea(5, 80) && mouseYInSameArea(200, 230)) {//k==4 button
      //      Systeout.println("k4");
      drawClusteringMode = true;
      kmeans = 4;
      currentReader.setkmeans(kmeans);
    }
    else if (mouseXInSameArea(5, 80) && mouseYInSameArea(240, 270)) {//k==6 button
      //      Systeout.println("k6");
      drawClusteringMode = true;
      kmeans = 6;
      currentReader.setkmeans(kmeans);
    }
    if (mouseXInSameArea(150, 270) && mouseYInSameArea(30, 60)) {//car
      if (currentReader == reader1)
        ;
      else {
        currentReader = reader1;
        initiation();
      }
    }
    if (mouseXInSameArea(340, 460) && mouseYInSameArea(30, 60)) {//camera
      if (currentReader == reader2)
        ;
      else {
        currentReader = reader2;
        //        currentReader.printData();
        initiation();
      }
    }
  }

  void mouseDragged() {
    dragged = true;
    for (int i = 0; i < axes.length; i++) {
      if (axes[currentAxisOrdering[i]].locked) {
        axes[currentAxisOrdering[i]].setupperLeftX(mouseX - axes[currentAxisOrdering[i]].xoffset);
        float up2 = axes[currentAxisOrdering[i]].upperLeftX;
        axes[currentAxisOrdering[i]].setMinMaxPosition();
        axes[currentAxisOrdering[i]].setLabelX();
        axes[currentAxisOrdering[i]].setLabelY();
        calculateCurrentAxisOrder(i, up2);
      }
    }
    noFill();
    stroke(0, 0, 120);
    if (!mouseIsOverBars()) {
      //      Systeout.println("h");
      rect(initmousex.lastElement(), initmousey.lastElement(), mouseX-initmousex.lastElement(), mouseY-initmousey.lastElement());
    }
  }

  

  void calculateCurrentAxisOrder(int i, float up2) {
    if (i==0) {
      float right = axes[currentAxisOrdering[1]].upperLeftX;
      if (up2<right)
        ;
      else
        shift(currentAxisOrdering, 0, 1);
    }
    else if (i == axes.length-1) {
      float left = axes[currentAxisOrdering[axes.length-2]].upperLeftX; 
      if (up2 > left)
        ;
      else
        shift(currentAxisOrdering, axes.length-1, axes.length-2);
    }
    else {
      float left = axes[currentAxisOrdering[i-1]].upperLeftX; 
      float right = axes[currentAxisOrdering[i+1]].upperLeftX;
      if (up2>left && up2<right)
        ;
      else if (up2 < left) {
        shift(currentAxisOrdering, i, i-1);
      }
      else if (up2 > right) {
        shift(currentAxisOrdering, i, i+1);
      }
    }
  }

  void shift(int[] arr, int source, int destination) {
    if (source > destination) {
      int temp = arr[source];
      for (int i = source-1; i >= destination; i--) {
        arr[i+1] = arr[i];
      }
      arr[destination] = temp;
    }
    else {
      int temp = arr[source];
      for (int i = source+1; i <= destination; i++) {
        arr[i-1] = arr[i];
      }
      arr[destination] = temp;
    }
  }

  boolean mouseIsOverBars() {
    for (int i = 0; i < axes.length; i++) {
      if (axes[currentAxisOrdering[i]].locked)
        return true;
    }
    return false;
  }

  void mouseReleased() {
    pressed = false;
    endmousex.add(mouseX);
    endmousey.add(mouseY);
    //if mouse drag shode , area E select shode pas bia analyzesh kon
    if (dragged && !mouseIsOverBars()) {
      analyzeSelectedArea();
    }
    else
      analyzeClick();
    for (int i = 0; i < axes.length; i++) {
      axes[currentAxisOrdering[i]].locked = false;
    }
    dragged =false;
    //    printArr(currentAxisOrdering);
  }

  void analyzeSelectedArea() {
    for (int i = 0; i < axes.length; i++) {
      axes[currentAxisOrdering[i]].analyzeArea();
    }
  }

  void analyzeClick() {
    for (int i = 0; i < axes.length; i++) {
      axes[currentAxisOrdering[i]].analyzeClick();
    }
  }

  void drawSelectArea() {
    noFill();
    stroke(0, 0, 120);
    if (pressed && !mouseIsOverBars())
      rect(initmousex.lastElement(), initmousey.lastElement(), mouseX-initmousex.lastElement(), mouseY-initmousey.lastElement());
  }

  class dataReader {

    int rowCount; //rows of data, excluding header
    int columnCount;
    String[] columnNames;
    int kmeans;
    Float[][] data;
    //clusters
    Float[][][] data_cluster;
    int[][] ids_cluster;
    int[] counter;

    void loadClusterFiles(String fileAddr) throws Exception, IOException {
      data_cluster = new Float[kmeans][rowCount][columnCount];
      ids_cluster = new int[kmeans][rowCount];
      counter = new int[kmeans];

      for (int i = 0; i < kmeans; i++) {
        String filename = fileAddr+"\\data_cluster_"+(i+1)+".txt";
        FileInputStream fstream = new FileInputStream(filename);
        DataInputStream in = new DataInputStream(fstream);
        BufferedReader br = new BufferedReader(new InputStreamReader(in));
        String strLine;
        int c = 0;
        while ( (strLine = br.readLine ()) != null) {
          String[] pieces = strLine.split("  ");
          for (int k = 1; k < pieces.length; k++) {
            data_cluster[i][c][k-1] = Float.valueOf(pieces[k]);
          }
          c++;
        }
        counter[i] = c;
        //read id files
        filename = fileAddr+"\\ids_cluster_"+(i+1)+".txt";
        fstream = new FileInputStream(filename);
        in = new DataInputStream(fstream);
        br = new BufferedReader(new InputStreamReader(in));
        c = 0;
        strLine = br.readLine();
        String[] pieces = strLine.split("  ");
        for (int j = 1; j < pieces.length; j++) {
          ids_cluster[i][j-1] = Math.round(Float.valueOf(pieces[j]));
        }
      }
    }

    dataReader() {
    }

    dataReader(String filename) throws IOException {
      FileInputStream fstream = new FileInputStream(filename);
      DataInputStream in = new DataInputStream(fstream);
      BufferedReader br = new BufferedReader(new InputStreamReader(in));
      String strLine;

      setRowCount(br);

      String[] rows = new String[rowCount];//does not contain header

      fstream = new FileInputStream(filename);
      in = new DataInputStream(fstream);
      br = new BufferedReader(new InputStreamReader(in));

      strLine = br.readLine();
      String delim = " ";
      if (!strLine.contains(delim)) {
        delim = "\t";
      }
      columnNames = strLine.split(delim);
      columnCount = columnNames.length;

      int c = 0;
      while ( (strLine = br.readLine ()) != null) {
        rows[c++] = strLine; //rows does not contain header
      }

      data = new Float[rowCount][columnCount];
      delim = " ";
      if (!rows[0].contains(delim)) {
        delim = "\t";
      }

      for (int i = 0; i < rows.length; i++) {
        if (rows[i].trim().length() == 0) {
          continue; // skip empty rows
        }
        if (rows[i].startsWith("#")) {
          continue;  // skip comment lines
        }
        // split the row on the tabs
        String[] pieces = rows[i].split(delim);
        for (int k = 0; k < pieces.length; k++) {
          data[i][k] = Float.valueOf(pieces[k]);
        }
      }
    }

    

    
    void setRowCount(BufferedReader br) {
      rowCount = 0;
      String strLine;
      try {
        while ( (strLine = br.readLine ()) != null) {
          rowCount++;
        }
      } 
      catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      rowCount--; // for excluding header
    }
    int getRowCount() {
      return rowCount;
    }

    String getColumnName(int colIndex) {
      return columnNames[colIndex];
    }
    String[] getColumnNames() {
      return columnNames;
    }
    boolean isValid(int row, int col) {
      if (row < 0) return false;
      if (row >= rowCount) return false;
      //if (col >= columnCount) return false;
      if (col >= data[row].length) return false;
      if (col < 0) return false;
      return !data[row][col].isNaN();
    }


    float getColumnMin(int col) {
      Float m = Float.MAX_VALUE;
      for (int i = 0; i < rowCount; i++) {
        //        Systeout.println("i : "+i);
        if (!data[i][col].isNaN()) {
          if (data[i][col] < m) {
            m = data[i][col];
          }
        }
      }
      return m;
    }
    float getColumnMax(int col) {
      Float m = -Float.MAX_VALUE;
      for (int i = 0; i < rowCount; i++) {
        if (isValid(i, col)) {
          if (data[i][col] > m) {
            m = data[i][col];
          }
        }
      }
      return m;
    }


    float getRowMin(int row) {
      Float m = Float.MAX_VALUE;
      for (int i = 0; i < columnCount; i++) {
        if (isValid(row, i)) {
          if (data[row][i] < m) {
            m = data[row][i];
          }
        }
      }
      return m;
    } 


    float getRowMax(int row) {
      Float m = -Float.MAX_VALUE;
      for (int i = 1; i < columnCount; i++) {
        if (!Float.isNaN(data[row][i])) {
          if (data[row][i] > m) {
            m = data[row][i];
          }
        }
      }
      return m;
    }


    float getTableMin() {
      Float m = Float.MAX_VALUE;
      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          if (isValid(i, j)) {
            if (data[i][j] < m) {
              m = data[i][j];
            }
          }
        }
      }
      return m;
    }


    float getTableMax() {
      Float m = -Float.MAX_VALUE;
      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          if (isValid(i, j)) {
            if (data[i][j] > m) {
              m = data[i][j];
            }
          }
        }
      }
      return m;
    }

    float getFloat(int rowIndex, int col) {
      // Remove the 'training wheels' section for greater efficiency
      // It's included here to provide more useful error messages

      // begin training wheels
      if ((rowIndex < 0) || (rowIndex >= data.length)) {
        throw new RuntimeException("There is no row " + rowIndex);
      }
      if ((col < 0) || (col >= data[rowIndex].length)) {
        throw new RuntimeException("Row " + rowIndex + " does not have a column " + col);
      }
      // end training wheels

      return data[rowIndex][col];
    }

    
    void setkmeans(int kmeans) {
      kmeans = kmeans;
    }
  }



  class Axis {
    String name;
    float minn;
    float maxx;
    float widthh;
    float heightt;
    float upperLeftX, upperLeftY;
    float labelX, labelY;
    float minX, minY, maxX, maxY;
    PImage ascimg, dscimg;
    boolean asc;
    float imgW, imgH, imgX, imgY;
    boolean locked, overbar;
    float xoffset, yoffset;
    float yselect1 = 0, yselect2 = 0; //stores selected range of  axis, yselec1 is lower one,yselect2 is upper one
    boolean hasSelectedPortion = false;

    Axis(String namep, float minnp, float maxxp) {
      name = namep;
      minn = minnp;
      maxx = maxxp;
      ascimg = loadImage("C:\\Users\\Mina\\workspace\\ParallelCoordinates\\image\\asc.png");
      dscimg = loadImage("C:\\Users\\Mina\\workspace\\ParallelCoordinates\\image\\dsc.png");
      imgW = 25;
      imgH = 27;
      asc = true;
      locked = false;
      overbar = false;
      xoffset = upperLeftX;
      yoffset = upperLeftY;
    }

    void setWidth(float widthhp) {
      widthh = widthhp;
    }

    void setHeight(float heighttp) {
      heightt = heighttp;
    }

    void setupperLeftX(float x) {
      upperLeftX = x;
      imgX = upperLeftX-9;
    }

    void setupperLeftY(float y) {
      upperLeftY = y;
      imgY = upperLeftY-30;
    }

    void setLabelX() {
      labelX = upperLeftX;
    }

    void setLabelY() {
      labelY = upperLeftY+heightt+10;
    }

    void setMinMaxPosition() {
      setMinX();
      setMinY();
      setMaxX();
      setMaxY();
      if (!asc)
        swapMinMaxPosition();
    }

    void setMinX() {
      minX = upperLeftX + widthh + 10;
    }

    void setMinY() {
      minY = upperLeftY + heightt - 2;
    }

    void setMaxX() {
      maxX = upperLeftX + widthh + 10;
    }

    void setMaxY() {
      maxY = upperLeftY + 5;
    }

    float scaleValue(float v) {
      return map(v, minn, maxx, 0, heightt);
    }

    float getValuePos(float v) {// with scaling
      v = scaleValue(v);
      if (asc)
        return upperLeftY + heightt - v;
      else
        return upperLeftY + v;
    }

    void swapMinMaxPosition() {
      float temp = minX;
      minX = maxX;
      maxX = temp;
      temp = minY;
      minY = maxY;
      maxY = temp;
    }
    void drawBounds() {
      textSize(10);
      textAlign(LEFT, LEFT);    
      fill(0);
      strokeWeight(1);
      text(Math.floor(minn)+"", minX, minY); 
      text(Math.ceil(maxx)+"", maxX, maxY);
    }

    void drawBar() {
      if (mouseOverBar()) {
        overbar = true;
        if (!locked) {
          stroke(253);
          fill(153);
        }
      }
      else {  
        stroke(115, 115, 115);
        fill(255);
      }
      rect(upperLeftX, upperLeftY, widthh, heightt);
      //    if(hasSelectedPortion)
      //      drawSelectedPortion(p);
    }

    void reverseAxis() {
      swapMinMaxPosition();
      drawBounds();
    }
    boolean mouseOverBar() {
      if (mouseXInSameArea(upperLeftX, upperLeftX+widthh) && 
        mouseYInSameArea(upperLeftY, upperLeftY+heightt))
        return true;
      else
        return false;
    }

    boolean mouseOverArrow() {
      if (mouseXInSameArea(imgX, imgX+imgW) && mouseYInSameArea(imgY, imgY+imgH))
        return true;
      else
        return false;
    }

    void analyzeArea() {
      //if selected area is above the bar or below the bar
      if ((initmousey.lastElement() < upperLeftY && endmousey.lastElement() < upperLeftY) || 
        (initmousey.lastElement() > upperLeftY + heightt && endmousey.lastElement() > upperLeftY + heightt))
        ;

      else {
        if ((initmousex.lastElement() <= upperLeftX + widthh && endmousex.lastElement() >= upperLeftX) ||
          (initmousex.lastElement() > upperLeftX+widthh && endmousex.lastElement() < upperLeftX)) {
          hasSelectedPortion = true;
          yselect1 = Math.max(initmousey.lastElement(), endmousey.lastElement());
          yselect2 = Math.min(initmousey.lastElement(), endmousey.lastElement());
          //        drawSelectedPortion(p);
        }
      }
    }

    void drawSelectedPortion() {
      //    fill(255,0,0);
      //      rect(upperLeftX, Math.min(initmousey,endmousey), width, Math.abs(yselect2-yselect1));
    }

    boolean inSelectedArea(float valuePos) {
      //    if(yselect1<360 && yselect2>60)
      //      Systeout.println("yes");
      if (valuePos >= yselect2 && valuePos <= yselect1)
        return true;
      if (valuePos >= yselect1 && valuePos <= yselect2)
        return true;
      return false;
    }

    void setYSelects() {
      yselect1 = upperLeftY + heightt;
      yselect2 = upperLeftY;
    }

    void analyzeClick() {
      //    if(endmousex <= upperLeftX + width && endmousex >= upperLeftX &&
      //        endmousey >= upperLeftY && endmousey <= upperLeftY + height){
      hasSelectedPortion = false;
      //      yselect1 = upperLeftY + height;
      //      yselect2 = upperLeftY;
      yselect1 = 0;
      yselect2 = 0;
      //}
    }
  }
//}

