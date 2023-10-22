class Module {
  float x;
  float y;
  float lineLength;
  float angle;
  float magnitude;
  float v_x;
  float v_y;
  float n;
  int cell_size;
  int pond;
  float og_angle;
  float r;
  float g;
  float b;
  float xOffset;
  float yOffset;
  float varr;
  float varg;
  float varb;
  float scaling;
  float scaling_pond;
  
  
  Module(float xTemp, float yTemp, float lineLengthTemp, float magnitudeTemp, float v_xTemp, float v_yTemp, float nTemp, int cell_sizeTemp, float br, float bg, float bb){
  //Module(float xTemp, float yTemp, float lineLengthTemp){
    x = xTemp;
    y = yTemp;
    lineLength = lineLengthTemp;
    magnitude = magnitudeTemp;
    v_x = v_xTemp;
    v_y = v_yTemp;
    n = nTemp;
    //xOffset = cell_sizeTemp * random(-0.5, 0.5);
    //yOffset = cell_sizeTemp * random(-0.5, 0.5);
    angle = (float) Math.atan2(v_x, v_y);
    og_angle = (float) Math.atan2(v_x, v_y);
    cell_size = cell_sizeTemp;
    if (random(0.0, 1.1) < 0.5) {
      pond = -1;
    } else {
      pond = 1;
    }
    //r = 230 * random(1.8, 1.2) + 20 * random(0.0, 1.0);
    //g = 200 * random(0.8, 1.2) + 20 * random(0.0, 1.0);
    //b = 70 * random(0.8, 1.2) + 20 * random(0.0, 1.0);
    //r = 23 * random(1.8, 1.2) + 20 * random(0.0, 1.0);
    //g = 230 * random(0.8, 1.2) + 20 * random(0.0, 1.0);
    //b = 170 * random(0.8, 1.2) + 20 * random(0.0, 1.0);
    //r = 23 * n + 20 * n;
    //g = 230 * n + 20 * n;
    //b = 170 * n + 20 * n;
    r = br + 170 * n;
    g = bg + 230 * n;
    b = bb + 170 * n;
    //print(r, g, b, n, "\n");
    varr = 0;
    varg = 0;
    varb = 0;
    scaling = random(0.1, 3.0);
    if (random(0.0, 1.0) < 0.5) {
      scaling_pond = 1;
    } else {
      scaling_pond = -1;
    }
    

// Ensure the angle is in the range [0, 2π] (0 to 360 degrees)
    if (angle < 0) {
        angle += 2 * Math.PI;
    }
  }
  

  
  void update(){
    //angle += 0.003 * pond;
    if ( angle > og_angle + 0.1) {
     // pond *= -1;
    } else if ( angle < og_angle - 0.1) {
     // pond *= -1;
    }
    //r += random(-3.0, 3.0);
    //g += random(-3.0, 3.0);
    //b += random(-3.0, 3.0);
    scaling += 0.01 * scaling_pond;
    if (scaling < 0.1) {
      scaling_pond *= -1;
    }
    else if (scaling > 3) {
      scaling_pond *= -1;
    }
  }
   
  void display(float min_magnitude, float max_magnitude){
    
      float large = log(magnitude / min_magnitude);
      //print(large, "\n");
      stroke(r + varr, g + varg, b + varb);
      strokeWeight(large * 0.5);
      
      pushMatrix();
      translate(x, y);
      rotate(angle);
      scale(scaling);
      //print(scaling, "\n");
      line(-large / 2 * cell_size * 0.2 + xOffset, 0, large / 2 * cell_size * 0.2 + yOffset, 0);
      popMatrix();
  }
  float distance(float x1, float y1, float x2, float y2) {
    float dx = x2 - x1;
    float dy = y2 - y1;
    return sqrt(dx*dx + dy*dy);
  }
  void move(float xelectron, float yelectron) {
    float d = distance(x, y, xelectron, yelectron);
    if (d < 60){
      varr += 15;
      varg += 5;
      varb += 5;
    }
    else {
      varr = 0;
      varg = 0;
      varb = 0;
    }
    
  
  }
}
