//RAIN - CREDITS: DANIEL SHIFFMAN
class Drop {
  float positionX;
  float x = random(width); 
  float y = random(-500,-50);
  float alpha = 100; 
  
  float z = random(0,20);
  float len = map(z, 0, 20, 10, 30);
  float yspeed = map(z, 0, 20, 1, 8);
  
  void fall() {
    y = y + yspeed;
    float grav = map(z, 0, 20, 0, 0.2);
    yspeed = yspeed + grav;
    
    //SETTING UP RAIN RANGE 
    if (y > height) {
      y = random(-200,-100);
      yspeed = map(z, 0, 20, 1, 8);
    }
     if (umbrellaON == true){
      if (minimumX <= x && x <= maximumX){
        alpha = 0; 
      }
      else{
         alpha = 100; 
      }
    }
    
    else if (umbrellaON == false){
     alpha = 100;
    }
  }

  void show() {
    float thick = map(z, 0, 20, 1, 3);
    strokeWeight(thick);
    stroke(255,alpha);
    line(x,y,x,y+len);
  }

}