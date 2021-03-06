//import processing.opengl.*;
import peasy.*;
 
 
PeasyCam cam;
PFont font;
 
int sizeX, sizeY ;
int gridSizeX, gridSizeY;
 
Attractor gF[] = new Attractor[3];
Planet pl[] = new Planet[10000];
Grid grid;

boolean showAccelerationVectors = false;

Attractor sun;
 
boolean showAttractorLabel = true;
 
boolean RESET = false;
 
 
void setup(){
  if(! RESET){
  //  size(800, 600, OPENGL);
    size(800, 800, P3D);
     
    sizeX = width; sizeY = height;
    gridSizeX = int((sizeX + sizeY)/2) ;
    gridSizeY = int((sizeX + sizeY)/2);
 
    //------------------------------------------------------------------------------------------
    // initialize camera ---> needed library: import peasy.*;
    cam = new PeasyCam(this, sizeX/2 , sizeY/2, 0, 1200);  // default settings on double click
    cam.setMinimumDistance(.001);
    cam.setMaximumDistance(50000);
    cam.setRotations( -0.7301672, -0.274728, 0.30156484);
  } // end if(! RESET)
    
  int border = 0;
  //------------------------------------------------------------------------------------------
  // initialize Attractors
  for(int i = 0; i < gF.length; i++){
    int id       = i;
    float x      = (400 * i);
    float y      = (400 * i);
    float radius = random(20, 40);
    color col = color( random(200,255), random(200,255),  random(1));
    Attractor nextAttractor = new Attractor(id, new PVector(x,y), radius, col);
    nextAttractor.setDensity(100);
    //nextAttractor.setMinimumDistance(100);
    gF[i] = nextAttractor;
  } // end for i
  
  this.sun = new Attractor(99, new PVector((width/2), 0), 1, color(200,200,1));
  this.sun.setDensity(10);
   
  //------------------------------------------------------------------------------------------
  // initialize Planets
  for(int i = 0; i < pl.length; i++){
    int id       = i;
    PVector initialLocation = new PVector(random(border, gridSizeX-border), random(border, gridSizeY-border), random(0, 600));
    PVector initialVelocity = new PVector(random(0,3), random(0,1));
    float radius = random(5,10);
    color col = color( random(110, 255), random(110, 255),  random(110, 220));
    Planet newPlanet = new Planet(id, initialLocation, initialVelocity, radius, col);
    newPlanet.setMaxSpeed(50);
    newPlanet.assignAttractor(gF[0]);
    pl[i] = newPlanet;
  } // end for i
      
  //------------------------------------------------------------------------------------------
  // font
  //font = loadFont("ArialMT-48.vlw");
  //textFont(font);
   
  frameRate(60);
} // end void setup
   
 
void draw(){
  //println(frameRate);
  background(0); noLights();
 
 
  moveAndScaleSpheres(); // if mousePressed and key 'm' is pressed
 
  // calculate the planets new Information
  for(int i = 0; i < pl.length; i++){
    
    //for(int j = 0; j < gF.length; j++)
    //{
    //  PVector accel = gF[j].getForce(pl[i].currentLocation);
    // pl[i].addAcceleration(accel);
    //};
    
    // Use my assigned Attractor and apply the force
 
     PVector accel = pl[i].assignedAttractor.getForce(pl[i].currentLocation);
     pl[i].addAcceleration(accel);
    
    
    // Add a constant acceleration to help control the system
    
    PVector normalAcceleration = this.sun.getForce(pl[i].currentLocation);
    pl[i].addAcceleration(normalAcceleration);
    
    pl[i].calculatePosition();


    if(frameCount % 500 == 0)
    {
      pl[i].assignAttractor(gF[2]);
    }
    
  } // end for i
   
 

  for(int i = 0; i < gF.length; i++) gF[i].drawSphere(20, 30);                     // draw Attractors
  for(int i = 0; i < pl.length; i++) pl[i].drawPSphere();
  
  if (showAttractorLabel) for(int i = 0; i < gF.length; i++) gF[i].drawLabel(); // draw AttractorsLabel
} // end void draw
 
void keyReleased(){
  if(key == 't'){
    if(showAttractorLabel) showAttractorLabel = false; else showAttractorLabel = true;
  } 
  if(key == 'r') {
    RESET = true;
    setup();
  }
} // end void keyReleased()
 
boolean mouseStillPressed = false;
int indexGF = 0; // index of Attractor
int indexGP = 0; // index of gridpoint
 
void moveAndScaleSpheres(){
   
  for(int i = 0; i < gF.length; i++) gF[i].setSelectionState(false);
 
  if (keyPressed ){
    cam.setMouseControlled(false);
    if(key == 'm' || key == 'M'){
      float scrX, scrY, mouseDisShortest;
      if(!mouseStillPressed){
        // find nearest Attractor
        scrX = screenX( gF[indexGF].location.x, gF[indexGF].location.y, 0 );
        scrY = screenY( gF[indexGF].location.x, gF[indexGF].location.y, 0 );
        mouseDisShortest = sqrt( sq(mouseX - scrX) + sq(mouseY - scrY) );
   
        for(int i = 0; i < gF.length; i++){
          scrX = screenX( gF[i].location.x, gF[i].location.y, 0 );
          scrY = screenY( gF[i].location.x, gF[i].location.y, 0 );
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
          float dx = grid.px[indexGP] - gF[indexGF].location.x;
          float dy = grid.py[indexGP] - gF[indexGF].location.y;
          gF[indexGF].location.x += dx/6;
          gF[indexGF].location.y += dy/6;
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








