class Planet{
  int id;
  float x, y, dirX, dirY, radius;
  color col;
  float colR, colG, colB;
  float maxSpeed = 0;
  
  ArrayList accelerationToApply = new ArrayList();
  
  PVector currentVelocity = new PVector(0,0);
  PVector currentLocation = new PVector(0,0);
  
  boolean showAccelerationVectors = false;
  
  
  Attractor assignedAttractor;
  
  Planet(int id, PVector location, PVector initialVelocity, float radius, color col){
    this.id     = id;
    this.currentLocation = location;
    this.currentVelocity = initialVelocity;
    this.radius = radius;
    this.col    = col;
    colR = red(col);
    colG = green(col);
    colB = blue(col);
    

    
  } // end constructor
  
  
  void addAcceleration(PVector newVector)
  {
    this.accelerationToApply.add(newVector); 
  }
  
  void setMaxSpeed(int maxSpeed)
  {
    this.maxSpeed = maxSpeed;
  }
  
  
  void assignAttractor(Attractor gF)
  {
    this.assignedAttractor = gF;
  }
  
  void applyForces()
  {
    // Current Velocity is the sum of all acceleration vectors
    PVector totalAcceleration = new PVector(0,0);
   for(int i = 0; i < this.accelerationToApply.size(); i++)
   {
     PVector forceVector = (PVector) accelerationToApply.get(i);
     totalAcceleration.add(forceVector);
     if(this.showAccelerationVectors)
     {
       stroke(200,200,1); 
       line(this.currentLocation.x, this.currentLocation.y, this.currentLocation.z, (this.currentLocation.x + forceVector.x), (this.currentLocation.y + forceVector.y), (this.currentLocation.z + forceVector.z));
     }
   } 
    //totalAcceleration.limit(100);
    this.currentVelocity.add(totalAcceleration); 
    this.currentVelocity.limit(this.maxSpeed);
    this.accelerationToApply.clear();
  }
  
  void calculatePosition()
  {
      this.applyForces();
      // Position is the current position vector plus the velocity vector
      this.currentLocation.add(this.currentVelocity);
  }


   
void drawPSphere(){
    fill(col);  
    stroke(col);
    strokeWeight(2);
    //noStroke();
    pushMatrix();
      translate(this.currentLocation.x, this.currentLocation.y, this.currentLocation.z);
      //sphereDetail(25);
      //sphere(radius);
      //ellipse(0,0, radius, radius);
      
      point(0,0,0);
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
