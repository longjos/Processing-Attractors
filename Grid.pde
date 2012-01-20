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
