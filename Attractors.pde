/*
 
  Thomas Diewald
  25.04.2010
   
  experimenting with Gravity (just for fun)
 
*/
 
//import processing.opengl.*;
import peasy.*;
 
 
PeasyCam cam;
PFont font;
 
int sizeX, sizeY ;
int gridSizeX, gridSizeY;
 
GravityField gF[] = new GravityField[3];
Planet pl[] = new Planet[30];
Grid grid;
 
boolean showGravityFieldLabel = true;
 
boolean RESET = false;
 
 
void setup(){
  if(! RESET){
    //size(800, 600, OPENGL);
    size(800, 600, P3D);
     
    sizeX = width; sizeY = height;
    gridSizeX = int((sizeX + sizeY)/2) ;
    gridSizeY = int((sizeX + sizeY)/2);
 
    //------------------------------------------------------------------------------------------
    // initialize camera ---> needed library: import peasy.*;
    cam = new PeasyCam(this, sizeX/2 , sizeY/2, 0, 600);  // default settings on double click
    cam.setMinimumDistance(.001);
    cam.setMaximumDistance(50000);
    cam.setRotations( -0.7301672, -0.274728, 0.30156484);
  } // end if(! RESET)
   
  //------------------------------------------------------------------------------------------
  // initialize Grid
  int res = 7;
  int gridPointsX = gridSizeX / res;
  int gridPointsY = gridSizeY / res;
  grid = new Grid(gridPointsX, gridPointsY);
  float s = 1.5; // scale Grid
  for(int i = 0; i < gridPointsY; i++){
    for(int j = 0; j < gridPointsX; j++){
      int index = i*gridPointsX + j;
      float x = j * res * s + (sizeX - gridSizeX*s) / 2;
      float y = i * res * s + (sizeY - gridSizeY*s) / 2;
      float z = 0;
      grid.setGridPoint(index, x, y, z);
    } // end for j
  } // end for i
   
   
   
  int border = 0;
  //------------------------------------------------------------------------------------------
  // initialize gravityFields
  for(int i = 0; i < gF.length; i++){
    int id       = i;
    float x      = (200 * i);
    float y      = (200 * i);
    float radius = random(20, 40);
    color col = color( random(200,255), random(200,255),  random(1));
    gF[i] = new GravityField(id, x, y, radius, col);
  } // end for i
   
  //------------------------------------------------------------------------------------------
  // initialize Planets
  for(int i = 0; i < pl.length; i++){
    int id       = i;
    float x      = random(border, gridSizeX-border);
    float y      = random(border, gridSizeY-border);
    float dirX   = random(1,3); //dirX = 2;
    float dirY   = random(0,1); //dirY = 0;
    float radius = random(5,10);
    color col = color( random(110, 255), random(110, 255),  random(110, 220));
    Planet newPlanet = new Planet(id, x, y, dirX, dirY, radius, col);
    newPlanet.assignGravityField(gF[0]);
    pl[i] = newPlanet;
  } // end for i
   
 
   
   
  //------------------------------------------------------------------------------------------
  // font
  //font = loadFont("ArialMT-48.vlw");
  //textFont(font);
   
  frameRate(60);
} // end void setup
   
   
   
   
   
   
 
 
void draw(){
  println(frameRate);
  background(0); noLights();
 
 
  moveAndScaleSpheres(); // if mousePressed and key 'm' is pressed
 
  // calculate the planets new Information
  for(int i = 0; i < pl.length; i++){
    for(int j = 0; j < gF.length; j++)              pl[i].setNewDirection(11500, .5);
    //for(int j = 0; j < pl.length; j++){ if( j != i) pl[i].setNewDirection(pl[j].x, pl[j].y, pl[j].radius, 2000, 1); }
    pl[i].setNewPosition();
    if(frameCount % 500 == 0)
    {
      pl[i].assignGravityField(gF[1]);
    }
    
  } // end for i
   
 
  // calculate the grid deformation
  grid.REsetGridPointPositionZ();
  for(int i = 0; i < gF.length; i++) grid.setGridPointPositionZ( gF[i].x, gF[i].y, gF[i].radius ); 
  for(int i = 0; i < pl.length; i++) grid.setGridPointPositionZ( pl[i].x, pl[i].y, pl[i].radius ); 
 
 
  grid.drawGrid();                                                                 // draw grid
  for(int i = 0; i < gF.length; i++) gF[i].drawSphere(20, 30);                     // draw GravityFields
  for(int i = 0; i < pl.length; i++) pl[i].drawSphere(10, 20);                     // draw Planets
  if (showGravityFieldLabel) for(int i = 0; i < gF.length; i++) gF[i].drawLabel(); // draw GravityFieldsLabel
} // end void draw
 
 
 
 
void keyReleased(){
  if(key == 't'){
    if(showGravityFieldLabel) showGravityFieldLabel = false; else showGravityFieldLabel = true;
  } 
  if(key == 'r') {
    RESET = true;
    setup();
  }
} // end void keyReleased()
 
 
 
 
 
 
 
 
boolean mouseStillPressed = false;
int indexGF = 0; // index of gravityField
int indexGP = 0; // index of gridpoint
 
void moveAndScaleSpheres(){
   
  for(int i = 0; i < gF.length; i++) gF[i].setSelectionState(false);
 
  if (keyPressed ){
    cam.setMouseControlled(false);
    if(key == 'm' || key == 'M'){
      float scrX, scrY, mouseDisShortest;
      if(!mouseStillPressed){
        // find nearest gravityField
        scrX = screenX( gF[indexGF].x, gF[indexGF].y, 0 );
        scrY = screenY( gF[indexGF].x, gF[indexGF].y, 0 );
        mouseDisShortest = sqrt( sq(mouseX - scrX) + sq(mouseY - scrY) );
   
        for(int i = 0; i < gF.length; i++){
          scrX = screenX( gF[i].x, gF[i].y, 0 );
          scrY = screenY( gF[i].x, gF[i].y, 0 );
          float mouseDis = sqrt( sq(mouseX - scrX) + sq(mouseY - scrY) );
          if( mouseDis <= mouseDisShortest){
            indexGF = i; mouseDisShortest = mouseDis;
          }
        } // end for i
        //scrX = screenX( gF[indexGF].x, gF[indexGF].y, 0 );
        //scrY = screenY( gF[indexGF].x, gF[indexGF].y, 0 );
        //cam.beginHUD(); stroke(0,255,255); strokeWeight(10); point(scrX, scrY); cam.endHUD();
      } // end if(!mouseStillPressed){
         
      gF[indexGF].setSelectionState(true);
       
      // find nearest gridpoint
      scrX = screenX( grid.px[indexGP], grid.py[indexGP], 0 );
      scrY = screenY( grid.px[indexGP], grid.py[indexGP], 0  );
      mouseDisShortest = sqrt( sq(mouseX - scrX) + sq(mouseY - scrY) );
      for(int i = 0; i < grid.px.length; i++){
        scrX = screenX( grid.px[i], grid.py[i], 0 );
        scrY = screenY( grid.px[i], grid.py[i], 0  );
        float mouseDis = sqrt( sq(mouseX - scrX) + sq(mouseY - scrY) );
        if( mouseDis <= mouseDisShortest){
          indexGP = i; mouseDisShortest = mouseDis;
        }
      } // end for i
      //scrX = screenX( grid.px[indexGP], grid.py[indexGP], 0 );
      //scrY = screenY( grid.px[indexGP], grid.py[indexGP], 0 );
      //cam.beginHUD(); stroke(0,255,255); strokeWeight(20); point(scrX, scrY);cam.endHUD();
         
      if (mousePressed){
        mouseStillPressed = true;
        if (mouseButton == LEFT){
          float dx = grid.px[indexGP] - gF[indexGF].x;
          float dy = grid.py[indexGP] - gF[indexGF].y;
          gF[indexGF].x += dx/6;
          gF[indexGF].y += dy/6;
        } // end if
        if (mouseButton == RIGHT) {
          gF[indexGF].radius += 1.0*(pmouseY - mouseY)/10.0;
          if( gF[indexGF].radius < 10) gF[indexGF].radius  = 10;
          if( gF[indexGF].radius > 100) gF[indexGF].radius  = 100;
        } // end if
      } else {
        mouseStillPressed = false;
      } // end if else
     
    } // end if (key == 'm' || key == 'M'){
  } else {
    cam.setMouseControlled(true);
  } // end if else
} // end void moveAndScaleSpheres()

class Grid{
  float px[], py[],pz[];
  int gridPointsX, gridPointsY, gridPoints;
   
  Grid(int gridPointsX, int gridPointsY){
    this.gridPointsX = gridPointsX;
    this.gridPointsY = gridPointsY;
    gridPoints = gridPointsX * gridPointsY;
  
    px = new float[gridPoints];
    py = new float[gridPoints];
    pz = new float[gridPoints];
  } // end constructor
   
   
  void setGridPoint(int index, float x, float y, float z){
    px[index] = x;
    py[index] = y;
    pz[index] = z;
  } // end void setGridPoint()
   
   
  void REsetGridPointPositionZ(){
    for(int i = 0; i < gridPoints; i++) pz[i] = 0;
  } // end void REsetGridPointPositionZ()
   
  void setGridPointPositionZ( float gravityX, float gravityY, float radius){
    for(int i = 0; i < gridPoints; i++){
      float dx = gravityX - px[i];
      float dy = gravityY - py[i];
      float dis = sqrt( sq(dx) + sq(dy) );
      pz[i] -= (radius*50)/sqrt( dis* 2 ) -28;
      //pz[i] -= (radius*5)/sq( dis/15 );
    } // end for i
  } // end void setGridPointPositionZ
   
   
  float getAlphaChannel(float v){
    if( v < 0 )
      return map(v, -150, 0, 0, 255);
    else
      return map(v, 0, 30, 255, 0);
    //return 0;
  } // end float getAlphaChannel(float v)
   
   
  void drawGrid(){
    strokeWeight(1);
    float alpaChannel;
 
    for(int i = 0; i < gridPointsY-1; i++){
      for(int j = 0; j < gridPointsX-1; j++){
        float x1 = px[ (i+0) * gridPointsX + (j+0)];
        float y1 = py[ (i+0) * gridPointsX + (j+0)];
        float z1 = pz[ (i+0) * gridPointsX + (j+0)];
        //stroke(255); strokeWeight(1); point(x1,y1,0);  // draw original grid
   
        float x2 = px[ (i+1) * gridPointsX + (j+0)];
        float y2 = py[ (i+1) * gridPointsX + (j+0)];
        float z2 = pz[ (i+1) * gridPointsX + (j+0)];
         
        float x3 = px[ (i+1) * gridPointsX + (j+1)];
        float y3 = py[ (i+1) * gridPointsX + (j+1)];
        float z3 = pz[ (i+1) * gridPointsX + (j+1)];
         
        float x4 = px[ (i+0) * gridPointsX + (j+1)];
        float y4 = py[ (i+0) * gridPointsX + (j+1)];
        float z4 = pz[ (i+0) * gridPointsX + (j+1)];
         
         
        if( z1 > 35 || z2 > 35 || z3 > 35 || z4 > 35) continue;
         
        /*
          stroke( 40, 100, 134, getAlphaChannel( min(z1, z2) ));
        line(x1, y1, z1, x2, y2, z2);
          stroke( 40, 100, 134, getAlphaChannel( min(z1, z4)  ));
        line(x1, y1, z1, x4, y4, z4);
        */
         
        stroke( 40, 100, 134, getAlphaChannel( min(z1, z2, z4) ));  noFill();
        beginShape(); vertex(x4, y4, z4); vertex(x1, y1, z1); vertex(x2, y2, z2); endShape();
         
        //noStroke();
        //beginShape(TRIANGLE_STRIP); vertex(x1, y1, z1); vertex(x2, y2, z2); vertex(x4, y4, z4); vertex(x3, y3, z3); endShape();
      } // end for j
    } // end for i
     
  } // end void drawGrid()
} // end class Grid

class Planet{
  int id;
  float x, y, dirX, dirY, radius;
  color col;
  float colR, colG, colB;
  GravityField assignedGravityField;
  Planet(int id, float x, float y, float dirX, float dirY, float radius, color col){
    this.id     = id;
    this.x      = x;
    this.y      = y;
    this.dirX   = dirX;
    this.dirY   = dirY;
    this.radius = radius;
    this.col    = col;
    colR = red(col);
    colG = green(col);
    colB = blue(col);
  } // end constructor
  
  
  void assignGravityField(GravityField gF)
  {
    this.assignedGravityField = gF;
  }
   
  void setNewDirection(float speed, float disFac){
    float gravityFieldPosX = this.assignedGravityField.x;
    float gravityFieldPosY = this.assignedGravityField.y;
    float gravityFieldRadius = this.assignedGravityField.radius;
    float distanceXY = dist(gravityFieldPosX, gravityFieldPosY, x, y);
    float distanceX = (gravityFieldPosX - x) / distanceXY;
    float distanceY = (gravityFieldPosY - y) / distanceXY;
    dirX += distanceX * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac) / speed; // dirX += distanceX * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac);
    dirY += distanceY * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac) / speed; // dirY += distanceY * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac);
    if(distanceXY < 300 && distanceXY > 250)
    {
      dirX = dirX * .8;
      dirY = dirY * .8;
    }

    //x += dirX / speed;
    //y += dirY / speed;
  } // end void setNewPosition
  
 void setNewDirection(float gravityFieldposX, float gravityFieldPosY, float gravityFieldRadius, float speed, float disFac){
    float distanceXY = dist(gravityFieldposX, gravityFieldPosY, x, y);
    float distanceX = (gravityFieldposX - x) / distanceXY;
    float distanceY = (gravityFieldPosY - y) / distanceXY;
    dirX += distanceX * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac) / speed; // dirX += distanceX * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac);
    dirY += distanceY * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac) / speed; // dirY += distanceY * gravityFieldRadius * 100 / pow(abs(distanceXY),disFac);
    //x += dirX / speed;
    //y += dirY / speed;
  } // end void setNewPosition

   
  void setNewPosition(){
    x += dirX;
    y += dirY;
  } // end void setNewPosition()
  
  
  
  void drawPSphere(){
    fill(col);  
    noStroke();
    pushMatrix();
      translate(x,y);
      sphereDetail(25);
      sphere(radius);
    popMatrix();
  } // end void draw
   
   
   
 
   
  float rotZ = random(3);
  float rotSpeed = random(-0.05, 0.05);
   
  void drawSphere(int heightSteps, int points){
    rotZ += rotSpeed;
    float cx[][] = new float[heightSteps][points], cy[][] = new float[heightSteps][points], cz[][] = new float[heightSteps][points];
 
    for(int i = 0; i < heightSteps; i++){
      float czTmp = radius * cos(i*TWO_PI/(heightSteps-1)/2);
      float radiusTmp = sqrt( sq(radius) - sq(czTmp) );
      for (int j = 0; j < points; j++){
        float cxTmp = radiusTmp * sin(j*TWO_PI/points  + rotZ);
        float cyTmp = radiusTmp * cos(j*TWO_PI/points  + rotZ);
        cx[i][j] = cxTmp + x;
        cy[i][j] = cyTmp + y;
        cz[i][j] = czTmp + 0;
        //stroke(255); strokeWeight(2);
        //point(cxTmp, cyTmp, czTmp);
      } // end for j
      //cz += heightStepsDis;
    } // end for i
     
     
    // draw sphere
    for(int i = 0; i < cx.length-1; i++){
      for(int j = 0; j < cx[i].length; j++){
   
        fill(255 - (i+1)* 255/heightSteps*1.0); 
        fill(colR - (i+1)* colR/heightSteps*1.0, colG - (i+1)* colG/heightSteps*1.0, colB - (i+1)* colB/heightSteps*1.0); 
       
        if( (j) % 2 == 0  && (i) % 2 == 0 ) continue;
        float scaleSphere = 1;
        int indexNext = j+1;
        if (j == cx[i].length-1)indexNext = 0;
        float  x1 = cx[i+0][j+0]       * scaleSphere,    y1 = cy[i+0][j+0]       * scaleSphere, z1  = cz[i+0][j+0]       * scaleSphere;
        float  x2 = cx[i+0][indexNext] * scaleSphere,    y2 = cy[i+0][indexNext] * scaleSphere, z2  = cz[i+0][indexNext] * scaleSphere;
        float  x3 = cx[i+1][indexNext] * scaleSphere,    y3 = cy[i+1][indexNext] * scaleSphere, z3  = cz[i+1][indexNext] * scaleSphere;
        float  x4 = cx[i+1][j+0]       * scaleSphere,    y4 = cy[i+1][j+0]       * scaleSphere, z4  = cz[i+1][j+0]       * scaleSphere;
         
          noStroke();
        beginShape(TRIANGLE_STRIP); vertex(x1, y1, z1); vertex(x2, y2, z2); vertex(x4, y4, z4); vertex(x3, y3, z3); endShape();
          //stroke(0); strokeWeight(0.2);
        //line(x1, y1, z1, x2, y2, z2); line(x2, y2, z2, x3, y3, z3); line(x3, y3, z3, x4, y4, z4); line(x4, y4, z4, x1, y1, z1);
      } // end for j
    } // end for i
  } // end void drawSphere(int heightSteps, int points)
} // end class Planet
class GravityField{
  int id;
  float x, y, radius;
  color col;
  boolean isSelected;
   
  GravityField(int id, float x, float y, float radius, color col){
    this.id     = id;
    this.x      = x;
    this.y      = y;
    this.radius = radius;
    this.col    = col;
  } // end constructor
     
  void setSelectionState(boolean isSelectedNew){
    isSelected = isSelectedNew;
  }
   
     
     
  float rotZ = 0;
  float rotSpeed = random(-0.05, 0.05);
  int sphereRow = 1; //(int)random(8);
  int sphereRowInc = 2;
  int sphereColumn = 1; //(int)random(8);
  int sphereColumnInc = 2;
   
  void drawSphere(int heightSteps, int points){
//    rotZ -= rotSpeed;
 
    float cx[][] = new float[heightSteps][points], cy[][] = new float[heightSteps][points], cz[][] = new float[heightSteps][points];
 
    for(int i = 0; i < heightSteps; i++){
      float czTmp = radius * cos(i*TWO_PI/(heightSteps-1)/2);
      float radiusTmp = sqrt( sq(radius) - sq(czTmp) );
      for (int j = 0; j < points; j++){
        float cxTmp = radiusTmp * sin(j*TWO_PI/points  + rotZ);
        float cyTmp = radiusTmp * cos(j*TWO_PI/points  + rotZ);
        cx[i][j] = cxTmp + x;
        cy[i][j] = cyTmp + y;
        cz[i][j] = czTmp + 0;
        //stroke(255); strokeWeight(2);
        //point(cxTmp, cyTmp, czTmp);
      } // end for j
      //cz += heightStepsDis;
    } // end for i
     
    // draw sphere
    if(frameCount%4 == 0){
      sphereRow += sphereRowInc;
      if( sphereRow >= cx.length-1 || sphereRow <= 0) sphereRowInc *= -1;
       
      sphereColumn += sphereColumnInc;
      if( sphereColumn >= points) sphereColumn = 1;
    }
    for(int i = 0; i < cx.length-1; i++){
      for(int j = 0; j < cx[i].length; j++){
        fill(255 - (i+1)* 255/heightSteps*1.0);   
        if (i == sphereRow || j == sphereColumn)   fill(255 - (i+1)* 255/heightSteps*1.0, 0, 0);
        if (isSelected) fill(255 - (i+1)* 255/heightSteps*1.0, 150 - (i+1)* 150/heightSteps*1.0, 0);
        if (isSelected && (i == sphereRow || j == sphereColumn))   fill(255 - (i+1)* 255/heightSteps*1.0);
        //else continue;
        if( (j) % 2 == 0 && i %2 == 0 ) continue;
        float scaleSphere = 1;
        int indexNext = j+1;
        if (j == cx[i].length-1)indexNext = 0;
        float  x1 = cx[i+0][j+0]       * scaleSphere,    y1 = cy[i+0][j+0]       * scaleSphere, z1  = cz[i+0][j+0]       * scaleSphere;
        float  x2 = cx[i+0][indexNext] * scaleSphere,    y2 = cy[i+0][indexNext] * scaleSphere, z2  = cz[i+0][indexNext] * scaleSphere;
        float  x3 = cx[i+1][indexNext] * scaleSphere,    y3 = cy[i+1][indexNext] * scaleSphere, z3  = cz[i+1][indexNext] * scaleSphere;
        float  x4 = cx[i+1][j+0]       * scaleSphere,    y4 = cy[i+1][j+0]       * scaleSphere, z4  = cz[i+1][j+0]       * scaleSphere;
         
          noStroke();
        beginShape(TRIANGLE_STRIP); vertex(x1, y1, z1); vertex(x2, y2, z2); vertex(x4, y4, z4); vertex(x3, y3, z3); endShape();
          stroke(0); strokeWeight(0.2);
        //line(x1, y1, z1, x2, y2, z2); line(x2, y2, z2, x3, y3, z3); line(x3, y3, z3, x4, y4, z4); line(x4, y4, z4, x1, y1, z1);
      } // end for j
    } // end for i
  } // end void drawSphere(int heightSteps, int points)
     
  
  
  void drawLabel(){
    float gavityValue = int(radius*100);
    gavityValue /= 100;
    String label = "gravityField "+ id + "\n gravity: "+ gavityValue;
    float labelWidth = textWidth(label);
    float textHeight = 8;
    
    pushMatrix();
      translate(x,y, radius + textHeight*3);
      //rotateZ(-rotZ/2);
      pushMatrix();
        rotateX(-HALF_PI);
        fill(0);
        rect(- labelWidth/2 - 2, -textHeight -1.5 ,labelWidth+4, textHeight*2 + 6);
        translate(0,0,.1);
        fill(255);
        textSize(textHeight); textAlign(CENTER);
        text(label, 0, 0, 0);
      popMatrix();
       
      rotateZ(PI);
      pushMatrix();
        rotateX(-HALF_PI);
        translate(0,0,.1);
        fill(255);
        textSize(textHeight); textAlign(CENTER);
        text(label, 0, 0, 0);
      popMatrix();
    popMatrix();
     
  }
} // end class GravityField


