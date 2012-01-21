class Attractor{
  int id;
  float radius;
  PVector location;
  float density = 1;
  color col;
  boolean isSelected;
  float minimumDistance = 0;
   
  Attractor(int id, PVector location, float radius, color col){
    this.id     = id;
    this.location = location;
    this.radius = radius;
    this.col    = col;
  } // end constructor
  
  void setDensity(float density)
  {
    this.density = density;
  }
  
  /*
  * Set a distance at which the attractors force will result in 
  * a vector 90 degrees from the approach angle. This will allow for 'orbits'
  */
  void setMinimumDistance(float minimumDistance)
  {
    this.minimumDistance = minimumDistance;
  }
     
  void setSelectionState(boolean isSelectedNew){
    isSelected = isSelectedNew;
  }
  
  /**
  * Based on the density of the attractor calculate the acceleration
  * vector for the given target
  * @param PVector target
  * @return PVector 
  */
  PVector getForce(PVector target)
  {
    PVector force = PVector.sub(this.location, target);
    // Using the distance of the force vector determine the correct magnitude
    float distance = force.mag();

    float forceMagnitude = this.density / pow(distance, .9);
    println(forceMagnitude);
    force.normalize();
    force.mult(forceMagnitude);
    
    // if we have a minimum distance and are within that distance
    // redirect the particle
    if(this.minimumDistance > 0 && distance < this.minimumDistance)
    {
      float theta = atan2(force.y, force.x);
      theta = radians(degrees(theta) + 45);
      force.x = cos(theta) * force.x + sin(theta) * force.y;
      force.y = cos(theta) * force.y - sin(theta) * force.x; 
      force.mult(this.density / pow(distance, 2));
    }

    return force;
  }
   
     
     
  float rotZ = 0;
  float rotSpeed = random(-0.05, 0.05);
  int sphereRow = 1; //(int)random(8);
  int sphereRowInc = 2;
  int sphereColumn = 1; //(int)random(8);
  int sphereColumnInc = 2;
   
  void drawSphere(int heightSteps, int points){
//    rotZ -= rotSpeed;
    float x = this.location.x;
    float y = this.location.y;
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
    String label = "Attractor "+ id + "\n gravity: "+ gavityValue;
    float labelWidth = textWidth(label);
    float textHeight = 8;
    
    pushMatrix();
      translate(this.location.x, this.location.y, radius + textHeight*3);
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
} // end class Attractor

