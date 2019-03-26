//IMPORTING LIBRARIES (MINIM,BLOB DETECTION, PS3EYE)
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.sound.*;
import processing.video.*;

import blobDetection.*;
import com.thomasdiewald.ps3eye.PS3EyeP5;

SoundFile soundfile;
SoundFile roar; 
BlobDetection theBlobDetection;
PS3EyeP5 ps3eye;

PImage img;
PImage frame01; 
PImage frame1;
PImage frame2;
PImage frame3;
PImage frame4;
PImage frame5;
PImage frame6;
PImage frame7;
PImage frame8;

boolean newFrame=false;

//VARIABLES 
float placeHolderX;
float placeHolderY; 
float object1X;
float object1Y;
float object2X;
float object2Y;
float minimumX;
float maximumX;
float x;
boolean umbrella1 = false;
boolean umbrella2 = false; 
boolean umbrellaON = true; 
boolean glovesON = false; 
float blobDistance = 10; 
float umbrellaDistance = 50;
boolean firstImage = true; 
float totoroXleft;
float totoroXright;
float totoroYleft;
float totoroYright;
boolean showEye; 

PImage destination; 

//INITIALIZING RAIN DROPS
Drop[] drops = new Drop[500];

void setup()
{
  size(1280, 720, P3D);
  //fullScreen();
  
  //PS3EYE SETUP 
  ps3eye = PS3EyeP5.getDevice(this);
  if(ps3eye == null){
    System.out.println("No PS3Eye connected. Good Bye!");
    exit();
    return;
  } 
  ps3eye.start();
  
  //SOUND SETUP 
   soundfile = new SoundFile(this,"rain1.wav");
   roar = new SoundFile(this, "roar.mp3");
   soundfile.loop();
   
  // BLOB DETECTION SETUP 
  // IMG WILL BE SENT TO BLOB DETECTION
  img = new PImage(80,60); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.05f); // DETECTING BRIGHT AREAS WITH LUMINOSITY > 0.2F
  theBlobDetection.setBlobMaxNumber(2);
  theBlobDetection.blobWidthMin=2; 
  theBlobDetection.blobHeightMin=2;
  destination = createImage(80,60,RGB);
  
  //CREATING DROP OBJECTS
  for (int i = 0; i < drops.length; i++) {
    drops[i] = new Drop();
  }
 
  //LOADING ANIMATION FRAMES
  frame01 = loadImage("backgroundfinal.png"); 
  frame1 = loadImage("1totoro.png");
  frame2 = loadImage("2totoro.png");
  frame3 = loadImage("3totoro.png");
  frame4 = loadImage("4totoro.png");
  frame5 = loadImage("5totoro.png");
  frame6 = loadImage("6totoro.png");
  frame7 = loadImage("7totoro.png");
  frame8 = loadImage("8totoro.png");
  
}

void draw(){ 
  //ADJUSTING BRIGTHNESS THRESHOLD OF PIXELS 
  float threshold = 100; 
  PImage cam = ps3eye.getFrame();
  println("cam dimensions");
  println(cam.width+" "+cam.height);  
  
  //BLOB DETECTION 
   newFrame=false;
   img.copy(cam, 0, 0, cam.width, cam.height, 
      0, 0, img.width, img.height);
   fastblur(img, 1);
   destination.loadPixels();
   img.loadPixels();
  
  for (int xvalue = 0; xvalue < img.width; xvalue++) {
    for (int yvalue = 0; yvalue < img.height; yvalue++ ) {
      int loc = xvalue + yvalue*img.width;
      //TEST BRIGHTNESS AGAINST THRESHOLD TO OBTAIN BLOBS
      if (brightness(img.pixels[loc]) > 40) {
        destination.pixels[loc]  = color(255);  // White
      }  else {
        destination.pixels[loc]  = color(0);    // Black
      }
    }
  }

  img.updatePixels();
  destination.updatePixels();
  theBlobDetection.computeBlobs(destination.pixels);
  drawBlobsAndEdges(true,false);
    
  //FIRST LOADING INITIAL FRAME/IMAGE 
  if (firstImage == true){
    image(frame01,0,0,width,height);
    showEye = true; 
  }
  
 //UMBRELLA MODE - CHANGING ANIMATION FRAMES ACCORDING TO USER'S LOCATION 
 if (umbrellaON == true){
    println("UMBRELLA MODE ON, LOADING ANIMATION");
    if (object1X <= 0 && object1X <=132){
      image(frame3,0,0,width,height);
      showEye = true;
    }
    else if (object1X <= 133 && object1X <= 293){
      image(frame4,0,0,width,height);
      showEye = true;
    }
    else if (object1X <= 294 && object1X <= 454){
      image(frame5,0,0,width,height);
      showEye = false;
    }
    else if (object1X <= 455 && object1X <= 614){
    image(frame6,0,0,width,height);
    showEye = false;
    }
    else if (object1X <= 615 && object1X <= 800){
    image(frame7,0,0,width,height);
    showEye = false;
    }
    else if (object1X <= 801 && object1X <= 996){
    image(frame2,0,0,width,height);
    showEye = true;
  }
    else if (object1X <= 997 && object1X <= 1280){
    image(frame01,0,0,width,height);
    showEye = true;
  }
 }
  
  //CREATING RAIN 
    for (int i = 0; i < drops.length; i++) {
      drops[i].fall();
      drops[i].show();
    }
  tint(255,255);
  
  //GLOVES MODE - CHANGING ANIMATION FRAMES ACCORDING TO USER'S LOCATION 
  if (glovesON == true){
    println("GLOVE MODE ON, LOADING ANIMATION");
    if (object1X >= 545 && object1X <= 624 && object1Y >= 122 && object1Y <= 682 || object1X >= 625 && object1X <= 1090 && object1Y >= 122 && object1Y <= 183 || object1X >= 1091 && object1X <= 1155 && object1Y >= 122 && object1Y <= 682 ){
     image(frame2,0,0,width,height);
     showEye = true; 
    }
    else if (object1X >= 625 && object1X <= 668 && object1Y >= 182 && object1Y <= 624 || object1X >= 669 && object1X <= 1045 && object1Y >= 184 && object1Y <= 230 || object1X >= 1046 && object1X <= 1085 && object1Y >= 182 && object1Y <= 624 ){
    image(frame3,0,0,width,height);
    showEye = true;
    }
    else if (object1X >= 668 && object1X <= 736 && object1Y >= 233 && object1Y <= 624 || object1X >= 737 && object1X <= 975 && object1Y >= 231 && object1Y <= 352 || object1X >= 976 && object1X <= 1046 && object1Y >= 233 && object1Y <= 624 ){
    image(frame4,0,0,width,height);
    showEye = true; 
    }
    else if (object1X >= 737 && object1X <= 777 && object1Y >= 353 && object1Y <= 624 || object1X >= 778 && object1X <= 942 && object1Y >= 353 && object1Y <= 383 || object1X >= 943 && object1X <= 974 && object1Y >= 353 && object1Y <= 624 || object1X >= 778 && object1X <= 942 && object1Y >= 524 && object1Y <= 624 ){
    image(frame5,0,0,width,height);
    showEye = false;
    }
    else if (object1X >= 778 && object1X <= 823 && object1Y >= 384 && object1Y <= 520 || object1X >= 824 && object1X <= 900 && object1Y >= 384 && object1Y <= 415 || object1X >= 901 && object1X <= 944 && object1Y >= 384 && object1Y <= 520 || object1X >= 824 && object1X <= 900 && object1Y >= 527 && object1Y <= 624 ){
    image(frame6,0,0,width,height);
    showEye = false;
    roar.play();
    }
    else if (object1X >= 825 && object1X <= 900 && object1Y >= 416 && object1Y <= 527){
    image(frame7,0,0,width,height);
    showEye = false;
    roar.play();
    }
    else{
     image(frame01,0,0,width,height); 
     showEye = true;
    }
  }
  
  //MAKING TOTORO'S EYES FOLLOW USER'S HAND/UMBRELLA
  if (showEye == true){
    totoroXleft = map(object1X,0,1280,775,787);
    totoroYleft = map(object1Y,0,720,175,189);
    
    totoroXright = map(object1X,0,1280,927,940);
    totoroYright = map(object1Y,0,800,176,187);
    
    noStroke();
    fill(0);
    ellipse(totoroXleft,totoroYleft,20,20);
    fill(0);
    ellipse(totoroXright,totoroYright,20,20);
  }
}
  
// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  //
  Blob b;
  EdgeVertex eA,eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++){
    b=theBlobDetection.getBlob(n);
    
    if (b!=null){
      //CREATING BOUNDARIES/TRACKERS FOR GLOVE MODE 
      if ( glovesON == true && theBlobDetection.getBlobNb() == 1){
          println("GLOVE MODE ON");
          object1X = b.x*width;
          object1Y = b.y*height;
        }
      //CREATING BOUNDARIES/TRACKERS FOR UMBRELLA MODE
      else if( umbrellaON == true && theBlobDetection.getBlobNb() == 2){
         println("UMBRELLA MODE ON");
        if (n==0){
          object1X = b.x*width;
          object1Y = b.y*height; 
        }
        else if (n==1){
          object2X = b.x*width;
          object2Y = b.y*height; 
        }
        
      }
       
       //FINDING EDGES OF UMBRELLA 
       if (umbrellaON == true){
             if (object1X < object2X){
               minimumX = object1X;
               maximumX = object2X;
             }
             else{
               minimumX = object2X;
               maximumX = object1X;
             } 
         } 

      //TO DISPLAY EDGES OF UMBRELLA 
      if (drawEdges){
      strokeWeight(3);
      stroke(0,255,0);
       
       for (int m=0;m<b.getEdgeNb();m++){
         eA = b.getEdgeVertexA(m);
         eB = b.getEdgeVertexB(m);
         
         if (eA !=null && eB !=null){
           
           //line(
           //  eA.x*width, eA.y*height, 
           //  eB.x*width, eB.y*height
           //  );
           
         }
       }
      }
      
      // DRAWING BLOBS 
      if (drawBlobs){
        fill(255,150);
        ellipse(b.x*width,b.y*height,30,30);
        strokeWeight(1);
        stroke(255,0,0);
        rect(
          b.xMin*width,b.yMin*height,
          b.w*width,b.h*height
          );
      }
    }
  }
}

// ==================================================
// Super Fast Blur v1.1
// by Mario Klingemann 
// <http://incubator.quasimondo.com>
// ==================================================
void fastblur(PImage img,int radius)
{
 if (radius<1){
    return;
  }
  int w=img.width;
  int h=img.height;
  int wm=w-1;
  int hm=h-1;
  int wh=w*h;
  int div=radius+radius+1;
  int r[]=new int[wh];
  int g[]=new int[wh];
  int b[]=new int[wh];
  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
  int vmin[] = new int[max(w,h)];
  int vmax[] = new int[max(w,h)];
  int[] pix=img.pixels;
  int dv[]=new int[256*div];
  for (i=0;i<256*div;i++){
    dv[i]=(i/div);
  }

  yw=yi=0;

  for (y=0;y<h;y++){
    rsum=gsum=bsum=0;
    for(i=-radius;i<=radius;i++){
      p=pix[yi+min(wm,max(i,0))];
      rsum+=(p & 0xff0000)>>16;
      gsum+=(p & 0x00ff00)>>8;
      bsum+= p & 0x0000ff;
    }
    for (x=0;x<w;x++){

      r[yi]=dv[rsum];
      g[yi]=dv[gsum];
      b[yi]=dv[bsum];

      if(y==0){
        vmin[x]=min(x+radius+1,wm);
        vmax[x]=max(x-radius,0);
      }
      p1=pix[yw+vmin[x]];
      p2=pix[yw+vmax[x]];

      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
      yi++;
    }
    yw+=w;
  }

  for (x=0;x<w;x++){
    rsum=gsum=bsum=0;
    yp=-radius*w;
    for(i=-radius;i<=radius;i++){
      yi=max(0,yp)+x;
      rsum+=r[yi];
      gsum+=g[yi];
      bsum+=b[yi];
      yp+=w;
    }
    yi=x;
    for (y=0;y<h;y++){
      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
      if(x==0){
        vmin[y]=min(y+radius+1,hm)*w;
        vmax[y]=max(y-radius,0)*w;
      }
      p1=x+vmin[y];
      p2=x+vmax[y];

      rsum+=r[p1]-r[p2];
      gsum+=g[p1]-g[p2];
      bsum+=b[p1]-b[p2];

      yi+=w;
    }
  }

}

//CHANGING MODES MANUALLY
void keyPressed(){
  if (key == 'u'){
    umbrellaON = true;
    glovesON = false;
    println("CHANGE TO UMBRELLA, RESTART RAIN TRUE");
  }
 if (key == 'g'){
    umbrellaON = false;
    glovesON = true; 
    println("CHANGE TO GLOVES");
  }
}